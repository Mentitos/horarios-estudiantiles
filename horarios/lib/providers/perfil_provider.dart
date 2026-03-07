import 'package:flutter/material.dart';

import '../data/models/perfil_usuario.dart';
import '../data/repositories/perfil_repository.dart';

class PerfilProvider extends ChangeNotifier {
  final PerfilRepository _repository;
  PerfilUsuario? perfil;
  bool cargando = true;
  String? error;

  PerfilProvider({PerfilRepository? repository})
    : _repository = repository ?? PerfilRepository();

  Future<void> inicializar() async {
    cargando = true;
    error = null;
    notifyListeners();

    try {
      perfil = await _repository.obtenerPerfil();
      perfil ??= await _repository.crearPerfilVacio();
    } catch (e) {
      error = e.toString();
    } finally {
      cargando = false;
      notifyListeners();
    }
  }

  Future<void> setCarreras(List<String> carreras) async {
    try {
      await _repository.setCarreras(carreras);
      perfil = await _repository.obtenerPerfil();
      notifyListeners();
    } catch (e) {
      error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> toggleMateriaAprobada(String materiaId) async {
    try {
      await _repository.toggleMateriaAprobada(materiaId);
      perfil = await _repository.obtenerPerfil();
      notifyListeners();
    } catch (e) {
      error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  bool estaAprobada(String materiaId) {
    if (perfil == null) return false;
    return perfil!.materiasAprobadas.contains(materiaId);
  }

  List<String> get carrerasSeleccionadas => perfil?.carrerasSeleccionadas ?? [];
  List<String> get materiasAprobadas => perfil?.materiasAprobadas ?? [];

  Future<void> formatear() async {
    try {
      await _repository.setCarreras([]);
      await _repository.limpiarMateriasAprobadas();
      perfil = await _repository.obtenerPerfil();
      notifyListeners();
    } catch (e) {
      error = e.toString();
      notifyListeners();
    }
  }
}
