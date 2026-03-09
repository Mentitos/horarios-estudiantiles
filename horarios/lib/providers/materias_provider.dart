import 'package:flutter/foundation.dart';
import '../data/models/carrera.dart';
import '../data/repositories/materia_repository.dart';

//  Mi fuerza de trabajo se ve plasmada en este trabajo muerto pero que revalorizo
class MateriasProvider extends ChangeNotifier {
  final MateriaRepository _repository;

  List<Carrera> carreras = [];
  bool cargando = true;
  String? error;

  Map<String, List<Carrera>> get carrerasPorGrupo {
    final Map<String, List<Carrera>> grupos = {};
    for (var carrera in carreras) {
      final grupo = carrera.grupo ?? 'Sin categoría';
      if (!grupos.containsKey(grupo)) {
        grupos[grupo] = [];
      }
      grupos[grupo]!.add(carrera);
    }
    return grupos;
  }

  MateriasProvider({MateriaRepository? repository})
    : _repository = repository ?? MateriaRepository();

  Future<void> inicializar() async {
    cargando = true;
    error = null;
    _safeNotify();

    try {
      await _repository.cargarDatosIniciales();
      carreras = await _repository.getCarreras();

      carreras.sort((a, b) => (a.nombre ?? '').compareTo(b.nombre ?? ''));
    } catch (e) {
      error = e.toString();
    } finally {
      cargando = false;
      _safeNotify();
    }
  }

  void _safeNotify() {
    // Usamos microtask para evitar errores de notify durante el build
    Future.microtask(() => notifyListeners());
  }

  Future<void> refrescar() async {
    cargando = true;
    error = null;
    notifyListeners();

    try {
      await _repository.refrescarDatos();
      carreras = await _repository.getCarreras();
      carreras.sort((a, b) => (a.nombre ?? '').compareTo(b.nombre ?? ''));
    } catch (e) {
      error = e.toString();
    } finally {
      cargando = false;
      notifyListeners();
    }
  }

  Future<List<dynamic>> getMateriasDeCarrera(String nombre) {
    return _repository.getMateriasDeCarrera(nombre);
  }
}
