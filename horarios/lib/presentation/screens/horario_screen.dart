import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/horario_usuario.dart';
import '../../providers/horario_provider.dart';
import 'seleccion_carrera_screen.dart';
import 'vista_previa_grilla_screen.dart';

class HorarioScreen extends StatelessWidget {
  const HorarioScreen({super.key});

  Future<void> _mostrarBottomSheetBloques(
    BuildContext context,
    MateriaSeleccionada materia,
  ) async {
    final horarioProvider = context.read<HorarioProvider>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setStateSheet) {
            final materiaActualizada = horarioProvider
                .horario
                ?.materiasSeleccionadas
                .firstWhere(
                  (m) => m.materiaId == materia.materiaId,
                  orElse: () => materia,
                );

            if (materiaActualizada == null) return const SizedBox.shrink();

            final bloques = materiaActualizada.bloques.toList();

            return DraggableScrollableSheet(
              expand: false,
              builder: (context, scrollController) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Bloques de ${materiaActualizada.materiaNombre}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      if (bloques.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text('No hay bloques configurados.'),
                        ),
                      Expanded(
                        child: ListView.builder(
                          controller: scrollController,
                          itemCount: bloques.length,
                          itemBuilder: (context, index) {
                            final b = bloques[index];
                            return ListTile(
                              title: Text(
                                '${b.dia} de ${b.horaInicio} a ${b.horaFin}',
                              ),
                              subtitle: Text(
                                b.aula?.isNotEmpty == true
                                    ? 'Aula: ${b.aula}'
                                    : 'Sin aula',
                              ),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () async {
                                  try {
                                    await horarioProvider.eliminarBloque(
                                      materiaActualizada.materiaId!,
                                      index,
                                    );
                                    setStateSheet(() {});
                                  } catch (e) {
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(content: Text(e.toString())),
                                      );
                                    }
                                  }
                                },
                              ),
                            );
                          },
                        ),
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.add),
                        label: const Text('Agregar bloque'),
                        onPressed: () async {
                          await _mostrarDialogoLrBloque(
                            context,
                            materiaActualizada.materiaId!,
                          );
                          setStateSheet(() {});
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Future<void> _mostrarDialogoLrBloque(
    BuildContext context,
    String materiaId,
  ) async {
    String diaSeleccionado = 'Lunes';
    final TextEditingController inicioCtrl = TextEditingController(
      text: '08:00',
    );
    final TextEditingController finCtrl = TextEditingController(text: '10:00');
    final TextEditingController aulaCtrl = TextEditingController();

    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text('Nuevo Bloque'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<String>(
                      value: diaSeleccionado,
                      items:
                          [
                                'Lunes',
                                'Martes',
                                'Miércoles',
                                'Jueves',
                                'Viernes',
                                'Sábado',
                              ]
                              .map(
                                (d) =>
                                    DropdownMenuItem(value: d, child: Text(d)),
                              )
                              .toList(),
                      onChanged: (val) {
                        if (val != null)
                          setStateDialog(() => diaSeleccionado = val);
                      },
                      decoration: const InputDecoration(labelText: 'Día'),
                    ),
                    TextField(
                      controller: inicioCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Hora Inicio (HH:mm)',
                      ),
                    ),
                    TextField(
                      controller: finCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Hora Fin (HH:mm)',
                      ),
                    ),
                    TextField(
                      controller: aulaCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Aula (opcional)',
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final regExp = RegExp(r'^([01]\d|2[0-3]):?([0-5]\d)$');
                    if (!regExp.hasMatch(inicioCtrl.text) ||
                        !regExp.hasMatch(finCtrl.text)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Formato de hora inválido. Usa HH:mm'),
                        ),
                      );
                      return;
                    }

                    final horarioProvider = context.read<HorarioProvider>();
                    final nuevoBloque = BloqueHorario()
                      ..dia = diaSeleccionado
                      ..horaInicio = inicioCtrl.text
                      ..horaFin = finCtrl.text
                      ..aula = aulaCtrl.text;

                    try {
                      await horarioProvider.agregarBloque(
                        materiaId,
                        nuevoBloque,
                      );
                      if (context.mounted) Navigator.of(context).pop();
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(e.toString())));
                      }
                    }
                  },
                  child: const Text('Guardar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Horario'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          Consumer<HorarioProvider>(
            builder: (context, provider, child) {
              final tieneMaterias =
                  (provider.horario?.materiasSeleccionadas.isNotEmpty) ?? false;
              if (!tieneMaterias) return const SizedBox.shrink();

              return IconButton(
                icon: const Icon(Icons.grid_on),
                tooltip: 'Ver grilla horaria',
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const VistaPreviaGrillaScreen(),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Consumer<HorarioProvider>(
        builder: (context, provider, child) {
          if (provider.cargando) {
            return const Center(child: CircularProgressIndicator());
          }
          final horario = provider.horario;
          if (horario == null || horario.materiasSeleccionadas.isEmpty) {
            return const Center(
              child: Text(
                'Agregá materias con el botón +',
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return ListView.builder(
            itemCount: horario.materiasSeleccionadas.length,
            itemBuilder: (context, index) {
              final materia = horario.materiasSeleccionadas[index];
              final color = Color(materia.colorARGB ?? 0xFF000000);

              return Dismissible(
                key: Key(materia.materiaId!),
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                direction: DismissDirection.endToStart,
                onDismissed: (_) {
                  provider.eliminarMateria(materia.materiaId!);
                },
                child: ListTile(
                  leading: CircleAvatar(backgroundColor: color),
                  title: Text(materia.materiaNombre ?? ''),
                  subtitle: Text(
                    '${materia.bloques.length} bloques configurados',
                  ),
                  onTap: () => _mostrarBottomSheetBloques(context, materia),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const SeleccionCarreraScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
