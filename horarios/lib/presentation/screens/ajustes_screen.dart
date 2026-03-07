import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'gestionar_materias_locales_screen.dart' as file_gestionar;

//   Solo con que ayude a alguien a sobrellevar sus estudios me siento realizado
//   Mucha gente llego a usar Finanzas Libre, tuve mensajes de gente desconocida
//   Agradeciendo el que la haya creado, escucho sugerencias e implemento segun
//   Mi criterio y el de los usuarios
class AjustesScreen extends StatefulWidget {
  const AjustesScreen({super.key});

  @override
  State<AjustesScreen> createState() => _AjustesScreenState();
}

class _AjustesScreenState extends State<AjustesScreen> {
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
                        future: context
                            .read<MateriasProvider>()
                            .getMateriasDeCarrera(nombreCarrera),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const LinearProgressIndicator();
                          }

                          final materiasMixtas = snapshot.data as List<dynamic>;
                          int aprobadasCount = 0;
                          int totalMaterias = 0;

                          for (var item in materiasMixtas) {
                            if (item is List) {
                              totalMaterias++;
                              bool estaAprobada = item.any(
                                (m) => perfilProvider.estaAprobada(m.materiaId),
                              );
                              if (estaAprobada) aprobadasCount++;
                            } else {
                              totalMaterias++;
                              if (perfilProvider.estaAprobada(item.materiaId)) {
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
                                '$aprobadasCount / $totalMaterias aprobadas ($percentageText%)',
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
                      onPressed: () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const MateriasAprobadasScreen(),
                          ),
                        );
                        if (context.mounted) setState(() {});
                      },
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.edit_note),
                      label: const Text('Gestionar materias'),
                      onPressed: () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                const file_gestionar.GestionarMateriasLocalesScreen(),
                          ),
                        );
                        if (context.mounted) setState(() {});
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
                              if (!context.mounted) return;

                              final locales = await LocalDatasource()
                                  .leerMateriasCustom();
                              final hayOcultas = locales.any(
                                (c) => c.estaOculta,
                              );

                              if (hayOcultas) {
                                if (!context.mounted) return;
                                final restaurar = await showDialog<bool>(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: const Text('Datos actualizados'),
                                    content: const Text(
                                      'Se descargaron los datos correctamente. Tienes materias oficiales que ocultaste previamente, ¿deseas restaurarlas y volver a verlas?',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(ctx).pop(false),
                                        child: const Text('No'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () =>
                                            Navigator.of(ctx).pop(true),
                                        child: const Text('Restaurar'),
                                      ),
                                    ],
                                  ),
                                );

                                if (restaurar == true) {
                                  await LocalDatasource()
                                      .limpiarMateriasOcultas();
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Planillas restauradas correctamente.',
                                        ),
                                      ),
                                    );
                                    setState(() {});
                                  }
                                }
                              } else {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Actualizadas!'),
                                    ),
                                  );
                                  setState(() {});
                                }
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
                        ).colorScheme.onSurface.withValues(alpha: 0.5),
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
                    'Proyecto Open Source. Podés ver el código libre en el repositorio:',
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
                        'https://github.com/Mentitos/horarios-estudiantiles',
                      ),
                      icon: const Icon(Icons.code_rounded, size: 18),
                      label: const Text(
                        'Ir al repositorio en GitHub',
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                  ),
                  const Divider(height: 24),
                  const Text(
                    'Apoyar el proyecto',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Esta app es sin fines de lucro. Podés ayudar donando a mi alias:',
                    style: TextStyle(fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'ARDOR.BICHO.PILOTO',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.1,
                          ),
                        ),
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: const Icon(Icons.copy, size: 20),
                          tooltip: 'Copiar alias',
                          onPressed: () async {
                            await Clipboard.setData(
                              const ClipboardData(text: 'ARDOR.BICHO.PILOTO'),
                            );
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Alias copiado al portapapeles.',
                                  ),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
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
      final horarioProv = context.read<HorarioProvider>();
      final eventosProv = context.read<EventosProvider>();
      final perfilProv = context.read<PerfilProvider>();

      await horarioProv.formatear();
      await eventosProv.formatear();
      await perfilProv.formatear();
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
