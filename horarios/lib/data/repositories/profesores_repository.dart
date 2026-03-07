import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/profesor.dart';

class ProfesoresRepository {
  static const String _key = 'profesores_data';

  Future<void> guardarProfesores(List<Profesor> profesores) async {
    final prefs = await SharedPreferences.getInstance();
    final String jsonString = jsonEncode(
      profesores.map((p) => p.toJson()).toList(),
    );
    await prefs.setString(_key, jsonString);
  }

  Future<List<Profesor>> cargarProfesores() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString(_key);

    if (jsonString != null && jsonString.isNotEmpty) {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList
          .map((json) => Profesor.fromJson(json as Map<String, dynamic>))
          .toList();
    }
    return [];
  }
}
