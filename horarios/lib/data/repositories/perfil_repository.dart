import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';

import '../models/perfil_usuario.dart';
import '../sources/local_datasource.dart';

class PerfilRepository {
  final LocalDatasource _localDatasource;

  PerfilRepository({LocalDatasource? localDatasource})
    : _localDatasource = localDatasource ?? LocalDatasource();

  static PerfilUsuario? _webMockPerfil;

  Future<PerfilUsuario?> obtenerPerfil() async {
    if (kIsWeb) {
      return _webMockPerfil;
    }
    final isar = await _localDatasource.db!;
    return await isar.perfilUsuarios.where().findFirst();
  }

  Future<PerfilUsuario> crearPerfilVacio() async {
    final nuevoPerfil = PerfilUsuario();

    if (kIsWeb) {
      _webMockPerfil = nuevoPerfil;
      return nuevoPerfil;
    }

    final isar = await _localDatasource.db!;
    await isar.writeTxn(() async {
      await isar.perfilUsuarios.put(nuevoPerfil);
    });

    return nuevoPerfil;
  }

  Future<void> setCarreras(List<String> carreras) async {
    var perfil = await obtenerPerfil();
    perfil ??= await crearPerfilVacio();

    perfil.carrerasSeleccionadas = carreras;

    if (kIsWeb) {
      _webMockPerfil = perfil;
      return;
    }

    final isar = await _localDatasource.db!;
    await isar.writeTxn(() async {
      await isar.perfilUsuarios.put(perfil!);
    });
  }

  Future<void> toggleMateriaAprobada(String materiaId) async {
    var perfil = await obtenerPerfil();
    perfil ??= await crearPerfilVacio();

    final aprobadas = List<String>.from(perfil.materiasAprobadas);

    if (aprobadas.contains(materiaId)) {
      aprobadas.remove(materiaId);
    } else {
      aprobadas.add(materiaId);
    }

    perfil.materiasAprobadas = aprobadas;

    if (kIsWeb) {
      _webMockPerfil = perfil;
      return;
    }

    final isar = await _localDatasource.db!;
    await isar.writeTxn(() async {
      await isar.perfilUsuarios.put(perfil!);
    });
  }

  Future<bool> estaAprobada(String materiaId) async {
    final perfil = await obtenerPerfil();
    if (perfil == null) return false;
    return perfil.materiasAprobadas.contains(materiaId);
  }

  Future<void> limpiarMateriasAprobadas() async {
    var perfil = await obtenerPerfil();
    perfil ??= await crearPerfilVacio();
    perfil.materiasAprobadas = [];

    if (kIsWeb) {
      _webMockPerfil = perfil;
      return;
    }

    final isar = await _localDatasource.db!;
    await isar.writeTxn(() async {
      await isar.perfilUsuarios.put(perfil!);
    });
  }
}
