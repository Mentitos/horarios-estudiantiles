import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../providers/perfil_provider.dart';
import '../../providers/horario_provider.dart';
import '../../data/sources/local_datasource.dart';
import '../../data/models/materia_custom.dart';
import '../../data/models/materia.dart';

class GestionarMateriasLocalesScreen extends StatefulWidget {
  const GestionarMateriasLocalesScreen({super.key});

  @override
  State<GestionarMateriasLocalesScreen> createState() =>
      _GestionarMateriasLocalesScreenState();
}

class _GestionarMateriasLocalesScreenState
    extends State<GestionarMateriasLocalesScreen> {
  final LocalDatasource _localDatasource = LocalDatasource();
  String? _carreraSeleccionada;
  final List<Materia> _materiasOriginales = [];
  List<MateriaCustom> _materiasCustom = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarDatosIniciales();
  }

  Future<void> _cargarDatosIniciales() async {
    final perfilProvider = context.read<PerfilProvider>();
    if (perfilProvider.carrerasSeleccionadas.isNotEmpty) {
      _carreraSeleccionada = perfilProvider.carrerasSeleccionadas.first;
    }
    await _cargarMaterias();
  }

  Future<void> _cargarMaterias() async {
    if (_carreraSeleccionada == null) {
      setState(() => _cargando = false);
      return;
    }

    setState(() => _cargando = true);

    try {
      final carrera = await _localDatasource.leerCarreraPorNombre(
        _carreraSeleccionada!,
      );
      _materiasCustom = await _localDatasource.leerMateriasCustom();

      _materiasOriginales.clear();

      if (carrera != null) {
        for (String idCompuesto in carrera.materiasIds) {
          if (idCompuesto.contains(':')) {
            final partes = idCompuesto.split(':');
            for (String p in partes) {
              final m = await _localDatasource.leerMateriaPorId(p);
              if (m != null) _materiasOriginales.add(m);
            }
          } else {
            final m = await _localDatasource.leerMateriaPorId(idCompuesto);
            if (m != null) _materiasOriginales.add(m);
          }
        }
      }

      setState(() {});
    } catch (e) {
      debugPrint('Error cargando materias: $e');
    } finally {
      setState(() => _cargando = false);
    }
  }

  List<dynamic> get _materiasCombinadas {
    List<dynamic> combinadas = [];

    for (var original in _materiasOriginales) {
      final custom = _materiasCustom
          .where((c) => c.materiaId == original.materiaId)
          .firstOrNull;

      if (custom?.estaOculta == true) continue;

      final nombreAMostrar = (custom?.nombrePersonalizado?.isNotEmpty ?? false)
          ? custom!.nombrePersonalizado!
          : (original.nombre ?? 'Sin Nombre');

      combinadas.add({
        'id': original.materiaId,
        'nombre': nombreAMostrar,
        'esOriginal': true,
        'custom': custom,
      });
    }

    final purasLocales = _materiasCustom.where(
      (c) =>
          c.esAgregadaLocalmente && c.carreraAsociada == _carreraSeleccionada,
    );

    for (var custom in purasLocales) {
      combinadas.add({
        'id': custom.materiaId,
        'nombre': custom.nombrePersonalizado ?? 'Sin Nombre',
        'esOriginal': false,
        'custom': custom,
      });
    }

    combinadas.sort(
      (a, b) => (a['nombre'] as String).compareTo(b['nombre'] as String),
    );

    return combinadas;
  }

  Future<void> _agregarMateriaLocal() async {
    final controller = TextEditingController();

    final nombre = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Nueva Materia'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Nombre de la materia',
            hintText: 'Ej: Taller de Tesis',
          ),
          textCapitalization: TextCapitalization.words,
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(null),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(controller.text.trim()),
            child: const Text('Agregar'),
          ),
        ],
      ),
    );

    if (nombre != null && nombre.isNotEmpty) {
      final nuevaCustom = MateriaCustom()
        ..materiaId = const Uuid().v4()
        ..nombrePersonalizado = nombre
        ..esAgregadaLocalmente = true
        ..carreraAsociada = _carreraSeleccionada;

      await _localDatasource.guardarMateriaCustom(nuevaCustom);
      await _cargarMaterias();
    }
  }

  Future<void> _editarNombreMateria(Map<String, dynamic> item) async {
    final controller = TextEditingController(text: item['nombre']);

    final nuevoNombre = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Renombrar Materia'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Nuevo nombre'),
          textCapitalization: TextCapitalization.words,
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(null),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(controller.text.trim()),
            child: const Text('Guardar'),
          ),
        ],
      ),
    );

    if (nuevoNombre != null &&
        nuevoNombre.isNotEmpty &&
        nuevoNombre != item['nombre']) {
      MateriaCustom customParaGuardar;

      if (item['custom'] != null) {
        customParaGuardar = item['custom'] as MateriaCustom;
        customParaGuardar.nombrePersonalizado = nuevoNombre;
      } else {
        customParaGuardar = MateriaCustom()
          ..materiaId = item['id']
          ..nombrePersonalizado = nuevoNombre
          ..carreraAsociada = _carreraSeleccionada;
      }

      await _localDatasource.guardarMateriaCustom(customParaGuardar);

      if (mounted) {
        final horarioProvider = context.read<HorarioProvider>();
        final horario = horarioProvider.horario;
        if (horario != null) {
          final matSel = horario.materiasSeleccionadas
              .where((m) => m.materiaId == item['id'])
              .firstOrNull;
          if (matSel != null) {
            horarioProvider.actualizarMateria(
              matSel.materiaId!,
              nuevoNombre,
              matSel.profesores,
              matSel.aula ?? '',
              matSel.colorARGB ?? 0,
            );
          }
        }
      }

      await _cargarMaterias();
    }
  }

  Future<void> _ocultarOEliminarMateria(Map<String, dynamic> item) async {
    final bool esOriginal = item['esOriginal'];

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(esOriginal ? '¿Ocultar Materia?' : '¿Eliminar Materia?'),
        content: Text(
          esOriginal
              ? 'Esta es una materia oficial de tu carrera. Ya no la verás en tus listas. (Podrás restaurarla luego al "Actualizar JSON" en Ajustes).'
              : 'Esta materia fue creada por vos. Se eliminará permanentemente.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(esOriginal ? 'Ocultar' : 'Eliminar'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      if (esOriginal) {
        MateriaCustom customParaGuardar;
        if (item['custom'] != null) {
          customParaGuardar = item['custom'] as MateriaCustom;
          customParaGuardar.estaOculta = true;
        } else {
          customParaGuardar = MateriaCustom()
            ..materiaId = item['id']
            ..estaOculta = true
            ..carreraAsociada = _carreraSeleccionada;
        }
        await _localDatasource.guardarMateriaCustom(customParaGuardar);
      } else {
        await _localDatasource.eliminarMateriaCustom(item['id']);
      }

      if (mounted) {
        final horarioProvider = context.read<HorarioProvider>();
        await horarioProvider.eliminarMateria(item['id']);
      }

      await _cargarMaterias();
    }
  }

  @override
  Widget build(BuildContext context) {
    final perfilProvider = context.watch<PerfilProvider>();
    final carreras = perfilProvider.carrerasSeleccionadas;

    return Scaffold(
      appBar: AppBar(title: const Text('Gestionar Materias')),
      body: carreras.isEmpty
          ? const Center(child: Text('No has seleccionado ninguna carrera.'))
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (carreras.length > 1)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SegmentedButton<String>(
                      segments: carreras
                          .map((c) => ButtonSegment(value: c, label: Text(c)))
                          .toList(),
                      selected: {_carreraSeleccionada ?? carreras.first},
                      onSelectionChanged: (Set<String> newSelection) {
                        setState(() {
                          _carreraSeleccionada = newSelection.first;
                        });
                        _cargarMaterias();
                      },
                    ),
                  ),

                if (carreras.length == 1)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: Text(
                      'Materias de ${carreras.first}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                Expanded(
                  child: _cargando
                      ? const Center(child: CircularProgressIndicator())
                      : _materiasCombinadas.isEmpty
                      ? const Center(child: Text('No hay materias.'))
                      : ListView.builder(
                          itemCount: _materiasCombinadas.length,
                          itemBuilder: (context, index) {
                            final item = _materiasCombinadas[index];

                            return ListTile(
                              title: Text(item['nombre']),
                              subtitle: !item['esOriginal']
                                  ? const Text(
                                      'Agregada por vos',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.green,
                                      ),
                                    )
                                  : ((item['custom'] != null &&
                                            item['custom']!
                                                    .nombrePersonalizado !=
                                                null)
                                        ? const Text(
                                            'Nombre editado',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.blueAccent,
                                            ),
                                          )
                                        : null),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit, size: 20),
                                    onPressed: () => _editarNombreMateria(item),
                                    tooltip: 'Renombrar',
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      item['esOriginal']
                                          ? Icons.visibility_off
                                          : Icons.delete,
                                      size: 20,
                                      color: Colors.redAccent,
                                    ),
                                    onPressed: () =>
                                        _ocultarOEliminarMateria(item),
                                    tooltip: item['esOriginal']
                                        ? 'Ocultar'
                                        : 'Eliminar',
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
      floatingActionButton: _carreraSeleccionada == null
          ? null
          : FloatingActionButton.extended(
              onPressed: _agregarMateriaLocal,
              icon: const Icon(Icons.add),
              label: const Text('Nueva Materia'),
            ),
    );
  }
}
