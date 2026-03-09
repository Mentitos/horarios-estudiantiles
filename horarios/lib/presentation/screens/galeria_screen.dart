import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'dart:io';
import 'dart:math';
import '../../providers/fotos_provider.dart';
import '../../providers/horario_provider.dart';
import '../../data/models/foto.dart';

class GaleriaScreen extends StatelessWidget {
  const GaleriaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FotosProvider>();
    final isSelectionMode = provider.isSelectionMode;

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
          children: [
            _buildTodasTab(context, provider),
            _buildMateriasTab(context, provider),
          ],
        ),
        floatingActionButton: isSelectionMode
            ? null
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FloatingActionButton.small(
                    heroTag: 'galeria_pick',
                    onPressed: () => provider.seleccionarDeGaleria(),
                    child: const Icon(Icons.photo_library),
                  ),
                  const SizedBox(height: 12),
                  FloatingActionButton(
                    heroTag: 'galeria_camera',
                    onPressed: () => provider.tomarFoto(),
                    child: const Icon(Icons.camera_alt),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildTodasTab(BuildContext context, FotosProvider provider) {
    if (provider.cargando) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.fotos.isEmpty) {
      return const Center(child: Text('No hay fotos aún.'));
    }

    return MasonryGridView.count(
      padding: const EdgeInsets.all(8),
      crossAxisCount: 2,
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      itemCount: provider.fotos.length,
      itemBuilder: (context, index) {
        return _buildFotoItem(context, provider.fotos[index], provider);
      },
    );
  }

  Widget _buildMateriasTab(BuildContext context, FotosProvider provider) {
    final materias = context.watch<HorarioProvider>().horario?.materiasSeleccionadas ?? [];

    if (materias.isEmpty) {
      return const Center(child: Text('Cargá materias en tu horario para ver fotos aquí'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: materias.length,
      itemBuilder: (context, index) {
        final materia = materias[index];
        final fotosMateria = provider.fotos.where((f) => f.materiaId == materia.materiaId).toList();
        final color = Color(materia.colorARGB ?? 0xFF000000);

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
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
                fotosMateria.isEmpty
                    ? 'Sin fotos'
                    : '${fotosMateria.length} fotos',
              ),
              children: fotosMateria.isNotEmpty
                  ? [
                      MasonryGridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(8),
                        crossAxisCount: 2,
                        mainAxisSpacing: 4,
                        crossAxisSpacing: 4,
                        itemCount: fotosMateria.length,
                        itemBuilder: (ctx, i) {
                          return _buildFotoItem(
                            context,
                            fotosMateria[i],
                            provider,
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
  }

  Widget _buildFotoItem(
    BuildContext context,
    Foto foto,
    FotosProvider provider,
  ) {
    final isSelected = provider.selectedIds.contains(foto.id);
    final isSelectionMode = provider.isSelectionMode;

    return GestureDetector(
      onTap: () {
        if (isSelectionMode) {
          provider.toggleSelection(foto.id);
        } else {
          _verFotoGrande(context, foto);
        }
      },
      onLongPress: () {
        if (!isSelectionMode) {
          provider.toggleSelection(foto.id);
        }
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          decoration: BoxDecoration(
            border: isSelected
                ? Border.all(
                    color: Theme.of(context).colorScheme.primary,
                    width: 3,
                  )
                : null,
          ),
          child: Stack(
            children: [
              Image.file(File(foto.pathArchivo), fit: BoxFit.fitWidth),
              if (isSelected)
                Positioned.fill(
                  child: Container(
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                    child: const Center(
                        child: Icon(Icons.check_circle, color: Colors.white, size: 32)),
                  ),
                ),
              if (!isSelectionMode)
                Positioned(
                  top: 0,
                  right: 0,
                  child: PopupMenuButton<String>(
                    icon: const Icon(
                      Icons.more_vert,
                      color: Colors.white,
                      shadows: [Shadow(color: Colors.black, blurRadius: 4)],
                    ),
                    onSelected: (value) {
                      switch (value) {
                        case 'detalles':
                          _mostrarDetalles(context, foto);
                          break;
                        case 'renombrar':
                          _mostrarDialogoRenombrar(context, foto);
                          break;
                        case 'vincular':
                          _mostrarDialogoVincularMateria(context, foto);
                          break;
                        case 'compartir':
                          _compartirFoto(foto);
                          break;
                        case 'eliminar':
                          _mostrarDialogoEliminar(context, foto);
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(value: 'detalles', child: Text('Detalles')),
                      const PopupMenuItem(value: 'renombrar', child: Text('Renombrar')),
                      const PopupMenuItem(value: 'vincular', child: Text('Vincular a materia')),
                      const PopupMenuItem(value: 'compartir', child: Text('Compartir')),
                      PopupMenuItem(
                        value: 'eliminar',
                        child: Text(
                          'Eliminar',
                          style: TextStyle(color: Theme.of(context).colorScheme.error),
                        ),
                      ),
                    ],
                  ),
                ),
              if (foto.nombre != null || foto.materiaId != null)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    color: Colors.black54,
                    child: Text(
                      foto.nombre ?? 'Vinculada',
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _verFotoGrande(BuildContext context, Foto foto) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text(foto.nombre ?? 'Detalle de Foto'),
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
          ),
          backgroundColor: Colors.black,
          body: Center(
            child: InteractiveViewer(
              child: Image.file(File(foto.pathArchivo)),
            ),
          ),
        ),
      ),
    );
  }

  void _mostrarDetalles(BuildContext context, Foto foto) {
    final file = File(foto.pathArchivo);
    final size = file.existsSync() ? file.lengthSync() : 0;
    final dateStr = DateFormat('dd/MM/yyyy HH:mm').format(foto.fecha);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Detalles de la imagen'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _detailItem('Nombre', foto.nombre ?? 'Sin nombre'),
            _detailItem('Capturada', dateStr),
            _detailItem('Tamaño', _formatFileSize(size)),
            _detailItem('Ruta', foto.pathArchivo),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cerrar')),
        ],
      ),
    );
  }

  Widget _detailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          Text(value, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  String _formatFileSize(int bytes) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB"];
    var i = (log(bytes) / log(1024)).floor();
    return ((bytes / pow(1024, i)).toStringAsFixed(2)) + ' ' + suffixes[i];
  }

  void _mostrarDialogoRenombrar(BuildContext context, Foto foto) {
    final controller = TextEditingController(text: foto.nombre ?? '');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Renombrar foto'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Nombre de la foto'),
          autofocus: true,
          textCapitalization: TextCapitalization.sentences,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              context.read<FotosProvider>().actualizarFoto(foto.id, nuevoNombre: controller.text.trim());
              Navigator.pop(ctx);
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  void _mostrarDialogoVincularMateria(BuildContext context, Foto foto) {
    final materias = context.read<HorarioProvider>().horario?.materiasSeleccionadas ?? [];

    if (materias.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No tenés materias agregadas aún.')));
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Vincular a materia'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: materias.length,
            itemBuilder: (c, i) {
              final mat = materias[i];
              final isSelected = foto.materiaId == mat.materiaId;
              return ListTile(
                title: Text(mat.materiaNombre ?? 'Sin nombre'),
                trailing: isSelected ? const Icon(Icons.check_circle, color: Colors.green) : null,
                onTap: () {
                  context.read<FotosProvider>().actualizarFoto(foto.id,
                      nuevaMateriaId: isSelected ? null : mat.materiaId);
                  Navigator.pop(ctx);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _mostrarDialogoEliminar(BuildContext context, Foto foto) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar foto'),
        content: const Text('¿Estás seguro de que deseas eliminar esta imagen permanentemente?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          TextButton(
            onPressed: () {
              context.read<FotosProvider>().eliminarFoto(foto.id);
              Navigator.pop(ctx);
            },
            style: TextButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.error),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  void _compartirFoto(Foto foto) async {
    try {
      await Share.shareXFiles([XFile(foto.pathArchivo)], text: 'Mirá esta foto de mi clase');
    } catch (e) {
      debugPrint("Error al compartir: $e");
    }
  }
}
