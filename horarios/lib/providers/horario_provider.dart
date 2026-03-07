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
    try {
      await _repository.agregarMateria(materia);
      horario = await _repository.obtenerHorario();
      notifyListeners();
    } catch (e) {
      error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> eliminarMateria(String materiaId) async {
    try {
      await _repository.eliminarMateria(materiaId);
      horario = await _repository.obtenerHorario();
      notifyListeners();
    } catch (e) {
      error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> agregarBloque(String materiaId, BloqueHorario bloque) async {
    try {
      await _repository.agregarBloque(materiaId, bloque);
      horario = await _repository.obtenerHorario();
      notifyListeners();
    } catch (e) {
      error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> eliminarBloque(String materiaId, int indice) async {
    try {
      await _repository.eliminarBloque(materiaId, indice);
      horario = await _repository.obtenerHorario();
      notifyListeners();
    } catch (e) {
      error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> actualizarBloque(
    String materiaId,
    int indice,
    BloqueHorario nuevoBloque,
  ) async {
    try {
      await _repository.actualizarBloque(materiaId, indice, nuevoBloque);
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

  Future<void> actualizarMateria(
    String materiaId,
    String nuevoNombre,
    List<String> nuevosProfesores,
    String? nuevoAula,
    int nuevoColorARGB,
  ) async {
    try {
      await _repository.actualizarMateria(
        materiaId,
        nuevoNombre,
        nuevosProfesores,
        nuevoAula ?? '',
        nuevoColorARGB,
      );
      horario = await _repository.obtenerHorario();
      notifyListeners();
    } catch (e) {
      error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<String> obtenerNotasMateria(String materiaId) async {
    try {
      return await _repository.obtenerNotasMateria(materiaId);
    } catch (e) {
      return '';
    }
  }

  Future<void> actualizarNotasMateria(
    String materiaId,
    String nuevasNotas,
  ) async {
    try {
      await _repository.actualizarNotasMateria(materiaId, nuevasNotas);
      horario = await _repository.obtenerHorario();
      notifyListeners();
    } catch (e) {
      error = e.toString();
      notifyListeners();
      rethrow;
    }
  }
}
