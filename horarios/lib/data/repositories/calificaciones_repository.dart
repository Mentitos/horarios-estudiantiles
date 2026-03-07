import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/calificacion.dart';

class CalificacionesRepository {
  static const String _key = 'calificaciones_data';

  Future<void> guardarCalificaciones(List<Calificacion> calificaciones) async {
    final prefs = await SharedPreferences.getInstance();
    final String jsonString = jsonEncode(
      calificaciones.map((c) => c.toJson()).toList(),
    );
    await prefs.setString(_key, jsonString);
  }

  Future<List<Calificacion>> cargarCalificaciones() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString(_key);

    if (jsonString != null && jsonString.isNotEmpty) {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList
          .map((json) => Calificacion.fromJson(json as Map<String, dynamic>))
          .toList();
    }
    return [];
  }
}
