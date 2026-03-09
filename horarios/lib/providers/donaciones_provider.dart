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

class DonacionesProvider extends ChangeNotifier {
  final GithubDatasource _datasource;

  String _titulo = 'Metas de la Comunidad';
  double _montoActual = 0.0;
  List<MetaComunidad> _metas = [];
  bool _cargando = false;

  String get titulo => _titulo;
  double get montoActual => _montoActual;
  List<MetaComunidad> get metas => _metas;
  bool get cargando => _cargando;

  /// Obtiene la meta actual (la primera que aún no se alcanzó)
  MetaComunidad? get metaProxima {
    if (_metas.isEmpty) return null;
    return _metas.firstWhere(
      (m) => m.monto > _montoActual,
      orElse: () => _metas.last,
    );
  }

  /// Porcentaje de progreso hacia la meta actual/próxima
  double get porcentaje {
    final proxima = metaProxima;
    if (proxima == null || proxima.monto == 0) return 0.0;
    return (_montoActual / proxima.monto).clamp(0.0, 1.0);
  }

  DonacionesProvider({GithubDatasource? datasource})
    : _datasource = datasource ?? GithubDatasource() {
    refrescar();
  }

  Future<void> refrescar() async {
    _cargando = true;
    notifyListeners();

    try {
      final data = await _datasource.fetchDonaciones();
      _titulo = data['titulo'] ?? 'Metas de la Comunidad';
      _montoActual = (data['monto_actual'] as num? ?? 0.0).toDouble();

      if (data['metas'] is List) {
        _metas = (data['metas'] as List)
            .map((m) => MetaComunidad.fromJson(m as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      debugPrint('Error en DonacionesProvider: $e');
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }
}
