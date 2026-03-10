import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/materias_provider.dart';
import '../../../providers/perfil_provider.dart';
import '../../../data/sources/local_datasource.dart';

class ActualizarDatosSection extends StatefulWidget {
  const ActualizarDatosSection({super.key});

  @override
  State<ActualizarDatosSection> createState() => _ActualizarDatosSectionState();
}

class _ActualizarDatosSectionState extends State<ActualizarDatosSection> {
  @override
  Widget build(BuildContext context) {
    final materiasProvider = context.watch<MateriasProvider>();
    final perfilProvider = context.watch<PerfilProvider>();

    if (perfilProvider.esAlumnoExterno) return const SizedBox.shrink();

    return Column(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Actualizar datos desde la web',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Forzar la descarga de la última versión de materias y carreras.',
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: materiasProvider.cargando
                      ? null
                      : () async {
                          try {
                            await context.read<MateriasProvider>().refrescar();
                            if (!context.mounted) return;

                            final locales = await LocalDatasource()
                                .leerMateriasCustom();
                            final hayOcultas = locales.any((c) => c.estaOculta);

                            if (hayOcultas) {
                              if (!context.mounted) return;
                              final restaurar = await showDialog<bool>(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text('Datos actualizados'),
                                  content: const Text(
                                    'Se descargaron los datos correctamente. Tienes materias oficiales que ocultaste previamente, ¿deseas restaurarlas y volver a verlas?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(ctx).pop(false),
                                      child: const Text('No'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () =>
                                          Navigator.of(ctx).pop(true),
                                      child: const Text('Restaurar'),
                                    ),
                                  ],
                                ),
                              );

                              if (restaurar == true) {
                                await LocalDatasource()
                                    .limpiarMateriasOcultas();
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Planillas restauradas correctamente.',
                                      ),
                                    ),
                                  );
                                }
                              }
                            } else {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Actualizadas!'),
                                  ),
                                );
                              }
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Error: $e')),
                              );
                            }
                          }
                        },
                  child: materiasProvider.cargando
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Descargar JSON'),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
