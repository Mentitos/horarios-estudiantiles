import 'package:isar/isar.dart';

import '../models/horario_usuario.dart';
import '../models/materia.dart';
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
    final isar = await _localDatasource.db;
    return await isar.horarioUsuarios.where().findFirst();
  }

  Future<HorarioUsuario> crearHorarioVacio(String titulo) async {
    final isar = await _localDatasource.db;

    final nuevoHorario = HorarioUsuario()
      ..titulo = titulo
      ..fechaActualizacion = DateTime.now()
      ..materiasSeleccionadas = [];

    await isar.writeTxn(() async {
      await isar.horarioUsuarios.put(nuevoHorario);
    });

    return nuevoHorario;
  }

  Future<void> agregarMateria(int horarioId, Materia materia) async {
    final isar = await _localDatasource.db;
    final rHorario = await isar.horarioUsuarios.get(horarioId);

    if (rHorario == null) throw Exception('Horario no encontrado');

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

    await isar.writeTxn(() async {
      await isar.horarioUsuarios.put(rHorario);
    });
  }

  Future<void> eliminarMateria(int horarioId, String materiaId) async {
    final isar = await _localDatasource.db;
    final rHorario = await isar.horarioUsuarios.get(horarioId);

    if (rHorario == null) throw Exception('Horario no encontrado');

    rHorario.materiasSeleccionadas = rHorario.materiasSeleccionadas
        .where((m) => m.materiaId != materiaId)
        .toList();
    rHorario.fechaActualizacion = DateTime.now();

    await isar.writeTxn(() async {
      await isar.horarioUsuarios.put(rHorario);
    });
  }

  Future<void> agregarBloque(
    int horarioId,
    String materiaId,
    BloqueHorario nuevoBloque,
  ) async {
    final isar = await _localDatasource.db;
    final rHorario = await isar.horarioUsuarios.get(horarioId);

    if (rHorario == null) throw Exception('Horario no encontrado');

    final indiceMateria = rHorario.materiasSeleccionadas.indexWhere(
      (m) => m.materiaId == materiaId,
    );
    if (indiceMateria == -1) {
      throw Exception('Materia \$materiaId no está en este horario');
    }

    for (var mat in rHorario.materiasSeleccionadas) {
      for (var b in mat.bloques) {
        if (_seSolapan(b, nuevoBloque)) {
          final nomMateriaChoca = mat.materiaNombre ?? 'Desconocida';
          throw Exception(
            'Solapamiento detectado el \${b.dia} con "\$nomMateriaChoca" de \${b.horaInicio} a \${b.horaFin}',
          );
        }
      }
    }

    final materiaUpdate = rHorario.materiasSeleccionadas[indiceMateria];
    materiaUpdate.bloques = List.from(materiaUpdate.bloques)..add(nuevoBloque);

    rHorario.materiasSeleccionadas = List.from(rHorario.materiasSeleccionadas);
    rHorario.materiasSeleccionadas[indiceMateria] = materiaUpdate;
    rHorario.fechaActualizacion = DateTime.now();

    await isar.writeTxn(() async {
      await isar.horarioUsuarios.put(rHorario);
    });
  }

  Future<void> actualizarBloque(
    int horarioId,
    String materiaId,
    int indiceBloque,
    BloqueHorario nuevoBloque,
  ) async {
    final isar = await _localDatasource.db;
    final rHorario = await isar.horarioUsuarios.get(horarioId);

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
          final nomMateriaChoca = mat.materiaNombre ?? 'Desconocida';
          throw Exception(
            'Solapamiento detectado el ${b.dia} con "$nomMateriaChoca" de ${b.horaInicio} a ${b.horaFin}',
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

    await isar.writeTxn(() async {
      await isar.horarioUsuarios.put(rHorario);
    });
  }

  Future<void> eliminarBloque(
    int horarioId,
    String materiaId,
    int indiceBloqueLocal,
  ) async {
    final isar = await _localDatasource.db;
    final rHorario = await isar.horarioUsuarios.get(horarioId);

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

    await isar.writeTxn(() async {
      await isar.horarioUsuarios.put(rHorario);
    });
  }

  Future<void> eliminarHorario() async {
    final isar = await _localDatasource.db;
    await isar.writeTxn(() async {
      await isar.horarioUsuarios.clear();
    });
  }

  Future<void> actualizarMateria(
    int horarioId,
    String materiaId,
    String nuevoNombre,
    List<String> nuevosProfesores,
    String nuevoAula,
    int nuevoColorARGB,
  ) async {
    final isar = await _localDatasource.db;

    final rHorario = await isar.horarioUsuarios.get(horarioId);
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

    await isar.writeTxn(() async {
      await isar.horarioUsuarios.put(rHorario);
    });
  }
}
