import 'package:flutter/foundation.dart';
import '../data/models/horario_usuario.dart';
import '../data/models/materia.dart';
import '../data/repositories/horario_repository.dart';

class HorarioProvider extends ChangeNotifier {
  final HorarioRepository _repository;

  HorarioUsuario? horario;
  bool cargando = true;
  String? error;

  HorarioProvider({HorarioRepository? repository})
    : _repository = repository ?? HorarioRepository();

  Future<void> inicializar() async {
    cargando = true;
    error = null;
    notifyListeners();

    try {
      horario = await _repository.obtenerHorario();
      horario ??= await _repository.crearHorarioVacio('Mi Horario');
    } catch (e) {
      error = e.toString();
    } finally {
      cargando = false;
      notifyListeners();
    }
  }

  Future<void> agregarMateria(Materia materia) async {
    if (horario == null) return;
    try {
      await _repository.agregarMateria(horario!.id, materia);
      horario = await _repository.obtenerHorario();
      notifyListeners();
    } catch (e) {
      error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> eliminarMateria(String materiaId) async {
    if (horario == null) return;
    try {
      await _repository.eliminarMateria(horario!.id, materiaId);
      horario = await _repository.obtenerHorario();
      notifyListeners();
    } catch (e) {
      error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> agregarBloque(String materiaId, BloqueHorario bloque) async {
    if (horario == null) return;
    try {
      await _repository.agregarBloque(horario!.id, materiaId, bloque);
      horario = await _repository.obtenerHorario();
      notifyListeners();
    } catch (e) {
      error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> eliminarBloque(String materiaId, int indice) async {
    if (horario == null) return;
    try {
      await _repository.eliminarBloque(horario!.id, materiaId, indice);
      horario = await _repository.obtenerHorario();
      notifyListeners();
    } catch (e) {
      error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  bool tieneLaMateria(String materiaId) {
    if (horario == null) return false;
    return horario!.materiasSeleccionadas.any((m) => m.materiaId == materiaId);
  }

  Future<void> formatear() async {
    try {
      await _repository.eliminarHorario();
      horario = await _repository.crearHorarioVacio('Mi Horario');
      notifyListeners();
    } catch (e) {
      error = e.toString();
      notifyListeners();
    }
  }
}
