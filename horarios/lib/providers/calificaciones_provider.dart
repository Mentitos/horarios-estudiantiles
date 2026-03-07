import 'package:flutter/foundation.dart';
import '../data/models/calificacion.dart';
import '../data/repositories/calificaciones_repository.dart';

// Mi helado favorito suele ser cualquiera medianamente frutal y de crema de poder ser
class CalificacionesProvider extends ChangeNotifier {
  final CalificacionesRepository _repository;

  List<Calificacion> _calificaciones = [];
  bool _cargando = true;
  bool _modoArchivadoVisible = false;

  List<Calificacion> get calificaciones => _calificaciones;
  List<Calificacion> get calificacionesActivas =>
      _calificaciones.where((c) => !c.isArchivada).toList();
  List<Calificacion> get calificacionesArchivadas =>
      _calificaciones.where((c) => c.isArchivada).toList();

  bool get cargando => _cargando;
  bool get modoArchivadoVisible => _modoArchivadoVisible;

  void toggleModoArchivado() {
    _modoArchivadoVisible = !_modoArchivadoVisible;
    notifyListeners();
  }

  CalificacionesProvider({CalificacionesRepository? repository})
    : _repository = repository ?? CalificacionesRepository() {
    _inicializar();
  }

  Future<void> _inicializar() async {
    _cargando = true;
    notifyListeners();

    _calificaciones = await _repository.cargarCalificaciones();

    _cargando = false;
    notifyListeners();
  }

  Future<void> agregarCalificacion(Calificacion calificacion) async {
    _calificaciones.add(calificacion);
    notifyListeners();
    await _repository.guardarCalificaciones(_calificaciones);
  }

  Future<void> actualizarCalificacion(Calificacion actualizada) async {
    final index = _calificaciones.indexWhere((c) => c.id == actualizada.id);
    if (index != -1) {
      _calificaciones[index] = actualizada;
      notifyListeners();
      await _repository.guardarCalificaciones(_calificaciones);
    }
  }

  Future<void> eliminarCalificacion(String id) async {
    _calificaciones.removeWhere((c) => c.id == id);
    notifyListeners();
    await _repository.guardarCalificaciones(_calificaciones);
  }

  Future<void> toggleArchivar(String id) async {
    final index = _calificaciones.indexWhere((c) => c.id == id);
    if (index != -1) {
      _calificaciones[index].isArchivada = !_calificaciones[index].isArchivada;
      await _repository.guardarCalificaciones(_calificaciones);
      notifyListeners();
    }
  }

  Future<void> archivarTodasActivas() async {
    bool changes = false;
    for (var c in _calificaciones) {
      if (!c.isArchivada) {
        c.isArchivada = true;
        changes = true;
      }
    }
    if (changes) {
      await _repository.guardarCalificaciones(_calificaciones);
      notifyListeners();
    }
  }

  void ordenarPor(String criterio) {
    switch (criterio) {
      case 'materia':
        _calificaciones.sort(
          (a, b) => a.nombreMateria.compareTo(b.nombreMateria),
        );
        break;
      case 'reciente':
        _calificaciones.sort((a, b) => b.fecha.compareTo(a.fecha));
        break;
      case 'antigua':
        _calificaciones.sort((a, b) => a.fecha.compareTo(b.fecha));
        break;
      case 'alta':
        _calificaciones.sort((a, b) {
          final notaA = double.tryParse(a.titulo) ?? -1;
          final notaB = double.tryParse(b.titulo) ?? -1;
          return notaB.compareTo(notaA);
        });
        break;
      case 'baja':
        _calificaciones.sort((a, b) {
          final notaA = double.tryParse(a.titulo) ?? 999;
          final notaB = double.tryParse(b.titulo) ?? 999;
          return notaA.compareTo(notaB);
        });
        break;
    }
    notifyListeners();
  }
}
