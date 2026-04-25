import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

class PomodoroOverlay extends StatefulWidget {
  const PomodoroOverlay({super.key});

  @override
  State<PomodoroOverlay> createState() => _PomodoroOverlayState();
}

class _PomodoroOverlayState extends State<PomodoroOverlay> {
  int _workSeconds = 25 * 60;
  int _breakSeconds = 5 * 60;
  bool _isWorkCycle = true;
  
  int _segundosRestantes = 25 * 60;
  bool _estaCorriendo = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    FlutterOverlayWindow.overlayListener.listen((event) {
      if (event is Map) {
        if (event['type'] == 'START') {
          setState(() {
            _workSeconds = event['workSeconds'] ?? 25 * 60;
            _breakSeconds = event['breakSeconds'] ?? 5 * 60;
            _isWorkCycle = true;
            _segundosRestantes = _workSeconds;
            _estaCorriendo = false;
            _iniciarTimer();
          });
        } else if (event['type'] == 'PAUSE') {
          _pausarTimer();
        } else if (event['type'] == 'RESUME') {
          _iniciarTimer();
        } else if (event['type'] == 'STOP') {
          _timer?.cancel();
          FlutterOverlayWindow.closeOverlay();
        }
      }
    });
  }

  void _iniciarTimer() {
    if (_estaCorriendo) return;
    setState(() => _estaCorriendo = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_segundosRestantes > 0) {
        setState(() => _segundosRestantes--);
        FlutterOverlayWindow.shareData({
          'type': 'TICK',
          'seconds': _segundosRestantes,
        });
      } else {
        _timer?.cancel();
        _estaCorriendo = false;
        
        setState(() {
          _isWorkCycle = !_isWorkCycle;
          _segundosRestantes = _isWorkCycle ? _workSeconds : _breakSeconds;
        });
        
        _iniciarTimer();
        
        FlutterOverlayWindow.shareData({
          'type': 'CYCLE_CHANGED',
          'isWorkCycle': _isWorkCycle,
        });
      }
    });
  }

  void _pausarTimer() {
    _timer?.cancel();
    setState(() => _estaCorriendo = false);
  }

  String get _tiempoFormateado {
    final m = (_segundosRestantes ~/ 60).toString().padLeft(2, '0');
    final s = (_segundosRestantes % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: _isWorkCycle 
                ? Colors.white24 
                : Colors.greenAccent.withOpacity(0.5),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _isWorkCycle ? Icons.menu_book_rounded : Icons.coffee_rounded, 
              color: _isWorkCycle ? Colors.white : Colors.greenAccent, 
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              _tiempoFormateado,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: () {
                if (_estaCorriendo) {
                  _pausarTimer();
                  FlutterOverlayWindow.shareData({'type': 'PAUSE'});
                } else {
                  _iniciarTimer();
                  FlutterOverlayWindow.shareData({'type': 'RESUME'});
                }
              },
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: _estaCorriendo ? Colors.orange : Colors.green,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _estaCorriendo ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                FlutterOverlayWindow.closeOverlay();
              },
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
