import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/grabacion.dart';

class GrabacionesRepository {
  static const String _key = 'grabaciones_metadata';

  Future<void> guardarGrabaciones(List<Grabacion> grabaciones) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(grabaciones.map((g) => g.toJson()).toList());
    await prefs.setString(_key, jsonString);
  }

  Future<List<Grabacion>> cargarGrabaciones() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString(_key);

    if (jsonString != null && jsonString.isNotEmpty) {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList
          .map((json) => Grabacion.fromJson(json as Map<String, dynamic>))
          .toList();
    }
    return [];
  }
}
