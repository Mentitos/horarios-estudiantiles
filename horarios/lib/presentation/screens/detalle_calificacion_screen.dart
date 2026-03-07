import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/calificaciones_provider.dart';
import 'agregar_calificacion_screen.dart';

//   Mi mujer esta trabajando y estudiando, no se como hace ella
//   Ojala que todo mejor, no me gusta que vuelva a las 1 de la mañana a su casa
//   Tanto por su seguridad como por el timepo que pasamos juntos
//   Pero bueno son cosas que pasan
class DetalleCalificacionScreen extends StatelessWidget {
  final String calificacionId;

  const DetalleCalificacionScreen({super.key, required this.calificacionId});

  @override
  Widget build(BuildContext context) {
    return Consumer<CalificacionesProvider>(
      builder: (context, provider, child) {
        final idx = provider.calificaciones.indexWhere(
          (c) => c.id == calificacionId,
        );
        if (idx == -1) {
          return Scaffold(
            appBar: AppBar(title: const Text('Detalle')),
            body: const Center(child: Text('Calificación no encontrada')),
          );
        }

        final notaObj = provider.calificaciones[idx];

        return Scaffold(
          appBar: AppBar(
            title: const Text('Detalle de calificación'),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          AgregarCalificacionScreen(calificacionEdit: notaObj),
                      fullscreenDialog: true,
                    ),
                  );
                },
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                notaObj.titulo,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.school_outlined),
                title: const Text('Asignatura'),
                subtitle: Text(notaObj.nombreMateria),
              ),
              ListTile(
                leading: const Icon(Icons.calendar_today_outlined),
                title: const Text('Fecha'),
                subtitle: Text(
                  '${notaObj.fecha.day}/${notaObj.fecha.month}/${notaObj.fecha.year}',
                ),
              ),
              ListTile(
                leading: const Icon(Icons.local_offer_outlined),
                title: const Text('Evaluación'),
                subtitle: Text(notaObj.tipoEvaluacion),
              ),
              ListTile(
                leading: const Icon(Icons.scale_outlined),
                title: const Text('Valor porcentual'),
                subtitle: Text('${notaObj.valorPorcentual}%'),
              ),
              if (notaObj.nota.isNotEmpty) ...[
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.notes),
                  title: const Text('Descripción'),
                  subtitle: Text(
                    notaObj.nota,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
