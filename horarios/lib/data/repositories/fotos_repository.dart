import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/foto.dart';

class FotosRepository {
  static const String _key = 'fotos_data';

  Future<void> guardarFotos(List<Foto> fotos) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = fotos.map((f) => f.toJson()).toList();
    await prefs.setString(_key, jsonEncode(jsonList));
  }

  Future<List<Foto>> cargarFotos() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_key);
    if (jsonStr == null) return [];

    final List<dynamic> jsonList = jsonDecode(jsonStr);
    return jsonList.map((j) => Foto.fromJson(j)).toList();
  }
}
