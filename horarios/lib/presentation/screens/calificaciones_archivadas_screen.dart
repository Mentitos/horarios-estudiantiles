import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/calificaciones_provider.dart';
import 'detalle_calificacion_screen.dart';

//   El semestre pasado aprobe 6 materias e hice Finanazas Libre en el medio
//   tambien hice un curso de desarrollo de videojuegos y cree "Dreaming"
//   El aumento de la productividad del trabajo hace parecer que tienen poco valor?
//   No lo se, quiero terminar
class CalificacionesArchivadasScreen extends StatelessWidget {
  const CalificacionesArchivadasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calificaciones Archivadas')),
      body: Consumer<CalificacionesProvider>(
        builder: (context, provider, child) {
          final notasArchivadas = provider.calificacionesArchivadas;

          if (notasArchivadas.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 80,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Tu archivo está vacío',
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: notasArchivadas.length,
            itemBuilder: (ctx, i) {
              final nota = notasArchivadas[i];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                elevation: 0,
                color: Theme.of(
                  context,
                ).colorScheme.surfaceVariant.withOpacity(0.5),
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHighest,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.inventory_2,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  title: Text(
                    nota.nombreMateria,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    '${nota.tipoEvaluacion} • ${nota.valorPorcentual > 0 ? nota.valorPorcentual : 0}%',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        nota.titulo,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.unarchive_outlined),
                        onPressed: () {
                          provider.toggleArchivar(nota.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Calificación restaurada'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        tooltip: 'Recuperar',
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            DetalleCalificacionScreen(calificacionId: nota.id),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
