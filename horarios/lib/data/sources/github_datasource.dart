import 'dart:convert';
import 'package:flutter/foundation.dart';
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
      for (var jsonCarrera in carrerasJsonList) {
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

      return (materias: materias, carreras: carreras);
    } catch (e) {
      throw Exception('Error al descargar los datos desde GitHub: $e');
    }
  }

  Future<Map<String, dynamic>> fetchDonaciones() async {
    try {
      final response = await _dio.get(
        'https://raw.githubusercontent.com/Mentitos/materiasungsporcentaje/main/donaciones.json',
      );

      final rawData = response.data;
      if (rawData == null || (rawData is String && rawData.trim().isEmpty)) {
        return {
          'titulo': 'Metas de la Comunidad',
          'monto_actual': 0,
          'metas': [],
        };
      }

      if (rawData is String) {
        return jsonDecode(rawData) as Map<String, dynamic>;
      }
      return rawData as Map<String, dynamic>;
    } catch (e) {
      debugPrint('Error al buscar donaciones: $e');
      return {
        'titulo': 'Metas de la Comunidad',
        'monto_actual': 0,
        'metas': [],
      };
    }
  }
}
