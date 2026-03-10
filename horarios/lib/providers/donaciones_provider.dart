import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/sources/github_datasource.dart';

class MetaComunidad {
  final String nombre;
  final double monto;

  MetaComunidad({required this.nombre, required this.monto});

  factory MetaComunidad.fromJson(Map<String, dynamic> json) {
    return MetaComunidad(
      nombre: json['nombre'] as String,
      monto: (json['monto'] as num).toDouble(),
    );
  }
}

class Donante {
  final String nombre;
  final double monto;

  Donante({required this.nombre, required this.monto});

  factory Donante.fromJson(Map<String, dynamic> json) {
    return Donante(
      nombre: json['nombre'] as String,
      monto: (json['monto'] as num).toDouble(),
    );
  }
}

enum SyncStatus { idle, success, noChanges, error }

class DonacionesProvider extends ChangeNotifier {
  final GithubDatasource _datasource;

  String _titulo = 'Metas de la Comunidad';
  double _montoActual = 0.0;
  List<MetaComunidad> _metas = [];
  List<Donante> _topDonantes = [];
  bool _cargando = false;
  String? _error;
  SyncStatus _status = SyncStatus.idle;
  DateTime? _ultimaActualizacion;

  String get titulo => _titulo;
  double get montoActual => _montoActual;
  List<MetaComunidad> get metas => _metas;
  List<Donante> get topDonantes => _topDonantes;
  bool get cargando => _cargando;
  String? get error => _error;
  SyncStatus get status => _status;
  DateTime? get ultimaActualizacion => _ultimaActualizacion;

  DonacionesProvider({GithubDatasource? datasource})
    : _datasource = datasource ?? GithubDatasource() {
    _init();
  }

  Future<void> _init() async {
    await _loadLocal();
    refrescar();
  }

  Future<void> _loadLocal() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final donacionesStr = prefs.getString('cache_donaciones');
      final topStr = prefs.getString('cache_top_donantes');

      bool loaded = false;
      if (donacionesStr != null) {
        final data = jsonDecode(donacionesStr) as Map<String, dynamic>;
        _procesarDonaciones(data);
        loaded = true;
      }
      if (topStr != null) {
        final topData = jsonDecode(topStr) as List<dynamic>;
        _procesarTopDonantes(topData);
        loaded = true;
      }

      if (loaded) notifyListeners();
    } catch (e) {
      debugPrint('Error cargando cache local: $e');
    }
  }

  void _procesarDonaciones(Map<String, dynamic> data) {
    _titulo = data['titulo'] ?? 'Metas de la Comunidad';
    _montoActual = (data['monto_actual'] as num? ?? 0.0).toDouble();

    if (data['metas'] is List) {
      _metas = (data['metas'] as List)
          .map((m) => MetaComunidad.fromJson(m as Map<String, dynamic>))
          .toList();
    }
  }

  void _procesarTopDonantes(List<dynamic> topData) {
    _topDonantes = topData
        .map((d) => Donante.fromJson(d as Map<String, dynamic>))
        .toList();
    _topDonantes.sort((a, b) => b.monto.compareTo(a.monto));
  }

  /// Obtiene la meta actual (la primera que aún no se alcanzó)
  MetaComunidad? get metaProxima {
    if (_metas.isEmpty) return null;
    return _metas.firstWhere(
      (m) => m.monto > _montoActual,
      orElse: () => _metas.last,
    );
  }

  /// Obtiene la meta final (la última de la lista)
  MetaComunidad? get metaFinal {
    if (_metas.isEmpty) return null;
    return _metas.last;
  }

  /// Porcentaje de progreso hacia la meta final
  double get porcentaje {
    final goal = metaFinal;
    if (goal == null || goal.monto == 0) return 0.0;
    return (_montoActual / goal.monto).clamp(0.0, 1.0);
  }

  Future<void> refrescar({bool force = false}) async {
    _cargando = true;
    _error = null;
    _status = SyncStatus.idle;
    notifyListeners();

    try {
      final results = await Future.wait([
        _datasource.fetchDonaciones(),
        _datasource.fetchTopDonantes(),
      ]);

      final data = results[0] as Map<String, dynamic>;
      final topData = results[1] as List<dynamic>;

      final prefs = await SharedPreferences.getInstance();
      final oldDonaciones = prefs.getString('cache_donaciones');
      final oldTop = prefs.getString('cache_top_donantes');

      final newDonacionesStr = jsonEncode(data);
      final newTopStr = jsonEncode(topData);

      bool changed = false;

      // Solo actualizamos el estado si los datos de GitHub son distintos a los guardados o si es forzado
      if (force || newDonacionesStr != oldDonaciones) {
        _procesarDonaciones(data);
        await prefs.setString('cache_donaciones', newDonacionesStr);
        changed = true;
      }

      if (force || newTopStr != oldTop) {
        _procesarTopDonantes(topData);
        await prefs.setString('cache_top_donantes', newTopStr);
        changed = true;
      }

      _ultimaActualizacion = DateTime.now();

      if (changed) {
        _status = SyncStatus.success;
      } else {
        _status = SyncStatus.noChanges;
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error en DonacionesProvider: $e');
      _error =
          'Error al actualizar: GitHub aún no refleja el cambio o hay un problema de red.';
      _status = SyncStatus.error;
      notifyListeners();
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }

  void limpiarMensajes() {
    _error = null;
    _status = SyncStatus.idle;
  }
}
