import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

class PomodoroScreen extends StatefulWidget {
  const PomodoroScreen({super.key});

  @override
  State<PomodoroScreen> createState() => _PomodoroScreenState();
}

class _PomodoroScreenState extends State<PomodoroScreen> {
  int _minutosEstudio = 25;
  int _minutosDescanso = 5;

  @override
  void initState() {
    super.initState();
    _requestPermission();
  }

  Future<void> _requestPermission() async {
    final status = await FlutterOverlayWindow.isPermissionGranted();
    if (!status) {
      await FlutterOverlayWindow.requestPermission();
    }
  }

  void _iniciarOverlay() async {
    final status = await FlutterOverlayWindow.isPermissionGranted();
    if (!status) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Se requiere permiso para dibujar sobre otras aplicaciones')),
      );
      await FlutterOverlayWindow.requestPermission();
      return;
    }

    if (await FlutterOverlayWindow.isActive()) {
      FlutterOverlayWindow.closeOverlay();
    }

    await FlutterOverlayWindow.showOverlay(
      enableDrag: true,
      overlayTitle: "Pomodoro Horarios",
      overlayContent: 'Temporizador activo',
      flag: OverlayFlag.defaultFlag,
      visibility: NotificationVisibility.visibilityPublic,
      positionGravity: PositionGravity.auto,
      height: 150,
      width: 300,
    );
    
    await Future.delayed(const Duration(milliseconds: 500));
    FlutterOverlayWindow.shareData({
      'type': 'START',
      'workSeconds': _minutosEstudio * 60,
      'breakSeconds': _minutosDescanso * 60,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modo Concentración'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Configurar Pomodoro',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              'Usá este temporizador para estudiar. Si lo inicias, aparecerá una ventana flotante para que puedas salir de la app y seguir viendo el tiempo restante.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 48),
            
            Text('Tiempo de estudio: $_minutosEstudio min', style: const TextStyle(fontWeight: FontWeight.bold)),
            Slider(
              value: _minutosEstudio.toDouble(),
              min: 5,
              max: 120,
              divisions: 23,
              label: '$_minutosEstudio min',
              onChanged: (val) {
                setState(() => _minutosEstudio = val.toInt());
              },
            ),
            
            const SizedBox(height: 24),
            Text('Tiempo de descanso: $_minutosDescanso min', style: const TextStyle(fontWeight: FontWeight.bold)),
            Slider(
              value: _minutosDescanso.toDouble(),
              min: 1,
              max: 30,
              divisions: 29,
              label: '$_minutosDescanso min',
              onChanged: (val) {
                setState(() => _minutosDescanso = val.toInt());
              },
            ),

            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: FilledButton.icon(
                icon: const Icon(Icons.timer_rounded),
                label: const Text('INICIAR POMODORO FLOTANTE', style: TextStyle(fontSize: 16)),
                onPressed: _iniciarOverlay,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () async {
                  if (await FlutterOverlayWindow.isActive()) {
                    FlutterOverlayWindow.closeOverlay();
                  }
                },
                child: const Text('Cerrar overlay activo', style: TextStyle(color: Colors.red)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
