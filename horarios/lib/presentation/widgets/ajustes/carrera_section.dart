import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/perfil_provider.dart';
import '../../../providers/materias_provider.dart';
import '../../screens/materias_aprobadas_screen.dart';
import '../../screens/gestionar_materias_locales_screen.dart' as file_gestionar;

class CarreraSection extends StatefulWidget {
  const CarreraSection({super.key});

  @override
  State<CarreraSection> createState() => _CarreraSectionState();
}

class _CarreraSectionState extends State<CarreraSection> {
  Future<void> _mostrarDialogoSeleccionarCarreras(BuildContext context) async {
    final perfilProvider = context.read<PerfilProvider>();
    final carrerasActuales = List<String>.from(
      perfilProvider.carrerasSeleccionadas,
    );

    final materiasProvider = context.read<MateriasProvider>();
    final gruposCarrerasData = materiasProvider.carrerasPorGrupo;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text('Seleccionar Carreras (máx 3)'),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: gruposCarrerasData.keys.length,
                  itemBuilder: (context, index) {
                    final tipo = gruposCarrerasData.keys.elementAt(index);
                    final carrerasDelTipo = gruposCarrerasData[tipo]!;

                    return ExpansionTile(
                      title: Text(tipo),
                      children: carrerasDelTipo.map((carreraObj) {
                        final nombreCarrera = carreraObj.nombre ?? '';
                        final isSelected = carrerasActuales.contains(
                          nombreCarrera,
                        );
                        return CheckboxListTile(
                          title: Text(nombreCarrera),
                          value: isSelected,
                          onChanged: (bool? checked) {
                            if (checked == true) {
                              if (carrerasActuales.length >= 3) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Máximo 3 carreras permitidas',
                                    ),
                                  ),
                                );
                                return;
                              }
                              setStateDialog(
                                () => carrerasActuales.add(nombreCarrera),
                              );
                            } else {
                              setStateDialog(
                                () => carrerasActuales.remove(nombreCarrera),
                              );
                            }
                          },
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await perfilProvider.setCarreras(carrerasActuales);
                    if (context.mounted) Navigator.of(context).pop();
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

  Future<void> _confirmarCambiarModo(
    BuildContext context,
    PerfilProvider perfilProvider,
    bool nuevoModo,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(nuevoModo ? 'Carrera independiente' : 'Usar plan de estudios'),
        content: Text(
          nuevoModo
              ? 'Vas a salir de los planes predefinidos.\n\nPodrás poner el nombre de tu carrera manualmente y llevar tu propio progreso con las materias que cargues.'
              : 'Vas a poder seleccionar carreras con planes de estudio predefinidos de la UNGS.\n\n¿Querés continuar?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Continuar'),
          ),
        ],
      ),
    );

    if (confirm == true && context.mounted) {
      await perfilProvider.setAlumnoExterno(nuevoModo);
      if (!nuevoModo && context.mounted) {
        _mostrarDialogoSeleccionarCarreras(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final perfilProvider = context.watch<PerfilProvider>();
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(Icons.school_rounded, color: colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  perfilProvider.esAlumnoExterno
                      ? 'Mis materias'
                      : (perfilProvider.carrerasSeleccionadas.length > 1
                          ? 'Mis carreras'
                          : 'Mi carrera'),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            if (perfilProvider.esAlumnoExterno) ...[
              // Chip de modo activo
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.school_rounded,
                      size: 16,
                      color: colorScheme.onSecondaryContainer,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Carrera independiente — llevás tu propio progreso',
                        style: TextStyle(
                          fontSize: 13,
                          color: colorScheme.onSecondaryContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              
              if (perfilProvider.carrerasSeleccionadas.isEmpty)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Podés agregar el nombre de tu carrera para llevar el registro',
                    style: TextStyle(
                      fontSize: 13,
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                )
              else
                Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: perfilProvider.carrerasSeleccionadas.map((carrera) {
                    return Chip(
                      label: Text(carrera, style: const TextStyle(fontSize: 12)),
                      onDeleted: () {
                        final nuevas = List<String>.from(
                          perfilProvider.carrerasSeleccionadas,
                        )..remove(carrera);
                        perfilProvider.setCarreras(nuevas);
                      },
                    );
                  }).toList(),
                ),
              const SizedBox(height: 12),
              
              FilledButton.icon(
                icon: const Icon(Icons.add_rounded),
                label: const Text('Agregar nombre de mi carrera'),
                onPressed: () async {
                  final TextEditingController ctrl = TextEditingController();
                  final nombre = await showDialog<String>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Tu carrera'),
                      content: TextField(
                        controller: ctrl,
                        autofocus: true,
                        decoration: const InputDecoration(
                          hintText: 'Ej: Ingeniería en Sistemas',
                        ),
                        textCapitalization: TextCapitalization.words,
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('Cancelar'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (ctrl.text.trim().isNotEmpty) {
                              Navigator.pop(ctx, ctrl.text.trim());
                            }
                          },
                          child: const Text('Guardar'),
                        ),
                      ],
                    ),
                  );
                  
                  if (nombre != null && context.mounted) {
                    final actuales = List<String>.from(perfilProvider.carrerasSeleccionadas);
                    if (!actuales.contains(nombre)) {
                      actuales.add(nombre);
                      await perfilProvider.setCarreras(actuales);
                    }
                  }
                },
              ),
              const SizedBox(height: 8),

              FilledButton.tonalIcon(
                icon: const Icon(Icons.edit_note),
                label: const Text('Gestionar mis materias'),
                onPressed: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) =>
                          const file_gestionar.GestionarMateriasLocalesScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 8),
              FilledButton.tonalIcon(
                icon: const Icon(Icons.check_circle_outline),
                label: const Text('Materias aprobadas'),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const MateriasAprobadasScreen(),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextButton.icon(
                icon: const Icon(Icons.swap_horiz_rounded),
                label: const Text('Usar plan de estudios predefinido'),
                onPressed: () => _confirmarCambiarModo(context, perfilProvider, false),
              ),
            ] else ...[
              const Text(
                'Seleccioná hasta 3 carreras para ver tu progreso.',
                style: TextStyle(fontSize: 13),
              ),
              const SizedBox(height: 12),
              if (perfilProvider.carrerasSeleccionadas.isEmpty)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Ninguna carrera seleccionada',
                    style: TextStyle(
                      fontSize: 13,
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                )
              else
                Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: perfilProvider.carrerasSeleccionadas.map((carrera) {
                    return Chip(
                      label: Text(carrera, style: const TextStyle(fontSize: 12)),
                      onDeleted: () {
                        final nuevas = List<String>.from(
                          perfilProvider.carrerasSeleccionadas,
                        )..remove(carrera);
                        perfilProvider.setCarreras(nuevas);
                      },
                    );
                  }).toList(),
                ),
              const SizedBox(height: 12),
              FilledButton.icon(
                icon: const Icon(Icons.school),
                label: const Text('Cambiar carrera'),
                onPressed: () => _mostrarDialogoSeleccionarCarreras(context),
              ),
              const SizedBox(height: 8),
              TextButton.icon(
                icon: const Icon(Icons.tune_rounded),
                label: const Text('Hacer mi carrera independiente'),
                onPressed: () => _confirmarCambiarModo(context, perfilProvider, true),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
