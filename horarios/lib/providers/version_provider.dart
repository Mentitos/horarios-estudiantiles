import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VersionProvider extends ChangeNotifier {
  final Dio _dio = Dio();
  
  // Fecha de esta versión de la app. Se debe actualizar manualmente al compilar una nueva.
  final DateTime _buildDate = DateTime.parse('2026-03-09T04:20:00');
  
  bool _checkPerformed = false;
  bool _isUpToDate = false;

  String _currentVersion = '';
  String _downloadUrl = '';
  bool _isUpdateAvailable = false;
  bool _loading = false;
  String? _error;

  String get currentVersion => _currentVersion;
  String get downloadUrl => _downloadUrl;
  bool get isUpdateAvailable => _isUpdateAvailable;
  bool get isUpToDate => _isUpToDate;
  bool get loading => _loading;
  bool get checkPerformed => _checkPerformed;
  String? get error => _error;

  VersionProvider() {
    _init();
  }

  Future<void> _init() async {
    final info = await PackageInfo.fromPlatform();
    _currentVersion = '${info.version}+${info.buildNumber}';
    notifyListeners();
  }

  Future<void> checkUpdates() async {
    _loading = true;
    _error = null;
    _checkPerformed = false;
    _isUpToDate = false;
    notifyListeners();

    try {
      final response = await _dio.get(
        'https://raw.githubusercontent.com/Mentitos/horarios-estudiantiles/main/version.json',
      );

      if (response.statusCode == 200) {
        final data = response.data is String ? jsonDecode(response.data) : response.data;
        _downloadUrl = data['url'] ?? 'https://drive.google.com/drive/folders/1undizUYV86eKT9B_i96ILJl7ty8pvqUs?usp=drive_link';
        
        final remoteDate = DateTime.parse(data['fecha']);
        
        // Comparamos la fecha remota con la fecha de este build
        _isUpdateAvailable = remoteDate.isAfter(_buildDate);
        _isUpToDate = !_isUpdateAvailable;
        _checkPerformed = true;
      }
    } catch (e) {
      _error = 'No se pudo verificar: $e';
      debugPrint(_error);
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> marcarComoActualizada(String fecha) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_known_version_date', fecha);
    _isUpdateAvailable = false;
    notifyListeners();
  }
}
