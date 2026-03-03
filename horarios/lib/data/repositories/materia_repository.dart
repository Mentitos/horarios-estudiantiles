import '../models/carrera.dart';
import '../models/materia.dart';
import '../sources/github_datasource.dart';
import '../sources/local_datasource.dart';

class MateriaRepository {
  final GithubDatasource _githubDatasource;
  final LocalDatasource _localDatasource;

  MateriaRepository({
    GithubDatasource? githubDatasource,
    LocalDatasource? localDatasource,
  }) : _githubDatasource = githubDatasource ?? GithubDatasource(),
       _localDatasource = localDatasource ?? LocalDatasource();

  Future<void> cargarDatosIniciales() async {
    final yaCargados = await _localDatasource.datosFueronCargados();
    if (!yaCargados) {
      final resultado = await _githubDatasource.fetchDatos();

      await _localDatasource.guardarMaterias(resultado.materias);
      await _localDatasource.guardarCarreras(resultado.carreras);

      await _localDatasource.marcarDatosCargados();
    }
  }

  Future<void> refrescarDatos() async {
    await _localDatasource.forzarRecarga();

    final resultado = await _githubDatasource.fetchDatos();

    await _localDatasource.guardarMaterias(resultado.materias);
    await _localDatasource.guardarCarreras(resultado.carreras);

    await _localDatasource.marcarDatosCargados();
  }

  Future<List<Carrera>> getCarreras() async {
    return await _localDatasource.leerTodasLasCarreras();
  }

  Future<List<dynamic>> getMateriasDeCarrera(String nombreCarrera) async {
    final carreras = await _localDatasource.leerTodasLasCarreras();

    final carrera = carreras.firstWhere(
      (c) => c.nombre == nombreCarrera,
      orElse: () => throw Exception('Carrera \$nombreCarrera no encontrada'),
    );

    List<dynamic> materiasCruzadas = [];

    for (String materiaIdCompuesto in carrera.materiasIds) {
      if (materiaIdCompuesto.contains(':')) {
        final idsInvolucrados = materiaIdCompuesto.split(':');

        List<Materia> grupoMaterias = [];
        for (String idPart in idsInvolucrados) {
          final materia = await _localDatasource.leerMateriaPorId(idPart);
          if (materia != null) {
            grupoMaterias.add(materia);
          }
        }

        if (grupoMaterias.isNotEmpty) {
          materiasCruzadas.add(grupoMaterias);
        }
      } else {
        final materia = await _localDatasource.leerMateriaPorId(
          materiaIdCompuesto,
        );
        if (materia != null) {
          materiasCruzadas.add(materia);
        }
      }
    }

    return materiasCruzadas;
  }
}
