import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';

import '../../providers/materias_provider.dart';
import '../../providers/perfil_provider.dart';
import '../../utils/carreras_grupos.dart';
import '../../data/sources/local_datasource.dart';
import 'materias_aprobadas_screen.dart';

class AjustesScreen extends StatelessWidget {
  const AjustesScreen({super.key});

  Future<void> _mostrarDialogoSeleccionarCarreras(BuildContext context) async {
    final perfilProvider = context.read<PerfilProvider>();
    final carrerasActuales = List<String>.from(
      perfilProvider.carrerasSeleccionadas,
    );

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text('Seleccionar Carreras (máx 2)'),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: gruposCarreras.keys.length,
                  itemBuilder: (context, index) {
                    final tipo = gruposCarreras.keys.elementAt(index);
                    final carrerasDelTipo = gruposCarreras[tipo]!;

                    return ExpansionTile(
                      title: Text(tipo),
                      children: carrerasDelTipo.map((nombreCarrera) {
                        final isSelected = carrerasActuales.contains(
                          nombreCarrera,
                        );
                        return CheckboxListTile(
                          title: Text(nombreCarrera),
                          value: isSelected,
                          onChanged: (bool? checked) {
                            if (checked == true) {
                              if (carrerasActuales.length >= 2) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Máximo 2 carreras permitidas',
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
    final materiasProvider = context.watch<MateriasProvider>();
    final perfilProvider = context.watch<PerfilProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajustes'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Apariencia',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Consumer<ThemeProvider>(
                    builder: (context, themeProvider, child) {
                      return SegmentedButton<ThemeMode>(
                        segments: const [
                          ButtonSegment(
                            value: ThemeMode.light,
                            icon: Icon(Icons.light_mode),
                            label: Text('Claro'),
                          ),
                          ButtonSegment(
                            value: ThemeMode.system,
                            icon: Icon(Icons.brightness_auto),
                            label: Text('Sistema'),
                          ),
                          ButtonSegment(
                            value: ThemeMode.dark,
                            icon: Icon(Icons.dark_mode),
                            label: Text('Oscuro'),
                          ),
                        ],
                        selected: {themeProvider.themeMode},
                        onSelectionChanged: (Set<ThemeMode> newSelection) {
                          final selected = newSelection.first;
                          if (selected == ThemeMode.system) {
                            themeProvider.setSystemTheme();
                          } else {
                            themeProvider.toggleTheme(
                              selected == ThemeMode.dark,
                            );
                          }
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Mi carrera',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Seleccioná hasta 2 carreras para ver tu progreso.',
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8.0,
                    children: perfilProvider.carrerasSeleccionadas.map((
                      carrera,
                    ) {
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
                    onPressed: () =>
                        _mostrarDialogoSeleccionarCarreras(context),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          if (perfilProvider.carrerasSeleccionadas.isNotEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Progreso académico',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...perfilProvider.carrerasSeleccionadas.map((
                      nombreCarrera,
                    ) {
                      return FutureBuilder(
                        future: LocalDatasource().leerCarreraPorNombre(
                          nombreCarrera,
                        ),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const LinearProgressIndicator();
                          }

                          final carrera = snapshot.data!;
                          int aprobadasCount = 0;
                          final totalMaterias = carrera.materiasIds.length;

                          for (var mIdRaw in carrera.materiasIds) {
                            if (mIdRaw.contains(':')) {
                              final parts = mIdRaw.split(':');
                              bool estaAprobada = parts.any(
                                (p) => perfilProvider.estaAprobada(p),
                              );
                              if (estaAprobada) aprobadasCount++;
                            } else {
                              if (perfilProvider.estaAprobada(mIdRaw)) {
                                aprobadasCount++;
                              }
                            }
                          }

                          final percentDouble = totalMaterias > 0
                              ? (aprobadasCount / totalMaterias)
                              : 0.0;
                          final percentageText = (percentDouble * 100)
                              .toStringAsFixed(1);

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                nombreCarrera,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              LinearProgressIndicator(
                                value: percentDouble,
                                minHeight: 12,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${aprobadasCount} / ${totalMaterias} aprobadas (${percentageText}%)',
                              ),
                              const SizedBox(height: 16),
                            ],
                          );
                        },
                      );
                    }),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.check_circle_outline),
                      label: const Text('Gestionar materias aprobadas'),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const MateriasAprobadasScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

          if (perfilProvider.carrerasSeleccionadas.isNotEmpty)
            const SizedBox(height: 16),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Actualizar datos desde la web',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Forzar la descarga de la última versión de materias y carreras.',
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: materiasProvider.cargando
                        ? null
                        : () async {
                            try {
                              await context
                                  .read<MateriasProvider>()
                                  .refrescar();
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Actualizadas!'),
                                  ),
                                );
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error: $e')),
                                );
                              }
                            }
                          },
                    child: materiasProvider.cargando
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Descargar JSON'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Acerca de',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('Datos: github.com/Mentitos/materiasungsporcentaje'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
