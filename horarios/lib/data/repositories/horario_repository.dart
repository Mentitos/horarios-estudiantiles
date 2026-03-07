import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';

import '../models/materia.dart';
import '../models/horario_usuario.dart';
import '../models/materia_notas.dart';
import '../sources/local_datasource.dart';

class HorarioRepository {
  final LocalDatasource _localDatasource;

  HorarioRepository({LocalDatasource? localDatasource})
    : _localDatasource = localDatasource ?? LocalDatasource();

  static const List<int> _coloresMateria = [
    0xFF1E88E5,
    0xFFD32F2F,
    0xFF43A047,
    0xFF8E24AA,
    0xFF00ACC1,
    0xFFF4511E,
    0xFF3949AB,
    0xFF00897B,
    0xFF5E35B1,
    0xFFE53935,
    0xFF039BE5,
    0xFF6D4C41,
  ];

  int _asignarColor(int indice) {
    return _coloresMateria[indice % _coloresMateria.length];
  }

  bool _seSolapan(BloqueHorario a, BloqueHorario b) {
    if (a.dia != b.dia) return false;

    int minAInicio = _parseTiempo(a.horaInicio!);
    int minAFin = _parseTiempo(a.horaFin!);
    int minBInicio = _parseTiempo(b.horaInicio!);
    int minBFin = _parseTiempo(b.horaFin!);

    return (minAInicio < minBFin) && (minAFin > minBInicio);
  }

  int _parseTiempo(String horaAAMM) {
    final partes = horaAAMM.split(':');
    final horas = int.parse(partes[0]);
    final minutos = int.parse(partes[1]);
    return (horas * 60) + minutos;
  }

  Future<HorarioUsuario?> obtenerHorario() async {
    if (kIsWeb) {
      return _webMockHorario;
    }
    final isar = await _localDatasource.db!;
    return await isar.horarioUsuarios.where().findFirst();
  }

  static HorarioUsuario? _webMockHorario;

  Future<HorarioUsuario> crearHorarioVacio(String titulo) async {
    final nuevoHorario = HorarioUsuario()
      ..titulo = titulo
      ..fechaActualizacion = DateTime.now()
      ..materiasSeleccionadas = [];

    if (kIsWeb) {
      _webMockHorario = nuevoHorario;
      return nuevoHorario;
    }

    final isar = await _localDatasource.db!;
    await isar.writeTxn(() async {
      await isar.horarioUsuarios.put(nuevoHorario);
    });

    return nuevoHorario;
  }

  Future<void> agregarMateria(Materia materia) async {
    var rHorario = await obtenerHorario();
    if (rHorario == null) {
      rHorario = await crearHorarioVacio('Mi Horario');
    }

    final existe = rHorario.materiasSeleccionadas.any(
      (m) => m.materiaId == materia.materiaId,
    );
    if (existe) return;

    final colorAsignado = _asignarColor(rHorario.materiasSeleccionadas.length);

    final seleccionada = MateriaSeleccionada()
      ..materiaId = materia.materiaId
      ..materiaNombre = materia.nombre
      ..colorARGB = colorAsignado
      ..bloques = [];

    rHorario.materiasSeleccionadas = List.from(rHorario.materiasSeleccionadas)
      ..add(seleccionada);
    rHorario.fechaActualizacion = DateTime.now();

    if (kIsWeb) {
      _webMockHorario = rHorario;
      return;
    }

    final isar = await _localDatasource.db!;
    await isar.writeTxn(() async {
      await isar.horarioUsuarios.put(rHorario!);
    });
  }

  Future<void> eliminarMateria(String materiaId) async {
    final rHorario = await obtenerHorario();
    if (rHorario == null) return;

    rHorario.materiasSeleccionadas = rHorario.materiasSeleccionadas
        .where((m) => m.materiaId != materiaId)
        .toList();
    rHorario.fechaActualizacion = DateTime.now();

    if (kIsWeb) {
      _webMockHorario = rHorario;
      return;
    }

    final isar = await _localDatasource.db!;
    await isar.writeTxn(() async {
      await isar.horarioUsuarios.put(rHorario);
    });
  }

