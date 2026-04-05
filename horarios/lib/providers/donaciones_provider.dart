import 'dart:convert';
import 'package:flutter/material.dart';
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
  String? _lastDataHash;

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
    refrescar();
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

  MetaComunidad? get metaProxima {
    if (_metas.isEmpty) return null;
    return _metas.firstWhere(
      (m) => m.monto > _montoActual,
      orElse: () => _metas.last,
    );
  }

  MetaComunidad? get metaFinal {
    if (_metas.isEmpty) return null;
    return _metas.last;
  }

  double get porcentaje {
    final goal = metaProxima;
    if (goal == null || goal.monto == 0) return 0.0;
    return (_montoActual / goal.monto).clamp(0.0, 1.0);
  }

  Future<void> refrescar({bool force = false}) async {
    _cargando = true;
    _error = null;
    _status = SyncStatus.idle;

    if (force) {
      _montoActual = 0.0;
      _metas = [];
      _topDonantes = [];
    }

    notifyListeners();

    try {
      final results = await Future.wait([
        _datasource.fetchDonaciones(),
        _datasource.fetchTopDonantes(),
      ]);

      final data = results[0] as Map<String, dynamic>;
      final topData = results[1] as List<dynamic>;

      final currentDataHash = jsonEncode(data) + jsonEncode(topData);
      bool isSame = _lastDataHash == currentDataHash;

      _procesarDonaciones(data);
      _procesarTopDonantes(topData);
      _lastDataHash = currentDataHash;

      _ultimaActualizacion = DateTime.now();

      if (!force && isSame) {
        _status = SyncStatus.noChanges;
      } else {
        _status = SyncStatus.success;
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error en DonacionesProvider: $e');
      _status = SyncStatus.error;
      _error = 'Las donaciones se ven con internet';

      _montoActual = 0.0;
      _metas = [];
      _topDonantes = [];
      _lastDataHash = null;

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
