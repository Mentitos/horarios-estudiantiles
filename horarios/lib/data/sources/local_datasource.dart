import 'package:isar/isar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

import '../models/materia.dart';
import '../models/carrera.dart';
import '../models/horario_usuario.dart';
import '../models/perfil_usuario.dart';
import '../models/materia_notas.dart';
import '../models/materia_custom.dart';
import 'github_datasource.dart';

class LocalDatasource {
  static const String _isFetchedKey = 'datos_cargados';
  late Future<Isar>? db;

  static final List<Materia> _mockMaterias = [];
  static final List<Carrera> _mockCarreras = [];
  static final List<MateriaCustom> _mockCustoms = [];

  LocalDatasource() {
    if (!kIsWeb) {
      db = _initDb();
    } else {
      db = null;
    }
  }

  Future<Isar> _initDb() async {
    if (Isar.instanceNames.isNotEmpty) {
      return Isar.getInstance()!;
    }

    final dir = await getApplicationDocumentsDirectory();
    return await Isar.open([
      MateriaSchema,
      CarreraSchema,
      HorarioUsuarioSchema,
      PerfilUsuarioSchema,
      MateriaNotasSchema,
      MateriaCustomSchema,
    ], directory: dir.path);
  }

  Future<bool> datosFueronCargados() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isFetchedKey) ?? false;
  }

  Future<void> marcarDatosCargados() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isFetchedKey, true);
  }

  Future<void> forzarRecarga() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_isFetchedKey);

    if (kIsWeb) {
      _mockMaterias.clear();
      _mockCarreras.clear();
      return;
    }

    final isar = await db!;
    await isar.writeTxn(() async {
      await isar.materias.clear();
      await isar.carreras.clear();
    });
  }

  Future<void> guardarMaterias(List<Materia> materias) async {
    if (kIsWeb) {
      _mockMaterias.clear();
      _mockMaterias.addAll(materias);
      return;
    }
    final isar = await db!;
    await isar.writeTxn(() async {
      await isar.materias.putAll(materias);
    });
  }

  Future<void> guardarCarreras(List<Carrera> carreras) async {
    if (kIsWeb) {
      _mockCarreras.clear();
      _mockCarreras.addAll(carreras);
      return;
    }
    final isar = await db!;
    await isar.writeTxn(() async {
      await isar.carreras.putAll(carreras);
    });
  }

  Future<List<Carrera>> leerTodasLasCarreras() async {
    if (kIsWeb) return List.from(_mockCarreras);
    final isar = await db!;
    return await isar.carreras.where().findAll();
  }

  Future<Carrera?> leerCarreraPorNombre(String nombre) async {
    if (kIsWeb) {
      return _mockCarreras.cast<Carrera?>().firstWhere(
        (c) => c?.nombre == nombre,
        orElse: () => null,
      );
    }
    final isar = await db!;
    return await isar.carreras.where().nombreEqualTo(nombre).findFirst();
  }

  Future<Materia?> leerMateriaPorId(String idMateria) async {
    if (kIsWeb) {
      return _mockMaterias.cast<Materia?>().firstWhere(
        (m) => m?.materiaId == idMateria,
        orElse: () => null,
      );
    }
    final isar = await db!;
    return await isar.materias.where().materiaIdEqualTo(idMateria).findFirst();
  }

  Future<MateriaNotas?> leerNotasPorMateriaId(String materiaId) async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      final content = prefs.getString('notas_$materiaId');
      if (content == null) return null;
      return MateriaNotas(
        materiaId: materiaId,
        contenido: content,
        ultimaActualizacion: DateTime.now(),
      );
    }
    final isar = await db!;
    return await isar.materiaNotas
        .where()
        .materiaIdEqualTo(materiaId)
        .findFirst();
  }

  Future<void> guardarNotasMateria(MateriaNotas notas) async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('notas_${notas.materiaId}', notas.contenido);
      return;
    }
    final isar = await db!;
    await isar.writeTxn(() async {
      await isar.materiaNotas.put(notas);
    });
  }

  Future<List<MateriaCustom>> leerMateriasCustom() async {
    if (kIsWeb) return List.from(_mockCustoms);
    final isar = await db!;
    return await isar.materiaCustoms.where().findAll();
  }

  Future<void> guardarMateriaCustom(MateriaCustom custom) async {
    if (kIsWeb) {
      _mockCustoms.removeWhere((c) => c.materiaId == custom.materiaId);
      _mockCustoms.add(custom);
      return;
    }
    final isar = await db!;
    await isar.writeTxn(() async {
      await isar.materiaCustoms.put(custom);
    });
  }

  Future<void> eliminarMateriaCustom(String materiaId) async {
    if (kIsWeb) {
      _mockCustoms.removeWhere((c) => c.materiaId == materiaId);
      return;
    }
    final isar = await db!;
    await isar.writeTxn(() async {
      await isar.materiaCustoms.where().materiaIdEqualTo(materiaId).deleteAll();
    });
  }

  Future<void> limpiarMateriasOcultas() async {
    if (kIsWeb) {
      for (var oculta in _mockCustoms.where((c) => c.estaOculta)) {
        oculta.estaOculta = false;
      }
      return;
    }
    final isar = await db!;
    await isar.writeTxn(() async {
      final ocultas = await isar.materiaCustoms
          .where()
          .filter()
          .estaOcultaEqualTo(true)
          .findAll();
      for (var oculta in ocultas) {
        oculta.estaOculta = false;
      }
      await isar.materiaCustoms.putAll(ocultas);
    });
  }

  Future<void> prepopulateDemoData() async {
    if (await datosFueronCargados() && !kIsWeb) return;

    final github = GithubDatasource();
    try {
      final datos = await github.fetchDatos();
      await guardarMaterias(datos.materias);
      await guardarCarreras(datos.carreras);
      await marcarDatosCargados();
      debugPrint('Datos de demo pre-cargados exitosamente.');
    } catch (e) {
      debugPrint('Error al pre-cargar datos de demo: $e');
    }
  }
}
