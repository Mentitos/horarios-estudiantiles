import 'package:isar/isar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';

import '../models/materia.dart';
import '../models/carrera.dart';
import '../models/horario_usuario.dart';

class LocalDatasource {
  static const String _isFetchedKey = 'datos_cargados';
  late Future<Isar> db;

  LocalDatasource() {
    db = _initDb();
  }

  Future<Isar> _initDb() async {
    if (Isar.instanceNames.isNotEmpty) {
      return Isar.getInstance()!;
    }

    final dir = await getApplicationDocumentsDirectory();
    return await Isar.open([
      MateriaSchema,
      CarreraSchema,
      HorarioUsuarioSchema,
    ], directory: dir.path);
  }

  Future<bool> datosFueronCargados() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isFetchedKey) ?? false;
  }

  Future<void> marcarDatosCargados() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isFetchedKey, true);
  }

  Future<void> forzarRecarga() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_isFetchedKey);

    final isar = await db;
    await isar.writeTxn(() async {
      await isar.materias.clear();
      await isar.carreras.clear();
    });
  }

  Future<void> guardarMaterias(List<Materia> materias) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.materias.putAll(materias);
    });
  }

  Future<void> guardarCarreras(List<Carrera> carreras) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.carreras.putAll(carreras);
    });
  }

  Future<List<Carrera>> leerTodasLasCarreras() async {
    final isar = await db;
    return await isar.carreras.where().findAll();
  }

  Future<Materia?> leerMateriaPorId(String idMateria) async {
    final isar = await db;
    return await isar.materias.where().materiaIdEqualTo(idMateria).findFirst();
  }
}
