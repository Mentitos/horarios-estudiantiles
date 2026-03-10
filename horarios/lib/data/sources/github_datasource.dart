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
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final random = DateTime.now().microsecondsSinceEpoch;
      final responses = await Future.wait([
        _dio.get(
          'https://raw.githubusercontent.com/Mentitos/materiasungsporcentaje/main/materias.json?v=$timestamp$random',
          options: Options(
            headers: {
              'Cache-Control': 'no-cache, no-store, must-revalidate',
              'Pragma': 'no-cache',
              'Expires': '0',
            },
          ),
        ),
        _dio.get(
          'https://raw.githubusercontent.com/Mentitos/materiasungsporcentaje/main/carreras.json?v=$timestamp$random',
          options: Options(
            headers: {
              'Cache-Control': 'no-cache, no-store, must-revalidate',
              'Pragma': 'no-cache',
              'Expires': '0',
            },
          ),
        ),
      ]);

      final materiasRaw = responses[0].data;
      final carrerasRaw = responses[1].data;

      if (materiasRaw == null ||
          (materiasRaw is String && materiasRaw.trim().isEmpty)) {
        throw Exception('El archivo materias.json está vacío en GitHub.');
      }
      if (carrerasRaw == null ||
          (carrerasRaw is String && carrerasRaw.trim().isEmpty)) {
        throw Exception('El archivo carreras.json está vacío en GitHub.');
      }

      final materiasData = materiasRaw is String
          ? jsonDecode(materiasRaw)
          : materiasRaw;
      final carrerasData = carrerasRaw is String
          ? jsonDecode(carrerasRaw)
          : carrerasRaw;

      if (materiasData is! List) {
        throw Exception(
          'El archivo materias.json de GitHub no tiene formato de lista (encontrado: ${materiasData.runtimeType})',
        );
      }

      final List<dynamic> materiasJsonList = materiasData;
      List<dynamic> carrerasJsonList = [];

      if (carrerasData is List) {
        carrerasJsonList = carrerasData;
      } else if (carrerasData is Map) {
        for (var categoryValue in carrerasData.values) {
          if (categoryValue is List) {
            carrerasJsonList.addAll(categoryValue);
          }
        }
      } else {
        throw Exception(
          'El archivo carreras.json de GitHub tiene un formato desconocido (encontrado: ${carrerasData.runtimeType})',
        );
      }

      List<Materia> materias = [];
      for (var jsonMateria in materiasJsonList) {
        final materia = Materia()
          ..materiaId = jsonMateria['id'].toString()
          ..nombre = jsonMateria['nombre'] as String;
        materias.add(materia);
      }

      List<Carrera> carreras = [];
      if (carrerasData is Map) {
        for (var entry in carrerasData.entries) {
          final grupoNombre = entry.key as String;
          final carrerasJsonList = entry.value;

          if (carrerasJsonList is List) {
            for (var jsonCarrera in carrerasJsonList) {
              final carrera = Carrera()
                ..nombre = jsonCarrera['nombre'] as String
                ..grupo = grupoNombre;

              final materiasRawList = jsonCarrera['materias'];
              if (materiasRawList is List) {
                carrera.materiasIds = materiasRawList
                    .map((e) => e.toString())
                    .toList();
              } else {
                carrera.materiasIds = [];
              }
              carreras.add(carrera);
            }
          }
        }
      } else if (carrerasData is List) {
        for (var jsonCarrera in carrerasData) {
          final carrera = Carrera()..nombre = jsonCarrera['nombre'] as String;
          final materiasRawList = jsonCarrera['materias'];
          if (materiasRawList is List) {
            carrera.materiasIds = materiasRawList
                .map((e) => e.toString())
                .toList();
          } else {
            carrera.materiasIds = [];
          }
          carreras.add(carrera);
        }
      }

      return (materias: materias, carreras: carreras);
    } catch (e) {
      throw Exception('Error al descargar los datos desde GitHub: $e');
    }
  }

  Future<Map<String, dynamic>> fetchDonaciones() async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = DateTime.now().microsecondsSinceEpoch;
    final response = await _dio.get(
      'https://raw.githubusercontent.com/Mentitos/materiasungsporcentaje/main/donaciones.json?v=$timestamp$random',
      options: Options(
        headers: {
          'Cache-Control': 'no-cache, no-store, must-revalidate',
          'Pragma': 'no-cache',
          'Expires': '0',
        },
      ),
    );

    final rawData = response.data;
    if (rawData == null || (rawData is String && rawData.trim().isEmpty)) {
      throw Exception('El archivo donaciones.json está vacío.');
    }

    if (rawData is String) {
      return jsonDecode(rawData) as Map<String, dynamic>;
    }
    return rawData as Map<String, dynamic>;
  }

  Future<List<dynamic>> fetchTopDonantes() async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = DateTime.now().microsecondsSinceEpoch;
    final response = await _dio.get(
      'https://raw.githubusercontent.com/Mentitos/materiasungsporcentaje/main/donantes_top.json?v=$timestamp$random',
      options: Options(
        headers: {
          'Cache-Control': 'no-cache, no-store, must-revalidate',
          'Pragma': 'no-cache',
          'Expires': '0',
        },
      ),
    );

    final rawData = response.data;
    if (rawData == null || (rawData is String && rawData.trim().isEmpty)) {
      return [];
    }

    if (rawData is String) {
      return jsonDecode(rawData) as List<dynamic>;
    }
    return rawData as List<dynamic>;
  }
}
