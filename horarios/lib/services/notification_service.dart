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

    try {
      tz.initializeTimeZones();
      await Future.delayed(const Duration(milliseconds: 100));
      tz.setLocalLocation(tz.getLocation('America/Argentina/Buenos_Aires'));
    } catch (e) {
      debugPrint('NotificationService: Error inicializando timezones: $e');
    }

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    try {
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
    } catch (e) {
      debugPrint('NotificationService: Error inicializando plugin: $e');
    }
  }

  Future<void> scheduleEventNotifications({
    required String id,
    required String title,
    required String type,
    required DateTime date,
    required int hour,
    required int minute,
  }) async {
    if (!Platform.isAndroid) return;
    final int baseId = id.hashCode.abs();

    final DateTime oneWeekBefore = date.subtract(const Duration(days: 7));
    await _scheduleNotification(
      id: baseId + 1,
      title: '¡Evento en una semana!',
      body: 'Tu $type "$title" es en 7 días.',
      scheduledDate: _nextInstanceOfTime(oneWeekBefore, hour, minute),
    );

    final DateTime oneDayBefore = date.subtract(const Duration(days: 1));
    await _scheduleNotification(
      id: baseId + 2,
      title: '¡Evento mañana!',
      body: 'Mañana tenés tu $type "$title".',
      scheduledDate: _nextInstanceOfTime(oneDayBefore, hour, minute),
    );

    final DateTime oneDayAfter = date.add(const Duration(days: 1));
    await _scheduleNotification(
      id: baseId + 3,
      title: '¿Cómo te fue?',
      body:
          '¿Cómo te fue en tu $type "$title"? ¡No te olvides de anotar tu nota!',
      scheduledDate: _nextInstanceOfTime(oneDayAfter, 10, 0),
    );
  }

  Future<void> scheduleDailySummary({
    required int id,
    required String body,
    required DateTime notifyDate,
    required int hour,
    required int minute,
  }) async {
    if (!Platform.isAndroid) return;

    final tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      notifyDate.year,
      notifyDate.month,
      notifyDate.day,
      hour,
      minute,
      0,
    );

    if (scheduledDate.isBefore(tz.TZDateTime.now(tz.local))) {
      return;
    }

    try {
      await _notificationsPlugin.zonedSchedule(
        id: id,
        title: 'Tu cursada de mañana',
        body: body,
        scheduledDate: scheduledDate,
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            'daily_summary_channel',
            'Resumen Diario',
            channelDescription: 'Notificación diaria con las materias a cursar',
            importance: Importance.high,
            priority: Priority.high,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    } catch (e) {
      debugPrint('Error al programar resumen diario $id: $e');
    }
  }

  Future<void> cancelDailySummaries() async {
    if (!Platform.isAndroid) return;
    for (int i = 101; i <= 120; i++) {
      await _notificationsPlugin.cancel(id: i);
    }
  }

  Future<void> cancelEventNotifications(String id) async {
    if (!Platform.isAndroid) return;
    final int baseId = id.hashCode.abs();
    await _notificationsPlugin.cancel(id: baseId + 1);
    await _notificationsPlugin.cancel(id: baseId + 2);
    await _notificationsPlugin.cancel(id: baseId + 3);
  }

  Future<void> cancelAll() async {
    if (!Platform.isAndroid) return;
    await _notificationsPlugin.cancelAll();
  }

  Future<void> showTestNotification() async {
    if (!Platform.isAndroid) return;

    await _notificationsPlugin.show(
      id: 999,
      title: 'Prueba de Notificación',
      body: '¡Si ves esto, las notificaciones están funcionando!',
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'test_channel',
          'Pruebas',
          channelDescription: 'Canal para probar notificaciones',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );
  }

  Future<void> scheduleTestNotification5s() async {
    if (!Platform.isAndroid) return;

    final scheduledDate = tz.TZDateTime.now(
      tz.local,
    ).add(const Duration(seconds: 5));

    try {
      await _notificationsPlugin.zonedSchedule(
        id: 998,
        title: 'Prueba Programada (5s)',
        body:
            'Esta notificación fue programada para 5 segundos después del toque.',
        scheduledDate: scheduledDate,
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            'test_channel',
            'Pruebas',
            channelDescription: 'Canal para probar notificaciones',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    } catch (e) {
      debugPrint('Error al programar prueba de 5s: $e');
    }
  }

  Future<void> requestPermissions() async {
    if (!Platform.isAndroid) return;
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

  tz.TZDateTime getNextDailySummaryTime(int hour, int minute) {
    return _nextInstanceOfTime(DateTime.now(), hour, minute);
  }

  Future<void> _scheduleNotification({
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime scheduledDate,
  }) async {
    if (scheduledDate.isBefore(tz.TZDateTime.now(tz.local))) return;

    try {
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
    } catch (e) {
      debugPrint('Error al programar notificación de evento ($id): $e');
    }
  }

  tz.TZDateTime _nextInstanceOfTime(DateTime date, int hour, int minute) {
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      date.year,
      date.month,
      date.day,
      hour,
      minute,
      0,
    );

    final now = tz.TZDateTime.now(tz.local);
    if (scheduledDate.isBefore(now) &&
        date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }
}
