import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../data/models/evento.dart';
import '../services/notification_service.dart';

// Me gusta mucho linux pero este proyecto lo hago en windows por mejores compatibilidades
//  Y porque uso linux en mi computadora del gobierno (menos potente)
class EventosProvider with ChangeNotifier {
  final List<Evento> _eventos = [];
  bool _cargando = true;
  final NotificationService _notificationService = NotificationService();

  List<Evento> get eventos => _eventos;
  bool get cargando => _cargando;

  EventosProvider() {
    _cargarEventos();
  }

  Future<void> _cargarEventos() async {
    _cargando = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString('eventos_calendario');
      if (jsonStr != null) {
        final List<dynamic> decodedList = jsonDecode(jsonStr);
        _eventos.clear();
        _eventos.addAll(decodedList.map((e) => Evento.fromJson(e)).toList());
      }
    } catch (e) {
      debugPrint('Error loading events: $e');
    }

    await actualizarNotificaciones();

    _cargando = false;
    notifyListeners();
  }

  Future<void> actualizarNotificaciones() async {
    await _notificationService.cancelAll();
    final prefs = await SharedPreferences.getInstance();
    final int hour = prefs.getInt('notif_hour') ?? 21;
    final int minute = prefs.getInt('notif_minute') ?? 0;
    final bool enabled = prefs.getBool('notif_enabled') ?? true;

    if (!enabled) return;

    for (var evento in _eventos) {
      await _notificationService.scheduleEventNotifications(
        id: evento.id,
        title: evento.titulo,
        type: evento.tipo,
        date: evento.fecha,
        hour: hour,
        minute: minute,
      );
    }
  }

  Future<void> _guardarEventos() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encodedList = jsonEncode(_eventos.map((e) => e.toJson()).toList());
      await prefs.setString('eventos_calendario', encodedList);
    } catch (e) {
      debugPrint('Error saving events: $e');
    }
  }

  List<Evento> obtenerEventosParaDia(DateTime dia) {
    return _eventos.where((evento) => isSameDay(evento.fecha, dia)).toList();
  }

  Future<void> agregarEvento(Evento evento) async {
    _eventos.add(evento);
    notifyListeners();
    await _guardarEventos();

    final prefs = await SharedPreferences.getInstance();
    final int hour = prefs.getInt('notif_hour') ?? 21;
    final int minute = prefs.getInt('notif_minute') ?? 0;
    if (prefs.getBool('notif_enabled') ?? true) {
      await _notificationService.scheduleEventNotifications(
        id: evento.id,
        title: evento.titulo,
        type: evento.tipo,
        date: evento.fecha,
        hour: hour,
        minute: minute,
      );
    }
  }

  Future<void> eliminarEvento(String id) async {
    _eventos.removeWhere((e) => e.id == id);
    notifyListeners();
    await _guardarEventos();
    await _notificationService.cancelEventNotifications(id);
  }

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Future<void> formatear() async {
    _eventos.clear();
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('eventos_calendario');
    await _notificationService.cancelAll();
  }
}
