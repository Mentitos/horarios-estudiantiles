import 'package:flutter/foundation.dart';
import '../data/models/calificacion.dart';
import '../data/repositories/calificaciones_repository.dart';

class CalificacionesProvider extends ChangeNotifier {
  final CalificacionesRepository _repository;

  List<Calificacion> _calificaciones = [];
  bool _cargando = true;

  List<Calificacion> get calificaciones => _calificaciones;
  bool get cargando => _cargando;

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
