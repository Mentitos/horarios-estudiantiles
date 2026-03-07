import '../models/perfil_usuario.dart';
import '../sources/local_datasource.dart';
import 'package:isar/isar.dart';

class PerfilRepository {
  final LocalDatasource _localDatasource;

  PerfilRepository({LocalDatasource? localDatasource})
    : _localDatasource = localDatasource ?? LocalDatasource();

  Future<PerfilUsuario?> obtenerPerfil() async {
    final isar = await _localDatasource.db;
    return await isar.perfilUsuarios.where().findFirst();
  }

  Future<PerfilUsuario> crearPerfilVacio() async {
    final isar = await _localDatasource.db;
    final nuevoPerfil = PerfilUsuario();

    await isar.writeTxn(() async {
      await isar.perfilUsuarios.put(nuevoPerfil);
    });

    return nuevoPerfil;
  }

  Future<void> setCarreras(List<String> carreras) async {
    final isar = await _localDatasource.db;
    var perfil = await obtenerPerfil();
    perfil ??= await crearPerfilVacio();

    perfil.carrerasSeleccionadas = carreras;

    await isar.writeTxn(() async {
      await isar.perfilUsuarios.put(perfil!);
    });
  }

  Future<void> toggleMateriaAprobada(String materiaId) async {
    final isar = await _localDatasource.db;
    var perfil = await obtenerPerfil();
    perfil ??= await crearPerfilVacio();

    final aprobadas = List<String>.from(perfil.materiasAprobadas);

    if (aprobadas.contains(materiaId)) {
      aprobadas.remove(materiaId);
    } else {
      aprobadas.add(materiaId);
    }

    perfil.materiasAprobadas = aprobadas;

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
    final isar = await _localDatasource.db;
    var perfil = await obtenerPerfil();
    perfil ??= await crearPerfilVacio();
    perfil.materiasAprobadas = [];
    await isar.writeTxn(() async {
      await isar.perfilUsuarios.put(perfil!);
    });
  }
}
