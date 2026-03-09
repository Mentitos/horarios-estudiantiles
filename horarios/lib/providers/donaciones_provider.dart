import 'package:flutter/material.dart';
import '../data/sources/github_datasource.dart';

class DonacionesProvider extends ChangeNotifier {
  final GithubDatasource _datasource;
  
  double _monto = 0.0;
  double _meta = 50000.0;
  bool _cargando = false;

  double get monto => _monto;
  double get meta => _meta;
  bool get cargando => _cargando;
  
  double get porcentaje => (_monto / _meta).clamp(0.0, 1.0);

  DonacionesProvider({GithubDatasource? datasource}) 
      : _datasource = datasource ?? GithubDatasource() {
    refrescar();
  }

  Future<void> refrescar() async {
    _cargando = true;
    notifyListeners();

    try {
      final data = await _datasource.fetchDonaciones();
      _monto = (data['monto'] as num).toDouble();
      _meta = (data['meta'] as num).toDouble();
    } catch (e) {
      debugPrint('Error en DonacionesProvider: $e');
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }
}
