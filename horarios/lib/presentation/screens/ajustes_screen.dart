import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/ajustes/apariencia_section.dart';
import '../widgets/ajustes/carrera_section.dart';
import '../widgets/ajustes/notificaciones_section.dart';
import '../widgets/ajustes/progreso_academico_section.dart';
import '../widgets/ajustes/actualizar_datos_section.dart';
import '../widgets/ajustes/avanzado_section.dart';
import '../widgets/ajustes/acerca_de_section.dart';
import '../../providers/donaciones_provider.dart';

class AjustesScreen extends StatefulWidget {
  const AjustesScreen({super.key});

  @override
  State<AjustesScreen> createState() => _AjustesScreenState();
}

class _AjustesScreenState extends State<AjustesScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) context.read<DonacionesProvider>().refrescar();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configuración'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          AparienciaSection(),
          SizedBox(height: 16),
          CarreraSection(),
          SizedBox(height: 16),
          NotificacionesSection(),
          SizedBox(height: 16),
          ProgresoAcademicoSection(),
          ActualizarDatosSection(),
          AvanzadoSection(),
          SizedBox(height: 16),
          AcercaDeSection(),
          SizedBox(height: 32),
        ],
      ),
    );
  }
}
