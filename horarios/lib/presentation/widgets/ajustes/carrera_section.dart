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

  @override
  Widget build(BuildContext context) {
    final perfilProvider = context.watch<PerfilProvider>();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              perfilProvider.carrerasSeleccionadas.length > 1
                  ? 'Mis carreras'
                  : 'Mi carrera',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (perfilProvider.esAlumnoExterno) ...[
              const Text(
                'Estás usando la app como alumno de otra universidad.',
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.school),
                label: const Text('Unirme a la UNGS'),
                onPressed: () async {
                  await perfilProvider.setAlumnoExterno(false);
                  if (context.mounted) {
                    _mostrarDialogoSeleccionarCarreras(context);
                  }
                },
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
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
              ElevatedButton.icon(
                icon: const Icon(Icons.check_circle_outline),
                label: const Text('Materias aprobadas'),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const MateriasAprobadasScreen(),
                  ),
                ),
              ),
            ] else ...[
              const Text('Seleccioná hasta 3 carreras para ver tu progreso.'),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8.0,
                children: perfilProvider.carrerasSeleccionadas.map((carrera) {
                  return Chip(
                    label: Text(carrera),
                    onDeleted: () {
                      final nuevas = List<String>.from(
                        perfilProvider.carrerasSeleccionadas,
                      )..remove(carrera);
                      perfilProvider.setCarreras(nuevas);
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.school),
                label: const Text('Cambiar carrera'),
                onPressed: () => _mostrarDialogoSeleccionarCarreras(context),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