  Future<void> agregarBloque(
    String materiaId,
    BloqueHorario nuevoBloque,
  ) async {
    final rHorario = await obtenerHorario();
    if (rHorario == null) throw Exception('Horario no encontrado');

    final indiceMateria = rHorario.materiasSeleccionadas.indexWhere(
      (m) => m.materiaId == materiaId,
    );
    if (indiceMateria == -1) {
      throw Exception('Materia $materiaId no está en este horario');
    }

    for (var mat in rHorario.materiasSeleccionadas) {
      for (var b in mat.bloques) {
        if (_seSolapan(b, nuevoBloque)) {
          throw Exception(
            'Solapamiento detectado el ${b.dia} con "${mat.materiaNombre ?? 'Desconocida'}" de ${b.horaInicio} a ${b.horaFin}',
          );
        }
      }
    }

    final materiaUpdate = rHorario.materiasSeleccionadas[indiceMateria];
    materiaUpdate.bloques = List.from(materiaUpdate.bloques)..add(nuevoBloque);

    rHorario.materiasSeleccionadas = List.from(rHorario.materiasSeleccionadas);
    rHorario.materiasSeleccionadas[indiceMateria] = materiaUpdate;
    rHorario.fechaActualizacion = DateTime.now();

    if (kIsWeb) {
      _webMockHorario = rHorario;
      return;
    }

    final isar = await _localDatasource.db!;
    await isar.writeTxn(() async {
      await isar.horarioUsuarios.put(rHorario);
    });
  }

  Future<void> actualizarBloque(
    String materiaId,
    int indiceBloque,
    BloqueHorario nuevoBloque,
  ) async {
    final rHorario = await obtenerHorario();
    if (rHorario == null) throw Exception('Horario no encontrado');

    final indiceMateria = rHorario.materiasSeleccionadas.indexWhere(
      (m) => m.materiaId == materiaId,
    );
    if (indiceMateria == -1) {
      throw Exception('Materia $materiaId no está en este horario');
    }

    for (var mat in rHorario.materiasSeleccionadas) {
      for (int i = 0; i < mat.bloques.length; i++) {
        if (mat.materiaId == materiaId && i == indiceBloque) continue;

        final b = mat.bloques[i];
        if (_seSolapan(b, nuevoBloque)) {
          throw Exception(
            'Solapamiento detectado el ${b.dia} con "${mat.materiaNombre ?? 'Desconocida'}" de ${b.horaInicio} a ${b.horaFin}',
          );
        }
      }
    }

    final materiaUpdate = rHorario.materiasSeleccionadas[indiceMateria];
    final nuevosBloques = List<BloqueHorario>.from(materiaUpdate.bloques);
    nuevosBloques[indiceBloque] = nuevoBloque;
    materiaUpdate.bloques = nuevosBloques;

    rHorario.materiasSeleccionadas = List.from(rHorario.materiasSeleccionadas);
    rHorario.materiasSeleccionadas[indiceMateria] = materiaUpdate;
    rHorario.fechaActualizacion = DateTime.now();

    if (kIsWeb) {
      _webMockHorario = rHorario;
      return;
    }

    final isar = await _localDatasource.db!;
    await isar.writeTxn(() async {
      await isar.horarioUsuarios.put(rHorario);
    });
  }

  Future<void> eliminarBloque(String materiaId, int indiceBloqueLocal) async {
    final rHorario = await obtenerHorario();
    if (rHorario == null) throw Exception('Horario no encontrado');

    final indiceMateria = rHorario.materiasSeleccionadas.indexWhere(
      (m) => m.materiaId == materiaId,
    );
    if (indiceMateria == -1) {
      throw Exception('Materia $materiaId no está en este horario');
    }

    final materiaUpdate = rHorario.materiasSeleccionadas[indiceMateria];
    materiaUpdate.bloques = List.from(materiaUpdate.bloques)
      ..removeAt(indiceBloqueLocal);

    rHorario.materiasSeleccionadas = List.from(rHorario.materiasSeleccionadas);
    rHorario.materiasSeleccionadas[indiceMateria] = materiaUpdate;
    rHorario.fechaActualizacion = DateTime.now();

    if (kIsWeb) {
      _webMockHorario = rHorario;
      return;
    }

    final isar = await _localDatasource.db!;
    await isar.writeTxn(() async {
      await isar.horarioUsuarios.put(rHorario);
    });
  }

