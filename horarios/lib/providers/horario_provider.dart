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

    if (!enabled) {
      await _notificationService.cancelAll();
      return;
    }

    final now = DateTime.now();
    final tomorrow = now.add(const Duration(days: 1));
    final String todayName = _getDiaSemana(now.weekday);
    final String tomorrowName = _getDiaSemana(tomorrow.weekday);

    final List<String> subjectsToday = [];
    final List<String> subjectsTomorrow = [];

    for (var materia in horario!.materiasSeleccionadas) {
      if (materia.bloques.any((b) => b.dia == todayName)) {
        subjectsToday.add(materia.materiaNombre ?? 'Materia');
      }
      if (materia.bloques.any((b) => b.dia == tomorrowName)) {
        subjectsTomorrow.add(materia.materiaNombre ?? 'Materia');
      }
    }

    await _notificationService.scheduleDailySummary(
      subjects: subjectsToday,
      hour: hour,
      minute: minute,
    );

    await _notificationService.scheduleTomorrowSummary(
      subjects: subjectsTomorrow,
      hour: hour,
      minute: minute,
    );
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
