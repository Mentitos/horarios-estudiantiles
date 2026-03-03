import 'dart:convert';
import 'package:dio/dio.dart';
import '../models/carrera.dart';
import '../models/materia.dart';

class GithubDatasource {
  final Dio _dio;

  GithubDatasource({Dio? dio}) : _dio = dio ?? Dio();

  Future<({List<Materia> materias, List<Carrera> carreras})>
  fetchDatos() async {
    try {
      final responses = await Future.wait([
        _dio.get(
          'https://raw.githubusercontent.com/Mentitos/materiasungsporcentaje/main/materias.json',
        ),
        _dio.get(
          'https://raw.githubusercontent.com/Mentitos/materiasungsporcentaje/main/carreras.json',
        ),
      ]);

      final materiasResponse = responses[0];
      final carrerasResponse = responses[1];

      final materiasJsonList =
          jsonDecode(materiasResponse.data) as List<dynamic>;
      final carrerasJsonList =
          jsonDecode(carrerasResponse.data) as List<dynamic>;

      List<Materia> materias = [];
      for (var jsonMateria in materiasJsonList) {
        final materia = Materia()
          ..materiaId = jsonMateria['id'].toString()
          ..nombre = jsonMateria['nombre'] as String;
        materias.add(materia);
      }

      List<Carrera> carreras = [];
      for (var jsonCarrera in carrerasJsonList) {
        final carrera = Carrera()..nombre = jsonCarrera['nombre'] as String;

        final List<dynamic> materiasRaw =
            jsonCarrera['materias'] as List<dynamic>;
        carrera.materiasIds = materiasRaw.map((e) => e.toString()).toList();

        carreras.add(carrera);
      }

      return (materias: materias, carreras: carreras);
    } catch (e) {
      throw Exception('Error al descargar los datos desde GitHub: $e');
    }
  }
}
