import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'dart:io';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    if (!Platform.isAndroid) {
      debugPrint(
        'NotificationService: Solo implementado para Android por ahora.',
      );
      return;
    }

    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('America/Argentina/Buenos_Aires'));

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _notificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (details) {},
    );

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestExactAlarmsPermission();
  }

  Future<void> scheduleEventNotifications({
    required String id,
    required String title,
    required String type,
    required DateTime date,
    required int hour,
  }) async {
    if (!Platform.isAndroid) return;
    final int baseId = id.hashCode.abs();

    final DateTime oneWeekBefore = date.subtract(const Duration(days: 7));
    await _scheduleNotification(
      id: baseId + 1,
      title: '¡Evento en una semana!',
      body: 'Tu $type "$title" es en 7 días.',
      scheduledDate: _nextInstanceOfTime(oneWeekBefore, hour),
    );

    final DateTime oneDayBefore = date.subtract(const Duration(days: 1));
    await _scheduleNotification(
      id: baseId + 2,
      title: '¡Evento mañana!',
      body: 'Mañana tenés tu $type "$title".',
      scheduledDate: _nextInstanceOfTime(oneDayBefore, hour),
    );
  }

  Future<void> scheduleDailySummary({
    required List<String> subjects,
    required int hour,
  }) async {
    if (!Platform.isAndroid) return;
    if (subjects.isEmpty) {
      await _notificationsPlugin.cancel(id: 0);
      return;
    }

    final String body = 'Hoy cursás: ${subjects.join(", ")}';

    await _notificationsPlugin.zonedSchedule(
      id: 0,
      title: 'Tu día de cursada',
      body: body,
      scheduledDate: _nextInstanceOfTime(DateTime.now(), hour),
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_summary_channel',
          'Resumen Diario',
          channelDescription: 'Notificación diaria con las materias a cursar',
          importance: Importance.low,
          priority: Priority.low,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> cancelEventNotifications(String id) async {
    if (!Platform.isAndroid) return;
    final int baseId = id.hashCode.abs();
    await _notificationsPlugin.cancel(id: baseId + 1);
    await _notificationsPlugin.cancel(id: baseId + 2);
  }

  Future<void> cancelAll() async {
    if (!Platform.isAndroid) return;
    await _notificationsPlugin.cancelAll();
  }

  Future<void> _scheduleNotification({
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime scheduledDate,
  }) async {
    if (scheduledDate.isBefore(tz.TZDateTime.now(tz.local))) return;

    await _notificationsPlugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: scheduledDate,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'events_channel',
          'Eventos del Calendario',
          channelDescription: 'Recordatorios de exámenes y entregas',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  tz.TZDateTime _nextInstanceOfTime(DateTime date, int hour) {
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      date.year,
      date.month,
      date.day,
      hour,
      0,
    );

    return scheduledDate;
  }
}
