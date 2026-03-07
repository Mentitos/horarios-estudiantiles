import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import '../../providers/grabaciones_provider.dart';
import '../../providers/horario_provider.dart';
import '../../data/models/grabacion.dart';

//   Despues de este poryecto no se que mas hacer, es el 7/3/26 y no tengo otro
//   Proyecto en mente que pueda hacerlo
class GrabacionesScreen extends StatelessWidget {
  const GrabacionesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Todas'),
              Tab(text: 'Materias'),
            ],
          ),
        ),
        body: TabBarView(
          children: [_buildTodasTab(context), _buildMateriasTab(context)],
        ),
        floatingActionButton: Consumer<GrabacionesProvider>(
          builder: (context, provider, child) {
            return FloatingActionButton(
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
            );
          },
        ),
      ),
    );
  }

  Widget _buildTodasTab(BuildContext context) {
    return Consumer<GrabacionesProvider>(
      builder: (context, provider, child) {
        if (provider.cargando) {
          return const Center(child: CircularProgressIndicator());
        }

        final grabaciones = provider.grabaciones;

        if (grabaciones.isEmpty) {
          return const Center(
            child: Text(
              'No hay grabaciones aún.',
              style: TextStyle(fontSize: 16),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.only(top: 8, bottom: 80),
          itemCount: grabaciones.length,
          itemBuilder: (context, index) {
            final grabacion = grabaciones[index];
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
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                _buildGrabacionItem(context, grabacion, provider),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildMateriasTab(BuildContext context) {
    return Consumer2<HorarioProvider, GrabacionesProvider>(
      builder: (context, horarioProv, grabacionesProv, child) {
        final materias = horarioProv.horario?.materiasSeleccionadas ?? [];

        if (materias.isEmpty) {
          return const Center(
            child: Text(
              'Cargá materias en tu horario para ver grabaciones aquí',
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.only(
            top: 16,
            bottom: 80,
            left: 16,
            right: 16,
          ),
          itemCount: materias.length,
          itemBuilder: (context, index) {
            final materia = materias[index];
            final color = Color(materia.colorARGB ?? 0xFF000000);
            final grabacionesMateria = grabacionesProv.grabaciones
                .where((g) => g.materiaId == materia.materiaId)
                .toList();

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Theme(
                data: Theme.of(
                  context,
                ).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  leading: Container(
                    width: 12,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  title: Text(
                    materia.materiaNombre ?? 'Materia',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    grabacionesMateria.isEmpty
                        ? 'Sin grabaciones'
                        : '${grabacionesMateria.length} grabaciones',
                  ),
                  children: grabacionesMateria.isNotEmpty
                      ? [
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: grabacionesMateria.length,
                            itemBuilder: (ctx, i) {
                              return _buildGrabacionItem(
                                context,
                                grabacionesMateria[i],
                                grabacionesProv,
                              );
                            },
                          ),
                        ]
                      : [],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildGrabacionItem(
    BuildContext context,
    Grabacion grabacion,
    GrabacionesProvider provider,
  ) {
    final bool isPlaying = provider.playingId == grabacion.id;
    final horarioProvider = context.read<HorarioProvider>();
    String? nombreMateria;

    if (grabacion.materiaId != null) {
      final materia = horarioProvider.horario?.materiasSeleccionadas
          .where((m) => m.materiaId == grabacion.materiaId)
          .firstOrNull;
      nombreMateria = materia?.materiaNombre;
    }

    String subtitle = _formatearFechaTexto(grabacion.fecha);
    if (nombreMateria != null) {
      subtitle += ' • $nombreMateria';
    }

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: IconButton(
        icon: Icon(
          isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
          color: Theme.of(context).colorScheme.primaryContainer,
          size: 40,
        ),
        onPressed: () {
          provider.reproducirORepausar(grabacion);
        },
      ),
      title: Text(
        grabacion.nombre ?? grabacion.id,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(subtitle),
      trailing: PopupMenuButton<String>(
        icon: const Icon(Icons.more_vert),
        onSelected: (String result) {
          if (result == 'eliminar') {
            _mostrarDialogoEliminar(context, grabacion);
          } else if (result == 'compartir') {
            _compartirGrabacion(grabacion);
          } else if (result == 'renombrar') {
            _mostrarDialogoRenombrar(context, grabacion);
          } else if (result == 'vincular') {
            _mostrarDialogoVincularMateria(context, grabacion);
          }
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
          const PopupMenuItem<String>(
            value: 'renombrar',
            child: Text('Renombrar'),
          ),
          const PopupMenuItem<String>(
            value: 'vincular',
            child: Text('Vincular a materia'),
          ),
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

  void _mostrarDialogoRenombrar(BuildContext context, Grabacion grabacion) {
    final controller = TextEditingController(
      text: grabacion.nombre ?? grabacion.id,
    );

    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text('Renombrar grabación'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Nombre de la grabación',
            ),
            autofocus: true,
            textCapitalization: TextCapitalization.sentences,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                final nuevoNombre = controller.text.trim();
                context.read<GrabacionesProvider>().actualizarGrabacion(
                  grabacion.id,
                  nuevoNombre: nuevoNombre.isNotEmpty ? nuevoNombre : null,
                );
                Navigator.pop(ctx);
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  void _mostrarDialogoVincularMateria(
    BuildContext context,
    Grabacion grabacion,
  ) {
    final materias =
        context.read<HorarioProvider>().horario?.materiasSeleccionadas ?? [];

    if (materias.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No tenés materias agregadas aún.')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text('Vincular a materia'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: materias.length,
              itemBuilder: (c, i) {
                final mat = materias[i];
                final isSelected = grabacion.materiaId == mat.materiaId;
                return ListTile(
                  title: Text(mat.materiaNombre ?? 'Sin nombre'),
                  trailing: isSelected
                      ? const Icon(Icons.check_circle, color: Colors.green)
                      : null,
                  onTap: () {
                    context.read<GrabacionesProvider>().actualizarGrabacion(
                      grabacion.id,
                      nuevaMateriaId: isSelected ? null : mat.materiaId,
                    );
                    Navigator.pop(ctx);
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  void _mostrarDialogoEliminar(BuildContext context, Grabacion grabacion) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text('Eliminar grabación'),
          content: const Text(
            '¿Estás seguro de que deseas eliminar este audio permanentemente?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                context.read<GrabacionesProvider>().eliminarGrabacion(
                  grabacion.id,
                );
                Navigator.pop(ctx);
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
      await SharePlus.instance.share(
        ShareParams(
          files: [xFile],
          text:
              'Escucha esta clase grabada el ${_formatearFechaTexto(grabacion.fecha)}',
        ),
      );
    } catch (e) {
      debugPrint("Error al compartir: $e");
    }
  }
}
