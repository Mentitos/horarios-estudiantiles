import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../data/models/grabacion.dart';
import '../data/repositories/grabaciones_repository.dart';

class GrabacionesProvider extends ChangeNotifier {
  final GrabacionesRepository _repository;
  final AudioRecorder _audioRecorder = AudioRecorder();
  final AudioPlayer _audioPlayer = AudioPlayer();

  List<Grabacion> _grabaciones = [];
  bool _cargando = true;

  bool _isRecording = false;
  String? _playingId;

  DateTime? _inicioGrabacion;

  List<Grabacion> get grabaciones => _grabaciones;
  bool get cargando => _cargando;
  bool get isRecording => _isRecording;
  String? get playingId => _playingId;

  GrabacionesProvider({GrabacionesRepository? repository})
    : _repository = repository ?? GrabacionesRepository() {
    _inicializar();
    _setupAudioPlayerListeners();
  }

  Future<void> _inicializar() async {
    _cargando = true;
    notifyListeners();

    _grabaciones = await _repository.cargarGrabaciones();
    _ordenarGrabaciones();

    _cargando = false;
    notifyListeners();
  }

  void _setupAudioPlayerListeners() {
    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (state == PlayerState.completed) {
        _playingId = null;
        notifyListeners();
      }
    });
  }

  void _ordenarGrabaciones() {
    _grabaciones.sort((a, b) => b.fecha.compareTo(a.fecha));
  }

  Future<bool> _verificarPermisoMicrofono() async {
    final estado = await Permission.microphone.request();
    return estado.isGranted;
  }

  Future<void> iniciarGrabacion() async {
    try {
      if (await _verificarPermisoMicrofono()) {
        final appDir = await getApplicationDocumentsDirectory();
        final String nombreArchivo =
            'grabacion_${DateTime.now().millisecondsSinceEpoch}.m4a';
        final String path = '${appDir.path}/$nombreArchivo';

        await _audioRecorder.start(
          const RecordConfig(encoder: AudioEncoder.aacLc),
          path: path,
        );

        _isRecording = true;
        _inicioGrabacion = DateTime.now();
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error al iniciar grabación: $e");
    }
  }

  Future<void> detenerGrabacion() async {
    try {
      final String? path = await _audioRecorder.stop();
      _isRecording = false;
      notifyListeners();

      if (path != null && _inicioGrabacion != null) {
        final duracion = DateTime.now().difference(_inicioGrabacion!);
        final nuevaGrabacion = Grabacion(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          pathArchivo: path,
          fecha: _inicioGrabacion!,
          duracion: duracion,
        );

        _grabaciones.add(nuevaGrabacion);
        _ordenarGrabaciones();
        await _repository.guardarGrabaciones(_grabaciones);
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error al detener grabación: $e");
    }
  }

  Future<void> reproducirORepausar(Grabacion grabacion) async {
    try {
      if (_playingId == grabacion.id) {
        await _audioPlayer.pause();
        _playingId = null;
      } else {
        await _audioPlayer.stop();
        await _audioPlayer.play(DeviceFileSource(grabacion.pathArchivo));
        _playingId = grabacion.id;
      }
      notifyListeners();
    } catch (e) {
      debugPrint("Error al reproducir audio: $e");
    }
  }

  Future<void> eliminarGrabacion(String id) async {
    try {
      if (_playingId == id) {
        await _audioPlayer.stop();
        _playingId = null;
      }

      final grabacion = _grabaciones.firstWhere((g) => g.id == id);

      final file = File(grabacion.pathArchivo);
      if (await file.exists()) {
        await file.delete();
      }

      _grabaciones.removeWhere((g) => g.id == id);
      await _repository.guardarGrabaciones(_grabaciones);
      notifyListeners();
    } catch (e) {
      debugPrint("Error al eliminar grabación: $e");
    }
  }

  Future<void> actualizarGrabacion(
    String id, {
    String? nuevoNombre,
    String? nuevaMateriaId,
  }) async {
    try {
      final index = _grabaciones.indexWhere((g) => g.id == id);
      if (index != -1) {
        final grabacionAnterior = _grabaciones[index];
        final grabacionActualizada = Grabacion(
          id: grabacionAnterior.id,
          pathArchivo: grabacionAnterior.pathArchivo,
          fecha: grabacionAnterior.fecha,
          duracion: grabacionAnterior.duracion,
          nombre: nuevoNombre ?? grabacionAnterior.nombre,
          materiaId: nuevaMateriaId ?? grabacionAnterior.materiaId,
        );

        _grabaciones[index] = grabacionActualizada;
        await _repository.guardarGrabaciones(_grabaciones);
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error al actualizar grabación: $e");
    }
  }

  @override
  void dispose() {
    _audioRecorder.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }
}
