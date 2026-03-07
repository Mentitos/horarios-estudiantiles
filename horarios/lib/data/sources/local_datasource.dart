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
  late Future<Isar> db;

  LocalDatasource() {
    db = _initDb();
  }

  Future<Isar> _initDb() async {
    if (Isar.instanceNames.isNotEmpty) {
      return Isar.getInstance()!;
    }

    if (kIsWeb) {
      return await Isar.open([
        MateriaSchema,
        CarreraSchema,
        HorarioUsuarioSchema,
        PerfilUsuarioSchema,
        MateriaNotasSchema,
        MateriaCustomSchema,
      ], directory: '');
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

    final isar = await db;
    await isar.writeTxn(() async {
      await isar.materias.clear();
      await isar.carreras.clear();
    });
  }

  Future<void> guardarMaterias(List<Materia> materias) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.materias.putAll(materias);
    });
  }

  Future<void> guardarCarreras(List<Carrera> carreras) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.carreras.putAll(carreras);
    });
  }

  Future<List<Carrera>> leerTodasLasCarreras() async {
    final isar = await db;
    return await isar.carreras.where().findAll();
  }

  Future<Carrera?> leerCarreraPorNombre(String nombre) async {
    final isar = await db;
    return await isar.carreras.where().nombreEqualTo(nombre).findFirst();
  }

  Future<Materia?> leerMateriaPorId(String idMateria) async {
    final isar = await db;
    return await isar.materias.where().materiaIdEqualTo(idMateria).findFirst();
  }

  Future<MateriaNotas?> leerNotasPorMateriaId(String materiaId) async {
    final isar = await db;
    return await isar.materiaNotas
        .where()
        .materiaIdEqualTo(materiaId)
        .findFirst();
  }

  Future<void> guardarNotasMateria(MateriaNotas notas) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.materiaNotas.put(notas);
    });
  }

  Future<List<MateriaCustom>> leerMateriasCustom() async {
    final isar = await db;
    return await isar.materiaCustoms.where().findAll();
  }

  Future<void> guardarMateriaCustom(MateriaCustom custom) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.materiaCustoms.put(custom);
    });
  }

  Future<void> eliminarMateriaCustom(String materiaId) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.materiaCustoms.where().materiaIdEqualTo(materiaId).deleteAll();
    });
  }

  Future<void> limpiarMateriasOcultas() async {
    final isar = await db;
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
    if (await datosFueronCargados()) return;

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
