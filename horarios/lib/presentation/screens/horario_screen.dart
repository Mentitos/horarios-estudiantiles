import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/horario_usuario.dart';
import '../../providers/horario_provider.dart';
import '../../providers/perfil_provider.dart';
import 'seleccion_carrera_screen.dart';
import 'seleccion_materia_screen.dart';
import '../widgets/grilla_semanal.dart';
import '../../providers/materias_provider.dart';
import '../../providers/profesores_provider.dart';
import '../../data/models/materia.dart';
import '../../data/models/profesor.dart';
import 'package:uuid/uuid.dart';
import '../widgets/color_picker_hsv.dart';

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
    final materiasProvider = context.read<MateriasProvider>();
    final perfilProvider = context.read<PerfilProvider>();
    final profesoresProvider = context.read<ProfesoresProvider>();

    String? nombre = materia.materiaNombre;
    List<String> listaProfesores = List.from(materia.profesores);
    if (listaProfesores.isEmpty) listaProfesores.add('');
    String? aula = materia.aula;
    int colorElegido = materia.colorARGB ?? 0xFF000000;

    List<Materia> materiasDisponibles = [];
    for (String carrera in perfilProvider.carrerasSeleccionadas) {
      final mats = await materiasProvider.getMateriasDeCarrera(carrera);
      for (var m in mats) {
        if (m is Materia) {
          if (!perfilProvider.estaAprobada(m.materiaId ?? '')) {
            materiasDisponibles.add(m);
          }
        } else if (m is List<Materia>) {
          for (var subM in m) {
            if (!perfilProvider.estaAprobada(subM.materiaId ?? '')) {
              materiasDisponibles.add(subM);
            }
          }
        }
      }
    }
    final seenIds = <String>{};
    materiasDisponibles = materiasDisponibles
        .where((m) => seenIds.add(m.materiaId ?? ''))
        .toList();
    materiasDisponibles.sort(
      (a, b) => (a.nombre ?? '').compareTo(b.nombre ?? ''),
    );

    final coloresDisponibles = [
      0xFFE53935, // Rojo
      0xFFD81B60, // Rosa
      0xFF8E24AA, // Morado
      0xFF5E35B1, // Índigo
      0xFF3949AB, // Azul oscuro
      0xFF1E88E5, // Azul
      0xFF039BE5, // Celeste
      0xFF00ACC1, // Cian
      0xFF00897B, // Teal
      0xFF43A047, // Verde
      0xFF7CB342, // Verde claro
      0xFFF4511E, // Naranja oscuro
      0xFF6D4C41, // Marrón
      0xFF546E7A, // Azul grisáceo
      0xFF000000, // Negro default
    ];

    if (!context.mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
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
            final profesores = profesoresProvider.profesores;

            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 16,
                right: 16,
                top: 16,
              ),
              child: DraggableScrollableSheet(
                initialChildSize: 0.9,
                minChildSize: 0.5,
                maxChildSize: 1.0,
                expand: false,
                builder: (context, scrollController) {
                  return ListView(
                    controller: scrollController,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Editar Clase',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value:
                            materiasDisponibles.any((m) => m.nombre == nombre)
                            ? nombre
                            : null,
                        isExpanded: true,
                        decoration: const InputDecoration(
                          labelText: 'Materia',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.class_),
                        ),
                        items: materiasDisponibles.map((m) {
                          return DropdownMenuItem<String>(
                            value: m.nombre,
                            child: Text(
                              m.nombre ?? '',
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            nombre = val;
                            horarioProvider.actualizarMateria(
                              materiaActualizada.materiaId!,
                              nombre!,
                              listaProfesores,
                              aula,
                              colorElegido,
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      ...listaProfesores.asMap().entries.map((entry) {
                        int idx = entry.key;
                        String valProf = entry.value;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            children: [
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  value:
                                      profesores.any(
                                        (p) => p.nombreCompleto == valProf,
                                      )
                                      ? valProf
                                      : null,
                                  isExpanded: true,
                                  decoration: InputDecoration(
                                    labelText: listaProfesores.length > 1
                                        ? 'Profesor ${idx + 1}'
                                        : 'Profesor',
                                    border: const OutlineInputBorder(),
                                    prefixIcon: const Icon(Icons.person),
                                    suffixIcon: IconButton(
                                      icon: const Icon(
                                        Icons.add_circle_outline,
                                      ),
                                      onPressed: () async {
                                        final nuevoNombre =
                                            await _mostrarDialogoNuevoProfesor(
                                              context,
                                            );
                                        if (nuevoNombre != null) {
                                          setStateSheet(() {
                                            listaProfesores[idx] = nuevoNombre;
                                          });
                                          horarioProvider.actualizarMateria(
                                            materiaActualizada.materiaId!,
                                            nombre!,
                                            listaProfesores,
                                            aula,
                                            colorElegido,
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                  items: profesores.map((p) {
                                    return DropdownMenuItem<String>(
                                      value: p.nombreCompleto,
                                      child: Text(
                                        p.nombreCompleto,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (val) {
                                    if (val != null) {
                                      setStateSheet(() {
                                        listaProfesores[idx] = val;
                                      });
                                      horarioProvider.actualizarMateria(
                                        materiaActualizada.materiaId!,
                                        nombre!,
                                        listaProfesores,
                                        aula,
                                        colorElegido,
                                      );
                                    }
                                  },
                                ),
                              ),
                              if (listaProfesores.length > 1)
                                IconButton(
                                  icon: const Icon(
                                    Icons.remove_circle_outline,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    setStateSheet(() {
                                      listaProfesores.removeAt(idx);
                                    });
                                    horarioProvider.actualizarMateria(
                                      materiaActualizada.materiaId!,
                                      nombre!,
                                      listaProfesores,
                                      aula,
                                      colorElegido,
                                    );
                                  },
                                ),
                            ],
                          ),
                        );
                      }),
                      TextButton.icon(
                        onPressed: () {
                          setStateSheet(() {
                            listaProfesores.add('');
                          });
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Opcional: Añadir otro profesor'),
                      ),
                      const SizedBox(height: 4),
                      const SizedBox(height: 12),
                      TextFormField(
                        initialValue: aula,
                        decoration: const InputDecoration(
                          labelText: 'Aula General (Opcional)',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.room),
                        ),
                        onChanged: (val) {
                          aula = val;
                          horarioProvider.actualizarMateria(
                            materiaActualizada.materiaId!,
                            nombre!,
                            listaProfesores,
                            aula,
                            colorElegido,
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Color de Etiqueta',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextButton.icon(
                            onPressed: () async {
                              final hexColor = await _mostrarDialogoColorHex(
                                context,
                                Color(colorElegido),
                              );
                              if (hexColor != null) {
                                setStateSheet(() {
                                  colorElegido = hexColor;
                                });
                                horarioProvider.actualizarMateria(
                                  materiaActualizada.materiaId!,
                                  nombre!,
                                  listaProfesores,
                                  aula,
                                  colorElegido,
                                );
                              }
                            },
                            icon: const Icon(Icons.colorize, size: 16),
                            label: const Text('HEX'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 50,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          itemCount: coloresDisponibles.length,
                          itemBuilder: (ctx, i) {
                            final c = coloresDisponibles[i];
                            final isSelected = c == colorElegido;
                            return GestureDetector(
                              onTap: () {
                                setStateSheet(() {
                                  colorElegido = c;
                                });
                                horarioProvider.actualizarMateria(
                                  materiaActualizada.materiaId!,
                                  nombre!,
                                  listaProfesores,
                                  aula,
                                  colorElegido,
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 8),
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Color(c),
                                  shape: BoxShape.circle,
                                  border: isSelected
                                      ? Border.all(
                                          color: Colors.white,
                                          width: 3,
                                        )
                                      : null,
                                  boxShadow: [
                                    if (isSelected)
                                      BoxShadow(
                                        color: Color(c).withOpacity(0.5),
                                        blurRadius: 6,
                                        spreadRadius: 2,
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Divider(),
                      const SizedBox(height: 16),

                      const Text(
                        'Bloques Horarios',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (bloques.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            'No hay bloques configurados.',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                      ...List.generate(bloques.length, (index) {
                        final b = bloques[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            title: Text(
                              '${b.dia} de ${b.horaInicio} a ${b.horaFin}',
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.blue,
                                  ),
                                  onPressed: () async {
                                    await _mostrarDialogoLrBloque(
                                      context,
                                      materiaActualizada.materiaId!,
                                      indexEdit: index,
                                      bloqueOriginal: b,
                                    );
                                    setStateSheet(() {});
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () async {
                                    final confirmar = await showDialog<bool>(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: const Text('Eliminar bloque'),
                                        content: const Text(
                                          '¿Estás seguro de que deseas eliminar este bloque horario?',
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(ctx, false),
                                            child: const Text('Cancelar'),
                                          ),
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(ctx, true),
                                            child: const Text(
                                              'Eliminar',
                                              style: TextStyle(
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );

                                    if (confirmar == true) {
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
                                            SnackBar(
                                              content: Text(e.toString()),
                                            ),
                                          );
                                        }
                                      }
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.add),
                        label: const Text('Agregar bloque horario'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                        ),
                        onPressed: () async {
                          await _mostrarDialogoLrBloque(
                            context,
                            materiaActualizada.materiaId!,
                          );
                          setStateSheet(() {});
                        },
                      ),
                    ],
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _mostrarDialogoLrBloque(
    BuildContext context,
    String materiaId, {
    int? indexEdit,
    BloqueHorario? bloqueOriginal,
  }) async {
    String diaSeleccionado = bloqueOriginal?.dia ?? 'Lunes';

    TimeOfDay inicio = const TimeOfDay(hour: 8, minute: 0);
    TimeOfDay fin = const TimeOfDay(hour: 10, minute: 0);

    if (bloqueOriginal != null) {
      final partesI = bloqueOriginal.horaInicio!.split(':');
      inicio = TimeOfDay(
        hour: int.parse(partesI[0]),
        minute: int.parse(partesI[1]),
      );
      final partesF = bloqueOriginal.horaFin!.split(':');
      fin = TimeOfDay(
        hour: int.parse(partesF[0]),
        minute: int.parse(partesF[1]),
      );
    }

    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            String formatoHora(TimeOfDay time) {
              final h = time.hour.toString().padLeft(2, '0');
              final m = time.minute.toString().padLeft(2, '0');
              return '$h:$m';
            }

            return AlertDialog(
              title: Text(
                indexEdit == null
                    ? 'Nuevo Bloque Horario'
                    : 'Editar Bloque Horario',
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DropdownButtonFormField<String>(
                      value: diaSeleccionado,
                      decoration: const InputDecoration(
                        labelText: 'Día',
                        border: OutlineInputBorder(),
                      ),
                      items:
                          [
                            'Lunes',
                            'Martes',
                            'Miércoles',
                            'Jueves',
                            'Viernes',
                            'Sábado',
                            'Domingo',
                          ].map((d) {
                            return DropdownMenuItem(value: d, child: Text(d));
                          }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setStateDialog(() => diaSeleccionado = val);
                        }
                      },
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Horario',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.access_time),
                      title: Text('Desde: ${formatoHora(inicio)}'),
                      onTap: () async {
                        final picked = await showTimePicker(
                          context: context,
                          initialTime: inicio,
                        );
                        if (picked != null) {
                          setStateDialog(() {
                            inicio = picked;
                            if (indexEdit == null) {
                              int totalMinutes =
                                  (picked.hour * 60 + picked.minute + 120) %
                                  1440;
                              fin = TimeOfDay(
                                hour: totalMinutes ~/ 60,
                                minute: totalMinutes % 60,
                              );
                            }
                          });
                        }
                      },
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.access_time_filled),
                      title: Text('Hasta: ${formatoHora(fin)}'),
                      onTap: () async {
                        final picked = await showTimePicker(
                          context: context,
                          initialTime: fin,
                        );
                        if (picked != null) {
                          setStateDialog(() => fin = picked);
                        }
                      },
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
                    final horarioProvider = context.read<HorarioProvider>();
                    final nuevoBloque = BloqueHorario()
                      ..dia = diaSeleccionado
                      ..horaInicio = formatoHora(inicio)
                      ..horaFin = formatoHora(fin)
                      ..aula = bloqueOriginal?.aula ?? '';

                    try {
                      if (indexEdit == null) {
                        await horarioProvider.agregarBloque(
                          materiaId,
                          nuevoBloque,
                        );
                      } else {
                        await horarioProvider.actualizarBloque(
                          materiaId,
                          indexEdit,
                          nuevoBloque,
                        );
                      }
                      if (context.mounted) Navigator.of(context).pop();
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(e.toString())));
                      }
                    }
                  },
                  child: Text(indexEdit == null ? 'Guardar' : 'Actualizar'),
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
                    if (materia.profesores.any((p) => p.isNotEmpty)) ...[
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(
                            Icons.person,
                            size: 16,
                            color: textColor.withOpacity(0.8),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              materia.profesores
                                  .where((p) => p.isNotEmpty)
                                  .join(', '),
                              style: TextStyle(
                                color: textColor.withOpacity(0.9),
                                fontSize: 15,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (materia.aula?.isNotEmpty == true) ...[
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(
                            Icons.room,
                            size: 16,
                            color: textColor.withOpacity(0.8),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Aula General: ${materia.aula!}',
                            style: TextStyle(
                              color: textColor.withOpacity(0.9),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
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
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text('Eliminar materia'),
                                content: Text(
                                  '¿Seguro que deseas eliminar ${materia.materiaNombre} de tu horario?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx),
                                    child: const Text('Cancelar'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(ctx);
                                      provider.eliminarMateria(
                                        materia.materiaId!,
                                      );
                                    },
                                    child: const Text(
                                      'Eliminar',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
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

  Future<String?> _mostrarDialogoNuevoProfesor(BuildContext context) async {
    final TextEditingController nombreCtrl = TextEditingController();
    final TextEditingController apellidoCtrl = TextEditingController();

    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nuevo Profesor'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nombreCtrl,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: apellidoCtrl,
              decoration: const InputDecoration(labelText: 'Apellido'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nombreCtrl.text.isNotEmpty) {
                final nuevoProf = Profesor(
                  id: const Uuid().v4(),
                  nombre: nombreCtrl.text,
                  apellido: apellidoCtrl.text,
                  telefono: '',
                  correo: '',
                  direccion: '',
                  sitioWeb: '',
                );
                context.read<ProfesoresProvider>().agregarProfesor(nuevoProf);
                Navigator.pop(context, nuevoProf.nombreCompleto);
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  Future<int?> _mostrarDialogoColorHex(
    BuildContext context,
    Color colorInicial,
  ) async {
    String initialHex = colorInicial.value
        .toRadixString(16)
        .padLeft(8, '0')
        .substring(2)
        .toUpperCase();
    final TextEditingController hexCtrl = TextEditingController(
      text: '#$initialHex',
    );
    Color currentColor = colorInicial;

    return showDialog<int>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF1A1A1A),
              title: const Text(
                'Selector de Color',
                style: TextStyle(color: Colors.white),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ColorPickerHSV(
                      initialColor: currentColor,
                      onColorChanged: (color) {
                        if (context.mounted) {
                          setState(() {
                            currentColor = color;
                            String hex = color.value
                                .toRadixString(16)
                                .padLeft(8, '0')
                                .substring(2)
                                .toUpperCase();
                            hexCtrl.text = '#$hex';
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: currentColor,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white24),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: hexCtrl,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              labelText: 'Código HEX',
                              labelStyle: TextStyle(color: Colors.white70),
                              hintText: '#RRGGBB',
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white24),
                              ),
                            ),
                            maxLength: 7,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    String text = hexCtrl.text.replaceAll('#', '');
                    if (text.length == 6) text = 'FF$text';
                    try {
                      final colorInt = int.parse(text, radix: 16);
                      Navigator.pop(context, colorInt);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Formato inválido')),
                      );
                    }
                  },
                  child: const Text('Aplicar'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
