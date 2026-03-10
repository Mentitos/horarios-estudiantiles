import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import '../../../services/notification_service.dart';
import '../../../providers/eventos_provider.dart';
import '../../../providers/horario_provider.dart';

class NotificacionesSection extends StatefulWidget {
  const NotificacionesSection({super.key});

  @override
  State<NotificacionesSection> createState() => _NotificacionesSectionState();
}

class _NotificacionesSectionState extends State<NotificacionesSection> {
  bool _notifEnabled = true;
  int _notifHour = 21;
  int _notifMinute = 0;
  DateTime? _proximaNotif;
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    _loadNotifSettings();
    _startCountdownTimer();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _startCountdownTimer() {
    _countdownTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (mounted) _updateProximaNotif();
    });
  }

  void _updateProximaNotif() {
    if (!_notifEnabled) {
      setState(() => _proximaNotif = null);
      return;
    }
    final next = NotificationService().getNextDailySummaryTime(
      _notifHour,
      _notifMinute,
    );
    setState(() => _proximaNotif = next);
  }

  Future<void> _loadNotifSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notifEnabled = prefs.getBool('notif_enabled') ?? true;
      _notifHour = prefs.getInt('notif_hour') ?? 21;
      _notifMinute = prefs.getInt('notif_minute') ?? 0;
    });
    _updateProximaNotif();
  }

  Future<void> _saveNotifEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notif_enabled', value);
    setState(() {
      _notifEnabled = value;
    });
    if (mounted) {
      context.read<EventosProvider>().actualizarNotificaciones();
      context.read<HorarioProvider>().actualizarNotificaciones();
    }
    _updateProximaNotif();
  }

  Future<void> _saveNotifTime(int hour, int minute) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('notif_hour', hour);
    await prefs.setInt('notif_minute', minute);
    setState(() {
      _notifHour = hour;
      _notifMinute = minute;
    });
    _updateProximaNotif();
    if (mounted) {
      context.read<EventosProvider>().actualizarNotificaciones();
      context.read<HorarioProvider>().actualizarNotificaciones();
    }
  }

  Future<void> _mostrarSelectorHora(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: _notifHour, minute: _notifMinute),
      helpText: 'Seleccionar hora de notificación',
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if (picked != null) {
      await _saveNotifTime(picked.hour, picked.minute);
    }
  }

  String _calcularTiempoRestante() {
    if (_proximaNotif == null) return '';
    final now = DateTime.now();
    final difference = _proximaNotif!.difference(now);

    if (difference.isNegative) return 'En cualquier momento';

    final horas = difference.inHours;
    final minutos = difference.inMinutes % 60;

    if (horas > 0) {
      return '$horas h y $minutos min';
    } else {
      return '$minutos min';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Notificaciones',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Recibí recordatorios de tus eventos y un resumen de tus materias del día.',
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              title: const Text('Activar notificaciones'),
              subtitle: Text(_notifEnabled ? 'Activado' : 'Desactivado'),
              value: _notifEnabled,
              onChanged: (val) => _saveNotifEnabled(val),
            ),
            if (_notifEnabled) ...[
              ListTile(
                title: const Text('Hora de notificación'),
                subtitle: Text(
                  '${_notifHour.toString().padLeft(2, '0')}:${_notifMinute.toString().padLeft(2, '0')} hs',
                ),
                trailing: const Icon(Icons.access_time),
                onTap: () => _mostrarSelectorHora(context),
              ),
              if (_proximaNotif != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Próxima notificación en: ${_calcularTiempoRestante()}',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Se te notificará 1 semana y 1 día antes de cada evento, y todas las mañanas con tu cursada del día siguiente.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ],
        ),
      ),
    );
  }
}
