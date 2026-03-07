import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import '../../providers/grabaciones_provider.dart';
import '../../data/models/grabacion.dart';

//   Despues de este poryecto no se que mas hacer, es el 7/3/26 y no tengo otro
//   Proyecto en mente que pueda hacerlo
class GrabacionesScreen extends StatelessWidget {
  const GrabacionesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GrabacionesProvider>(
      builder: (context, provider, child) {
        if (provider.cargando) {
          return const Center(child: CircularProgressIndicator());
        }

        final grabaciones = provider.grabaciones;

        return Scaffold(
          body: grabaciones.isEmpty
              ? const Center(
                  child: Text(
                    'No hay grabaciones aún.',
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.only(top: 8, bottom: 80),
                  itemCount: grabaciones.length,
                  itemBuilder: (context, index) {
                    final grabacion = grabaciones[index];
                    final bool isPlaying = provider.playingId == grabacion.id;

                    final String labelDia = _getLabelDia(grabacion.fecha);
                    final String labelAnterior = index > 0
                        ? _getLabelDia(grabaciones[index - 1].fecha)
                        : '';

                    final bool mostrarCabeceraInfo = labelDia != labelAnterior;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (mostrarCabeceraInfo)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
                            child: Text(
                              labelDia,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          leading: IconButton(
                            icon: Icon(
                              isPlaying
                                  ? Icons.pause_circle_filled
                                  : Icons.play_circle_fill,
                              color: Theme.of(
                                context,
                              ).colorScheme.primaryContainer,
                              size: 40,
                            ),
                            onPressed: () {
                              provider.reproducirORepausar(grabacion);
                            },
                          ),
                          title: Text(
                            grabacion
                                .id, // En tu mockup se usaba el ID/timestamp como título
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(_formatearFechaTexto(grabacion.fecha)),
                          trailing: PopupMenuButton<String>(
                            icon: const Icon(Icons.more_vert),
                            onSelected: (String result) {
                              if (result == 'eliminar') {
                                _mostrarDialogoEliminar(context, grabacion);
                              } else if (result == 'compartir') {
                                _compartirGrabacion(grabacion);
                              }
                            },
                            itemBuilder: (BuildContext context) =>
                                <PopupMenuEntry<String>>[
                                  const PopupMenuItem<String>(
                                    value: 'compartir',
                                    child: Text('Compartir'),
                                  ),
                                  const PopupMenuItem<String>(
                                    value: 'eliminar',
                                    child: Text('Eliminar'),
                                  ),
                                ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: provider.isRecording
                ? Theme.of(context).colorScheme.errorContainer
                : Theme.of(context).colorScheme.primaryContainer,
            onPressed: () {
              if (provider.isRecording) {
                provider.detenerGrabacion();
              } else {
                provider.iniciarGrabacion();
              }
            },
            child: Icon(
              provider.isRecording ? Icons.stop : Icons.mic,
              color: provider.isRecording
                  ? Theme.of(context).colorScheme.onErrorContainer
                  : Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
        );
      },
    );
  }

  String _getLabelDia(DateTime fecha) {
    final DateTime ahora = DateTime.now();
    if (fecha.year == ahora.year &&
        fecha.month == ahora.month &&
        fecha.day == ahora.day) {
      return 'Hoy';
    }
    if (fecha.year == ahora.year &&
        fecha.month == ahora.month &&
        fecha.day == ahora.day - 1) {
      return 'Ayer';
    }
    return ''; // Si no es hoy ni ayer, solo se agrupa con un espacio en blanco
  }

  String _formatearFechaTexto(DateTime fecha) {
    Intl.defaultLocale = 'es';
    return DateFormat('d \'de\' MMMM \'de\' yyyy').format(fecha);
  }

  void _mostrarDialogoEliminar(BuildContext context, Grabacion grabacion) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Eliminar grabación'),
          content: const Text(
            '¿Estás seguro de que deseas eliminar este audio permanentemente?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                context.read<GrabacionesProvider>().eliminarGrabacion(
                  grabacion.id,
                );
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Grabación eliminada')),
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  void _compartirGrabacion(Grabacion grabacion) async {
    try {
      final xFile = XFile(grabacion.pathArchivo);
      await Share.shareXFiles(
        [xFile],
        text:
            'Escucha esta clase grabada el ${_formatearFechaTexto(grabacion.fecha)}',
      );
    } catch (e) {
      debugPrint("Error al compartir: $e");
    }
  }
}