  Future<void> eliminarHorario() async {
    if (kIsWeb) {
      _webMockHorario = null;
      return;
    }
    final isar = await _localDatasource.db!;
    await isar.writeTxn(() async {
      await isar.horarioUsuarios.clear();
    });
  }

  Future<void> actualizarMateria(
    String materiaId,
    String nuevoNombre,
    List<String> nuevosProfesores,
    String nuevoAula,
    int nuevoColorARGB,
  ) async {
    final rHorario = await obtenerHorario();
    if (rHorario == null) throw Exception('Horario no encontrado');

    final indice = rHorario.materiasSeleccionadas.indexWhere(
      (m) => m.materiaId == materiaId,
    );
    if (indice == -1) return;

    final materiaAActualizar = rHorario.materiasSeleccionadas[indice];
    materiaAActualizar.materiaNombre = nuevoNombre;
    materiaAActualizar.profesores = List.from(nuevosProfesores);
    materiaAActualizar.aula = nuevoAula;
    materiaAActualizar.colorARGB = nuevoColorARGB;

    rHorario.materiasSeleccionadas = List.from(rHorario.materiasSeleccionadas);
    rHorario.materiasSeleccionadas[indice] = materiaAActualizar;
    rHorario.fechaActualizacion = DateTime.now();

    if (kIsWeb) {
      _webMockHorario = rHorario;
      return;
    }

    final isar = await _localDatasource.db!;
    await isar.writeTxn(() async {
      await isar.horarioUsuarios.put(rHorario);
    });
  }

  Future<String> obtenerNotasMateria(String materiaId) async {
    final notas = await _localDatasource.leerNotasPorMateriaId(materiaId);
    return notas?.contenido ?? '';
  }

  Future<void> guardarNotasMateria(String materiaId, String contenido) async {
    final notas = MateriaNotas(
      materiaId: materiaId,
      contenido: contenido,
      ultimaActualizacion: DateTime.now(),
    );

    if (!kIsWeb) {
      final isar = await _localDatasource.db!;
      final existente = await isar.materiaNotas
          .where()
          .materiaIdEqualTo(materiaId)
          .findFirst();
      if (existente != null) {
        notas.id = existente.id;
      }
    }

    await _localDatasource.guardarNotasMateria(notas);
  }

  Future<void> actualizarNotasMateria(
    String materiaId,
    String nuevasNotas,
  ) async {
    await guardarNotasMateria(materiaId, nuevasNotas);

    final rHorario = await obtenerHorario();
    if (rHorario == null) return;

    final index = rHorario.materiasSeleccionadas.indexWhere(
      (m) => m.materiaId == materiaId,
    );
    if (index == -1) return;

    final original = rHorario.materiasSeleccionadas[index];
    final nuevaMateria = MateriaSeleccionada()
      ..materiaId = original.materiaId
      ..materiaNombre = original.materiaNombre
      ..colorARGB = original.colorARGB
      ..profesores = List.from(original.profesores)
      ..aula = original.aula
      ..bloques = List.from(original.bloques)
      ..notas = nuevasNotas;

    final nuevasMaterias = List<MateriaSeleccionada>.from(
      rHorario.materiasSeleccionadas,
    );
    nuevasMaterias[index] = nuevaMateria;

    rHorario.materiasSeleccionadas = nuevasMaterias;
    rHorario.fechaActualizacion = DateTime.now();

    if (kIsWeb) {
      _webMockHorario = rHorario;
      return;
    }

    final isar = await _localDatasource.db!;
    await isar.writeTxn(() async {
      await isar.horarioUsuarios.put(rHorario);
    });
  }
}
