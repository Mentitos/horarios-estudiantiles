import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/materia.dart';
import '../../providers/horario_provider.dart';
import '../../providers/materias_provider.dart';
import '../../providers/perfil_provider.dart';
import '../../data/models/materia_custom.dart';
import '../../data/sources/local_datasource.dart';
import 'package:uuid/uuid.dart';

//   Ojala algun dia la gente se de cuenta de que muchas cosas no tienen sentido mantenerlas
class SeleccionMateriaScreen extends StatefulWidget {
  final String nombreCarrera;

  const SeleccionMateriaScreen({super.key, required this.nombreCarrera});

  @override
  State<SeleccionMateriaScreen> createState() => _SeleccionMateriaScreenState();
}

class _SeleccionMateriaScreenState extends State<SeleccionMateriaScreen> {
  late Future<List<dynamic>> _futureMaterias;
  final Map<int, Materia> _opcionSeleccionadaCompuesta = {};

  @override
  void initState() {
    super.initState();
    _futureMaterias = context.read<MateriasProvider>().getMateriasDeCarrera(
      widget.nombreCarrera,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.nombreCarrera),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _agregarMateriaLocal,
        icon: const Icon(Icons.add),
        label: const Text('Crear Materia'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _futureMaterias,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No se encontraron materias'));
          }

          final materias = snapshot.data!;
          final horarioProvider = context.watch<HorarioProvider>();
          final perfilProvider = context.watch<PerfilProvider>();

          return ListView.builder(
            itemCount: materias.length,
            itemBuilder: (context, index) {
              final item = materias[index];

              if (item is Materia) {
                final estaSeleccionada = horarioProvider.tieneLaMateria(
                  item.materiaId!,
                );
                final aprobada = perfilProvider.estaAprobada(item.materiaId!);

                return ListTile(
                  title: Text(
                    item.nombre ?? '',
                    style: TextStyle(
                      decoration: aprobada ? TextDecoration.lineThrough : null,
                      color: aprobada ? Colors.grey : null,
                    ),
                  ),
                  subtitle: aprobada
                      ? const Text(
                          'Ya aprobada',
                          style: TextStyle(color: Colors.grey),
                        )
                      : null,
                  trailing: Checkbox(
                    value: estaSeleccionada,
                    onChanged: aprobada
                        ? null
                        : (val) async {
                            if (val == true) {
                              try {
                                await horarioProvider.agregarMateria(item);
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(e.toString())),
                                  );
                                }
                              }
                            } else {
                              await horarioProvider.eliminarMateria(
                                item.materiaId!,
                              );
                            }
                          },
                  ),
                );
              } else if (item is List<Materia>) {
                final materiaSel =
                    _opcionSeleccionadaCompuesta[index] ?? item.first;

                final estaSeleccionada = horarioProvider.tieneLaMateria(
                  materiaSel.materiaId!,
                );

                bool algunaAprobada = false;
                for (var m in item) {
                  if (perfilProvider.estaAprobada(m.materiaId!)) {
                    algunaAprobada = true;
                    break;
                  }
                }

                return ListTile(
                  title: DropdownButton<Materia>(
                    isExpanded: true,
                    value: materiaSel,
                    style: TextStyle(
                      fontSize: 16,
                      decoration: algunaAprobada
                          ? TextDecoration.lineThrough
                          : null,
                      color: algunaAprobada
                          ? Colors.grey
                          : Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                    items: item.map((Materia m) {
                      return DropdownMenuItem<Materia>(
                        value: m,
                        child: Text(
                          m.nombre ?? '',
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    onChanged: algunaAprobada
                        ? null
                        : (val) {
                            if (val != null) {
                              setState(() {
                                _opcionSeleccionadaCompuesta[index] = val;
                              });
                            }
                          },
                  ),
                  subtitle: algunaAprobada
                      ? const Text(
                          'Ya aprobada',
                          style: TextStyle(color: Colors.grey),
                        )
                      : null,
                  trailing: Checkbox(
                    value: estaSeleccionada,
                    onChanged: algunaAprobada
                        ? null
                        : (val) async {
                            if (val == true) {
                              try {
                                await horarioProvider.agregarMateria(
                                  materiaSel,
                                );
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(e.toString())),
                                  );
                                }
                              }
                            } else {
                              await horarioProvider.eliminarMateria(
                                materiaSel.materiaId!,
                              );
                            }
                          },
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          );
        },
      ),
    );
  }

  Future<void> _agregarMateriaLocal() async {
    final controller = TextEditingController();

    final nombre = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Crear Materia Personalizada'),
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
            child: const Text('Crear'),
          ),
        ],
      ),
    );

    if (nombre != null && nombre.isNotEmpty) {
      final nuevaCustom = MateriaCustom()
        ..materiaId = const Uuid().v4()
        ..nombrePersonalizado = nombre
        ..esAgregadaLocalmente = true
        ..carreraAsociada = widget.nombreCarrera;

      await LocalDatasource().guardarMateriaCustom(nuevaCustom);
      setState(() {
        _futureMaterias = context.read<MateriasProvider>().getMateriasDeCarrera(
          widget.nombreCarrera,
        );
      });
    }
  }
}
