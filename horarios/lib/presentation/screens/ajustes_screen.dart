import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../providers/theme_provider.dart';

import '../../providers/horario_provider.dart';
import '../../providers/eventos_provider.dart';
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

          // ── Avanzado ────────────────────────────────────────────
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                    child: Text(
                      'Avanzado',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.8,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.5),
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.restore, size: 22),
                    title: const Text('Restablecer datos'),
                    subtitle: const Text(
                      'Elimina horario, eventos y progreso local',
                      style: TextStyle(fontSize: 12),
                    ),
                    trailing: const Icon(Icons.chevron_right, size: 20),
                    onTap: () => _confirmarFormateo(context),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // ── Acerca de + Firma ───────────────────────────────────
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Acerca de',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Datos: github.com/Mentitos/materiasungsporcentaje',
                  ),
                  const Divider(height: 24),
                  const Text(
                    'Desarrollado por',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Matias Gabriel Tello',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: FilledButton.tonalIcon(
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                      ),
                      onPressed: () => _abrirLink(
                        'https://mentitos.github.io/Presentacion/',
                      ),
                      icon: const Icon(Icons.code_rounded, size: 18),
                      label: const Text(
                        'mentitos.github.io/Presentacion',
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                  ),
                  const Divider(height: 24),
                  const Text(
                    '¡Probá mi otra app!',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Finanzas Libre',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: FilledButton.tonalIcon(
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                      ),
                      onPressed: () => _abrirLink(
                        'https://mentitos.github.io/finanzaslibre-pagina/',
                      ),
                      icon: const Icon(
                        Icons.account_balance_wallet_rounded,
                        size: 18,
                      ),
                      label: const Text(
                        'Conocé Finanzas Libre',
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmarFormateo(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('¿Formatear todo?'),
        content: const Text(
          'Se eliminarán todos los datos locales: horario, materias aprobadas y eventos registrados.\n\nEsta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
              foregroundColor: Theme.of(ctx).colorScheme.onError,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Formatear'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await context.read<HorarioProvider>().formatear();
      await context.read<EventosProvider>().formatear();
      await context.read<PerfilProvider>().formatear();
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('onboarding_done');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Datos eliminados. Reiniciá la app para el asistente de configuración.',
            ),
          ),
        );
      }
    }
  }

  Future<void> _abrirLink(String url) async {
    final uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('Error al abrir link: $e');
    }
  }
}
