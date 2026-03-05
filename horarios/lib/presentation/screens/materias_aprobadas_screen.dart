import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/materia.dart';
import '../../providers/materias_provider.dart';
import '../../providers/perfil_provider.dart';

class MateriasAprobadasScreen extends StatelessWidget {
  const MateriasAprobadasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final perfilProvider = context.watch<PerfilProvider>();
    final carreras = perfilProvider.carrerasSeleccionadas;

    if (carreras.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Materias aprobadas')),
        body: const Center(
          child: Text('Debes seleccionar una carrera en Ajustes primero.'),
        ),
      );
    }

    if (carreras.length == 1) {
      return Scaffold(
        appBar: AppBar(title: const Text('Materias aprobadas')),
        body: _ListaMateriasAprobadas(nombreCarrera: carreras[0]),
      );
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Materias aprobadas'),
          bottom: TabBar(
            tabs: [
              Tab(text: carreras[0]),
              Tab(text: carreras[1]),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _ListaMateriasAprobadas(nombreCarrera: carreras[0]),
            _ListaMateriasAprobadas(nombreCarrera: carreras[1]),
          ],
        ),
      ),
    );
  }
}

class _ListaMateriasAprobadas extends StatefulWidget {
  final String nombreCarrera;
  const _ListaMateriasAprobadas({required this.nombreCarrera});

  @override
  State<_ListaMateriasAprobadas> createState() =>
      _ListaMateriasAprobadasState();
}

class _ListaMateriasAprobadasState extends State<_ListaMateriasAprobadas> {
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
    return FutureBuilder<List<dynamic>>(
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
        final perfilProvider = context.watch<PerfilProvider>();

        return ListView.builder(
          itemCount: materias.length,
          itemBuilder: (context, index) {
            final item = materias[index];

            if (item is Materia) {
              final aprobada = perfilProvider.estaAprobada(item.materiaId!);

              return ListTile(
                title: Text(
                  item.nombre ?? '',
                  style: TextStyle(
                    decoration: aprobada ? TextDecoration.lineThrough : null,
                    color: aprobada ? Colors.grey : null,
                  ),
                ),
                trailing: Checkbox(
                  value: aprobada,
                  onChanged: (val) async {
                    if (val != null) {
                      await perfilProvider.toggleMateriaAprobada(
                        item.materiaId!,
                      );
                    }
                  },
                ),
              );
            } else if (item is List<Materia>) {
              final materiaSel =
                  _opcionSeleccionadaCompuesta[index] ?? item.first;

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
                trailing: Checkbox(
                  value: algunaAprobada,
                  onChanged: (val) async {
                    if (val != null) {
                      if (!algunaAprobada) {
                        await perfilProvider.toggleMateriaAprobada(
                          materiaSel.materiaId!,
                        );
                      } else {
                        for (var m in item) {
                          if (perfilProvider.estaAprobada(m.materiaId!)) {
                            await perfilProvider.toggleMateriaAprobada(
                              m.materiaId!,
                            );
                          }
                        }
                      }
                    }
                  },
                ),
              );
            }
            return const SizedBox.shrink();
          },
        );
      },
    );
  }
}
