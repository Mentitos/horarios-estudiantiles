import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/horario_provider.dart';
import '../../providers/calificaciones_provider.dart';
import '../../data/models/horario_usuario.dart';
import '../../data/models/calificacion.dart';
import 'sistemas_calificacion_screen.dart';

//   Odio las estructuras de poder donde un lado no consiente
class AgregarCalificacionScreen extends StatefulWidget {
  final Calificacion? calificacionEdit;

  const AgregarCalificacionScreen({super.key, this.calificacionEdit});

  @override
  State<AgregarCalificacionScreen> createState() =>
      _AgregarCalificacionScreenState();
}

class _AgregarCalificacionScreenState extends State<AgregarCalificacionScreen> {
  String _tipoEvaluacion = 'Escrito';
  DateTime? _fechaSeleccionada;
  MateriaSeleccionada? _materiaSeleccionada;

  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _porcentajeController = TextEditingController();
  final TextEditingController _notaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.calificacionEdit != null) {
      final c = widget.calificacionEdit!;
      _tituloController.text = c.titulo;
      _notaController.text = c.nota;
      _porcentajeController.text = c.valorPorcentual > 0
          ? c.valorPorcentual.toString()
          : '';
      _tipoEvaluacion = c.tipoEvaluacion;
      _fechaSeleccionada = c.fecha;
      _materiaSeleccionada = MateriaSeleccionada()
        ..materiaId = c.materiaId
        ..materiaNombre = c.nombreMateria;
    } else {
      _fechaSeleccionada = DateTime.now();
    }
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _porcentajeController.dispose();
    _notaController.dispose();
    super.dispose();
  }

  void _seleccionarFecha() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _fechaSeleccionada ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _fechaSeleccionada) {
      setState(() {
        _fechaSeleccionada = picked;
      });
    }
  }

  void _seleccionarMateria() {
    final provider = context.read<HorarioProvider>();
    final materias = provider.horario?.materiasSeleccionadas ?? [];

    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        if (materias.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(32.0),
            child: Text('No hay asignaturas en tu horario.'),
          );
        }
        return ListView.builder(
          itemCount: materias.length,
          itemBuilder: (ctx, i) {
            final mat = materias[i];
            return ListTile(
              leading: const Icon(Icons.school_outlined),
              title: Text(mat.materiaNombre ?? 'Sin nombre'),
              onTap: () {
                setState(() {
                  _materiaSeleccionada = mat;
                });
                Navigator.pop(ctx);
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String fechaTexto = _fechaSeleccionada != null
        ? '${_fechaSeleccionada!.day}/${_fechaSeleccionada!.month}/${_fechaSeleccionada!.year}'
        : 'Seleccionar fecha';

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (_materiaSeleccionada == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Debes seleccionar una asignatura'),
                  ),
                );
                return;
              }
              final valPorcentual =
                  double.tryParse(_porcentajeController.text) ?? 0.0;
              final titulo = _tituloController.text.trim().isEmpty
                  ? 'Sin título'
                  : _tituloController.text.trim();

              final nuevaCalificacion = Calificacion(
                id:
                    widget.calificacionEdit?.id ??
                    DateTime.now().microsecondsSinceEpoch.toString(),
                titulo: titulo,
                materiaId: _materiaSeleccionada!.materiaId ?? 'unknown',
                nombreMateria:
                    _materiaSeleccionada!.materiaNombre ?? 'Sin Nombre',
                fecha: _fechaSeleccionada ?? DateTime.now(),
                tipoEvaluacion: _tipoEvaluacion,
                valorPorcentual: valPorcentual,
                nota: _notaController.text.trim(),
                sistemaCalificacion:
                    widget.calificacionEdit?.sistemaCalificacion ??
                    'Predeterminado',
              );

              if (widget.calificacionEdit == null) {
                context.read<CalificacionesProvider>().agregarCalificacion(
                  nuevaCalificacion,
                );
              } else {
                context.read<CalificacionesProvider>().actualizarCalificacion(
                  nuevaCalificacion,
                );
              }

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Calificación guardada')),
              );
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.primary,
            ),
            child: const Text('Guardar'),
          ),
          PopupMenuButton<String>(
            onSelected: (val) {
              if (val == 'sistema') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SistemasCalificacionScreen(),
                  ),
                );
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'sistema',
                child: Text('Sistema de puntuación'),
              ),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildInputTile(
            Icons.emoji_events_outlined,
            'Agregar clasificación',
            controller: _tituloController,
          ),
          _buildOpcionGuardar(
            Icons.school_outlined,
            _materiaSeleccionada?.materiaNombre ?? 'Seleccionar una materia',
            onTap: _seleccionarMateria,
          ),
          const SizedBox(height: 16),
          _buildOpcionGuardar(
            Icons.calendar_today_outlined,
            fechaTexto,
            onTap: _seleccionarFecha,
          ),
          _buildOpcionGuardar(
            Icons.local_offer_outlined,
            _tipoEvaluacion,
            onTap: () => _mostrarDialogoTipoEvaluacion(context),
          ),
          const SizedBox(height: 16),
          _buildInputTile(
            Icons.scale_outlined,
            'Valor porcentual',
            controller: _porcentajeController,
            isNumeric: true,
            suffixText: '%',
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.surfaceVariant.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            height: 150,
            child: TextField(
              controller: _notaController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Descripción (opcional)',
              ),
              maxLines: null,
            ),
          ),
          if (widget.calificacionEdit != null) ...[
            const SizedBox(height: 32),
            TextButton.icon(
              onPressed: () {
                context.read<CalificacionesProvider>().eliminarCalificacion(
                  widget.calificacionEdit!.id,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Calificación eliminada')),
                );
                Navigator.pop(context);
                Navigator.pop(context);
              },
              icon: const Icon(Icons.delete_outline),
              label: const Text('Eliminar calificación'),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _mostrarDialogoTipoEvaluacion(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Tipo de evaluación'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Escrito'),
                onTap: () {
                  setState(() => _tipoEvaluacion = 'Escrito');
                  Navigator.pop(ctx);
                },
              ),
              ListTile(
                title: const Text('Oral'),
                onTap: () {
                  setState(() => _tipoEvaluacion = 'Oral');
                  Navigator.pop(ctx);
                },
              ),
              ListTile(
                title: const Text('Práctico'),
                onTap: () {
                  setState(() => _tipoEvaluacion = 'Práctico');
                  Navigator.pop(ctx);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInputTile(
    IconData icon,
    String hint, {
    required TextEditingController controller,
    bool isNumeric = false,
    IconData? iconEnd,
    String? suffixText,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      margin: const EdgeInsets.only(bottom: 2),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.onSurfaceVariant),
          const SizedBox(width: 16),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: isNumeric
                  ? TextInputType.number
                  : TextInputType.text,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hint,
                suffixText: suffixText,
              ),
            ),
          ),
          if (iconEnd != null)
            Icon(iconEnd, color: Theme.of(context).colorScheme.primary),
        ],
      ),
    );
  }

  Widget _buildOpcionGuardar(
    IconData icon,
    String title, {
    IconData? iconEnd,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        margin: const EdgeInsets.only(bottom: 2),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
        ),
        child: Row(
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.onSurfaceVariant),
            const SizedBox(width: 16),
            Expanded(child: Text(title, style: const TextStyle(fontSize: 16))),
            if (iconEnd != null)
              Icon(iconEnd, color: Theme.of(context).colorScheme.primary),
          ],
        ),
      ),
    );
  }
}
