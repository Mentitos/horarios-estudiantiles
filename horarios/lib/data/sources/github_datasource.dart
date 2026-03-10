import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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

      List<Materia> materias = [];
      for (var jsonMateria in materiasJsonList) {
        if (jsonMateria is! Map) continue;
        final materia = Materia()
          ..materiaId = jsonMateria['id'].toString()
          ..nombre = (jsonMateria['nombre'] ?? 'Sin nombre') as String;
        materias.add(materia);
      }

      List<Carrera> carreras = [];
      if (carrerasData is Map) {
        for (var entry in carrerasData.entries) {
          final grupoNombre = entry.key as String;
          final carrerasJsonList = entry.value;

          if (carrerasJsonList is List) {
            for (var jsonCarrera in carrerasJsonList) {
              if (jsonCarrera is! Map) continue;
              final carrera = Carrera()
                ..nombre =
                    (jsonCarrera['nombre'] ?? 'Carrera desconocida') as String
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
          if (jsonCarrera is! Map) continue;
          final carrera = Carrera()
            ..nombre =
                (jsonCarrera['nombre'] ?? 'Carrera desconocida') as String;
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
    } on DioException catch (e) {
      String msg = 'Error de conexión con GitHub';
      if (e.type == DioExceptionType.connectionTimeout)
        msg = 'Tiempo de conexión agotado';
      if (e.type == DioExceptionType.receiveTimeout)
        msg = 'Error al recibir datos';
      if (e.response?.statusCode == 404)
        msg = 'No se encontraron las planillas en el servidor';
      throw Exception('$msg: ${e.message}');
    } catch (e) {
      throw Exception('Error al procesar los datos: $e');
    }
  }

  Future<Map<String, dynamic>> fetchDonaciones() async {
    try {
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
    } on DioException catch (e) {
      throw Exception(
        'Error al obtener donaciones (${e.response?.statusCode}): ${e.message}',
      );
    } catch (e) {
      throw Exception('Error al procesar donaciones: $e');
    }
  }

  Future<List<dynamic>> fetchTopDonantes() async {
    try {
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
    } on DioException {
      return []; // Return empty list on network error for non-critical data
    } catch (e) {
      debugPrint('Error fetchTopDonantes: $e');
      return [];
    }
  }
}
