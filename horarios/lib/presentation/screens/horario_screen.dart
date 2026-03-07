import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/horario_usuario.dart';
import '../../providers/horario_provider.dart';
import '../../providers/perfil_provider.dart';
import 'seleccion_carrera_screen.dart';
import 'seleccion_materia_screen.dart';
import '../widgets/grilla_semanal.dart';

class HorarioScreen extends StatelessWidget {
  final bool mostrarSabado;
  final bool mostrarDomingo;

  const HorarioScreen({
    super.key,
    this.mostrarSabado = false,
    this.mostrarDomingo = false,
  });

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
                      initialValue: diaSeleccionado,
                      items:
                          [
                                'Lunes',
                                'Martes',
                                'Miércoles',
                                'Jueves',
                                'Viernes',
                                'Sábado',
                                'Domingo',
                              ]
                              .map(
                                (d) =>
                                    DropdownMenuItem(value: d, child: Text(d)),
                              )
                              .toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setStateDialog(() => diaSeleccionado = val);
                        }
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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 0,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Gestor de Clases'),
              Tab(text: 'Calendario Semanal'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildGestorDeClases(context),
            _buildCalendarioSemanal(context),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () => _iniciarFlujoAgregarMateria(context),
        ),
      ),
    );
  }

  Widget _buildGestorDeClases(BuildContext context) {
    return Consumer<HorarioProvider>(
      builder: (context, provider, child) {
        if (provider.cargando) {
          return const Center(child: CircularProgressIndicator());
        }
        final horario = provider.horario;
        if (horario == null || horario.materiasSeleccionadas.isEmpty) {
          return const Center(
            child: Text(
              'Tocá el + para configurar tus materias',
              style: TextStyle(fontSize: 18),
            ),
          );
        }

        final materias = horario.materiasSeleccionadas;
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: materias.length,
          itemBuilder: (context, index) {
            final materia = materias[index];
            final color = Color(materia.colorARGB ?? 0xFF000000);
            final textColor = color.computeLuminance() > 0.5
                ? Colors.black
                : Colors.white;

            return Card(
              color: color,
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      materia.materiaNombre ?? 'Materia',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (materia.bloques.isEmpty)
                      Text(
                        'Sin horarios configurados',
                        style: TextStyle(
                          color: textColor.withOpacity(0.8),
                          fontStyle: FontStyle.italic,
                        ),
                      )
                    else
                      ...materia.bloques.map((b) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Text(
                            '${b.dia} ${b.horaInicio} - ${b.horaFin}${b.aula?.isNotEmpty == true ? ' • Aula ${b.aula}' : ''}',
                            style: TextStyle(color: textColor, fontSize: 16),
                          ),
                        );
                      }),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _buildActionButton(
                          icon: Icons.edit,
                          label: 'Editar',
                          textColor: textColor,
                          onPressed: () =>
                              _mostrarBottomSheetBloques(context, materia),
                        ),
                        const SizedBox(width: 8),
                        _buildActionButton(
                          icon: Icons.delete,
                          label: 'Eliminar',
                          textColor: textColor,
                          onPressed: () =>
                              provider.eliminarMateria(materia.materiaId!),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color textColor,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: Colors.white),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarioSemanal(BuildContext context) {
    return Consumer<HorarioProvider>(
      builder: (context, provider, child) {
        if (provider.cargando) {
          return const Center(child: CircularProgressIndicator());
        }
        final horario = provider.horario;
        if (horario == null || horario.materiasSeleccionadas.isEmpty) {
          return const Center(
            child: Text(
              'Aún no hay materias para mostrar',
              style: TextStyle(fontSize: 18),
            ),
          );
        }
        return GrillaSemanal(
          horario: horario,
          mostrarSabado: mostrarSabado,
          mostrarDomingo: mostrarDomingo,
        );
      },
    );
  }

  void _iniciarFlujoAgregarMateria(BuildContext context) {
    final perfilProvider = context.read<PerfilProvider>();
    final carreras = perfilProvider.carrerasSeleccionadas;

    if (carreras.isEmpty) {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const SeleccionCarreraScreen()));
    } else if (carreras.length == 1) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => SeleccionMateriaScreen(nombreCarrera: carreras[0]),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Seleccionar carrera'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: carreras
                .map(
                  (c) => ListTile(
                    title: Text(c),
                    onTap: () {
                      Navigator.pop(ctx);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              SeleccionMateriaScreen(nombreCarrera: c),
                        ),
                      );
                    },
                  ),
                )
                .toList(),
          ),
        ),
      );
    }
  }
}
