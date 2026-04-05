import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/horario_usuario.dart';
import '../data/models/materia.dart';
import '../data/repositories/horario_repository.dart';
import '../services/notification_service.dart';

class HorarioProvider extends ChangeNotifier {
  final HorarioRepository _repository;

  HorarioUsuario? horario;
  bool cargando = true;
  String? error;
  final NotificationService _notificationService = NotificationService();

  HorarioProvider({HorarioRepository? repository})
    : _repository = repository ?? HorarioRepository();

  Future<void> inicializar() async {
    cargando = true;
    error = null;
    _safeNotify();

    try {
      horario = await _repository.obtenerHorario();
      horario ??= await _repository.crearHorarioVacio('Mi Horario');
    } catch (e) {
      error = e.toString();
    } finally {
      cargando = false;
      await actualizarNotificaciones();
      _safeNotify();
    }
  }

  Future<void> actualizarNotificaciones() async {
    if (horario == null) return;

    final prefs = await SharedPreferences.getInstance();
    final bool enabled = prefs.getBool('notif_enabled') ?? true;
    final int hour = prefs.getInt('notif_hour') ?? 21;
    final int minute = prefs.getInt('notif_minute') ?? 0;

    await _notificationService.cancelDailySummaries();

    if (!enabled) {
      await _notificationService.cancelAll();
      return;
    }

    final now = DateTime.now();

    for (int i = 1; i <= 14; i++) {
      final targetDate = now.add(Duration(days: i));
      final String dayName = _getDiaSemana(targetDate.weekday);
      
      final List<String> subjects = [];
      for (var materia in horario!.materiasSeleccionadas) {
        if (materia.bloques.any((b) => b.dia == dayName)) {
          subjects.add(materia.materiaNombre ?? 'Materia');
        }
      }
      
      final String body = subjects.isEmpty
          ? 'Mañana no tenés que cursar, ¡estás libre!'
          : 'Mañana cursás: ${subjects.join(", ")}';
          
      final notifyDate = targetDate.subtract(const Duration(days: 1));
      
      await _notificationService.scheduleDailySummary(
        id: 100 + i,
        body: body,
        notifyDate: notifyDate,
        hour: hour,
        minute: minute,
      );
    }
  }

  String _getDiaSemana(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'Lunes';
      case DateTime.tuesday:
        return 'Martes';
      case DateTime.wednesday:
        return 'Miércoles';
      case DateTime.thursday:
        return 'Jueves';
      case DateTime.friday:
        return 'Viernes';
      case DateTime.saturday:
        return 'Sábado';
      case DateTime.sunday:
        return 'Domingo';
      default:
        return '';
    }
  }

  void _safeNotify() {
    Future.microtask(() => notifyListeners());
  }

  Future<void> agregarMateria(Materia materia) async {
    try {
      await _repository.agregarMateria(materia);
      horario = await _repository.obtenerHorario();
      await actualizarNotificaciones();
      notifyListeners();
    } catch (e) {
      error = e.toString();
      notifyListeners();
    }
  }

  Future<void> eliminarMateria(String materiaId) async {
    try {
      await _repository.eliminarMateria(materiaId);
      horario = await _repository.obtenerHorario();
      await actualizarNotificaciones();
      notifyListeners();
    } catch (e) {
      error = e.toString();
      notifyListeners();
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
      await actualizarNotificaciones();
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
    String? nuevoComision,
    int nuevoColorARGB,
  ) async {
    try {
      await _repository.actualizarMateria(
        materiaId,
        nuevoNombre,
        nuevosProfesores,
        nuevoAula ?? '',
        nuevoComision,
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
