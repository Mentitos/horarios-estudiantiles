import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../data/models/foto.dart';
import '../data/repositories/fotos_repository.dart';

class FotosProvider extends ChangeNotifier {
  final FotosRepository _repository;
  final ImagePicker _picker = ImagePicker();

  List<Foto> _fotos = [];
  bool _cargando = true;
  
  final Set<String> _selectedIds = {};
  bool _isSelectionMode = false;

  List<Foto> get fotos => _fotos;
  bool get cargando => _cargando;
  Set<String> get selectedIds => _selectedIds;
  bool get isSelectionMode => _isSelectionMode;

  FotosProvider({FotosRepository? repository})
      : _repository = repository ?? FotosRepository() {
    _inicializar();
  }

  Future<void> _inicializar() async {
    _cargando = true;
    _fotos = await _repository.cargarFotos();
    _ordenarFotos();
    _cargando = false;
    notifyListeners();
  }

  void _ordenarFotos() {
    _fotos.sort((a, b) => b.fecha.compareTo(a.fecha));
  }

  Future<void> tomarFoto() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );

      if (image != null) {
        final appDir = await getApplicationDocumentsDirectory();
        final String nombreArchivo = 'foto_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final String path = '${appDir.path}/$nombreArchivo';
        
        await File(image.path).copy(path);

        final nuevaFoto = Foto(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          pathArchivo: path,
          fecha: DateTime.now(),
        );

        _fotos.add(nuevaFoto);
        _ordenarFotos();
        await _repository.guardarFotos(_fotos);
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error al tomar foto: $e");
    }
  }

  Future<void> seleccionarDeGaleria() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage(
        imageQuality: 85,
      );

      if (images.isNotEmpty) {
        final appDir = await getApplicationDocumentsDirectory();
        final now = DateTime.now().millisecondsSinceEpoch;
        
        for (int i = 0; i < images.length; i++) {
          final image = images[i];
          final String nombreArchivo = 'foto_galeria_${now}_$i.jpg';
          final String path = '${appDir.path}/$nombreArchivo';
          
          await File(image.path).copy(path);

          final nuevaFoto = Foto(
            id: '${now}_$i',
            pathArchivo: path,
            fecha: DateTime.now().add(Duration(seconds: i)),
          );

          _fotos.add(nuevaFoto);
        }

        _ordenarFotos();
        await _repository.guardarFotos(_fotos);
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error al seleccionar fotos: $e");
    }
  }

  Future<void> eliminarFoto(String id) async {
    try {
      final foto = _fotos.firstWhere((f) => f.id == id);
      final file = File(foto.pathArchivo);
      if (await file.exists()) {
        await file.delete();
      }

      _fotos.removeWhere((f) => f.id == id);
      await _repository.guardarFotos(_fotos);
      notifyListeners();
    } catch (e) {
      debugPrint("Error al eliminar foto: $e");
    }
  }

  void toggleSelection(String id) {
    if (_selectedIds.contains(id)) {
      _selectedIds.remove(id);
      if (_selectedIds.isEmpty) {
        _isSelectionMode = false;
      }
    } else {
      _selectedIds.add(id);
      _isSelectionMode = true;
    }
    notifyListeners();
  }

  void clearSelection() {
    _selectedIds.clear();
    _isSelectionMode = false;
    notifyListeners();
  }

  Future<void> eliminarSeleccionadas() async {
    try {
      for (final id in _selectedIds) {
        final foto = _fotos.firstWhere((f) => f.id == id);
        final file = File(foto.pathArchivo);
        if (await file.exists()) {
          await file.delete();
        }
      }

      _fotos.removeWhere((f) => _selectedIds.contains(f.id));
      _selectedIds.clear();
      _isSelectionMode = false;
      await _repository.guardarFotos(_fotos);
      notifyListeners();
    } catch (e) {
      debugPrint("Error al eliminar seleccionadas: $e");
    }
  }

  Future<void> vincularSeleccionadas(String? materiaId) async {
    try {
      for (int i = 0; i < _fotos.length; i++) {
        if (_selectedIds.contains(_fotos[i].id)) {
          final f = _fotos[i];
          _fotos[i] = Foto(
            id: f.id,
            pathArchivo: f.pathArchivo,
            fecha: f.fecha,
            nombre: f.nombre,
            materiaId: materiaId,
          );
        }
      }
      _selectedIds.clear();
      _isSelectionMode = false;
      await _repository.guardarFotos(_fotos);
      notifyListeners();
    } catch (e) {
      debugPrint("Error al vincular seleccionadas: $e");
    }
  }

  Future<void> actualizarFoto(
    String id, {
    String? nuevoNombre,
    String? nuevaMateriaId,
  }) async {
    try {
      final index = _fotos.indexWhere((f) => f.id == id);
      if (index != -1) {
        final fotoAnterior = _fotos[index];
        final fotoActualizada = Foto(
          id: fotoAnterior.id,
          pathArchivo: fotoAnterior.pathArchivo,
          fecha: fotoAnterior.fecha,
          nombre: nuevoNombre ?? fotoAnterior.nombre,
          materiaId: nuevaMateriaId ?? fotoAnterior.materiaId,
        );

        _fotos[index] = fotoActualizada;
        await _repository.guardarFotos(_fotos);
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error al actualizar foto: $e");
    }
  }
}
