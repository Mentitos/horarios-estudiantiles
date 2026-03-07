import 'package:flutter/foundation.dart';
import '../data/models/profesor.dart';
import '../data/repositories/profesores_repository.dart';

class ProfesoresProvider extends ChangeNotifier {
  final ProfesoresRepository _repository;

  List<Profesor> _profesores = [];
  bool _cargando = true;

  List<Profesor> get profesores => _profesores;
  bool get cargando => _cargando;

  ProfesoresProvider({ProfesoresRepository? repository})
    : _repository = repository ?? ProfesoresRepository() {
    _inicializar();
  }

  Future<void> _inicializar() async {
    _cargando = true;
    notifyListeners();

    _profesores = await _repository.cargarProfesores();
    _ordenarProfesores();

    _cargando = false;
    notifyListeners();
  }

  void _ordenarProfesores() {
    _profesores.sort((a, b) {
      if (a.apellido.isNotEmpty && b.apellido.isNotEmpty) {
        return a.apellido.toLowerCase().compareTo(b.apellido.toLowerCase());
      } else if (a.nombre.isNotEmpty && b.nombre.isNotEmpty) {
        return a.nombre.toLowerCase().compareTo(b.nombre.toLowerCase());
      }
      return a.nombreCompleto.toLowerCase().compareTo(
        b.nombreCompleto.toLowerCase(),
      );
    });
  }

  Future<void> agregarProfesor(Profesor profesor) async {
    _profesores.add(profesor);
    _ordenarProfesores();
    notifyListeners();
    await _repository.guardarProfesores(_profesores);
  }

  Future<void> actualizarProfesor(Profesor actualizado) async {
    final index = _profesores.indexWhere((p) => p.id == actualizado.id);
    if (index != -1) {
      _profesores[index] = actualizado;
      _ordenarProfesores();
      notifyListeners();
      await _repository.guardarProfesores(_profesores);
    }
  }

  Future<void> eliminarProfesor(String id) async {
    _profesores.removeWhere((p) => p.id == id);
    notifyListeners();
    await _repository.guardarProfesores(_profesores);
  }
}
