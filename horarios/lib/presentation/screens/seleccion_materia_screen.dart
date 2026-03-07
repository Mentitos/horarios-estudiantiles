import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/materia.dart';
import '../../providers/horario_provider.dart';
import '../../providers/materias_provider.dart';
import '../../providers/perfil_provider.dart';

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
}
