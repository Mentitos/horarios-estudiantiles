import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:io';
import 'package:app_links/app_links.dart';
import 'package:uri_to_file/uri_to_file.dart';
import '../../services/backup_service.dart';
import '../../providers/calificaciones_provider.dart';
import 'resumen_screen.dart';
import 'horario_screen.dart';
import 'calendario_eventos_screen.dart';
import 'ajustes_screen.dart';
import 'calificaciones_screen.dart';
import 'calificaciones_archivadas_screen.dart';
import 'profesores_screen.dart';
import 'grabaciones_screen.dart';
import 'galeria_screen.dart';
import '../../providers/perfil_provider.dart';
import 'calculadora_notas_screen.dart';
import 'vista_previa_grilla_screen.dart';
import 'pomodoro_screen.dart';
// Te imaginas qeu a mucha gente de la ungs le guste o que vea un compañero
// usandola y dija "JIJI yo la hice"
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  bool _mostrarSabado = false;
  bool _mostrarDomingo = false;

  final List<int> _history = [0];

  final GlobalKey<CalendarioEventosScreenState> _calendarioKey =
      GlobalKey<CalendarioEventosScreenState>();

  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    super.initState();
    _cargarPreferencias();
    _initAppLinks();
  }

  void _initAppLinks() {
    _appLinks = AppLinks();
    
    _appLinks.getInitialLink().then((uri) {
      if (uri != null) _procesarUri(uri);
    });

    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      _procesarUri(uri);
    });
  }

  Future<void> _procesarUri(Uri uri) async {
    try {
      final File file = await toFile(uri.toString());
      if (mounted) {
        _preguntarImportar(file.path);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No se pudo leer el archivo: $e'),
            duration: const Duration(seconds: 4),
          ),
        );
      }
      debugPrint('Error al procesar URI de archivo: $e');
    }
  }

  void _preguntarImportar(String filePath) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('⚠️ Advertencia'),
        content: const Text(
          'Se detectó un archivo de copia de seguridad.\n\n'
          'Restaurar esta copia sobrescribirá TODOS tus datos actuales.\n\n'
          'La app se cerrará sola al finalizar.\n\n¿Estás seguro de que querés continuar?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Sobrescribir datos'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final result = await BackupService().importarBackupDesdePath(filePath);
      if (mounted) {
        if (result != 'OK' && result != 'Cancelado por el usuario') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result)),
          );
        }
      }
    }
  }

  Future<void> _cargarPreferencias() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _mostrarSabado = prefs.getBool('mostrar_sabado') ?? false;
      _mostrarDomingo = prefs.getBool('mostrar_domingo') ?? false;
    });
  }

  Future<void> _guardarPreferencia(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  void navigateTo(int index) {
    if (_currentIndex != index) {
      setState(() {
        _currentIndex = index;
        _history.add(index);
      });
    }
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  static const List<String> _titles = [
    'Resumen',
    'Horario',
    'Calendario',
    'Calificaciones',
    'Profesores',
    'Pomodoro',
    'Grabaciones',
    'Galería',
    'Ajustes',
  ];

  static const List<_DrawerItem> _drawerItemsMain = [
    _DrawerItem(icon: Icons.home_rounded, label: 'Resumen'),
    _DrawerItem(icon: Icons.grid_view_rounded, label: 'Horario'),
    _DrawerItem(icon: Icons.calendar_month_rounded, label: 'Calendario'),
  ];

  static const List<_DrawerItem> _drawerItemsStudy = [
    _DrawerItem(icon: Icons.note_alt_rounded, label: 'Calificaciones'),
    _DrawerItem(icon: Icons.person_search_rounded, label: 'Profesores'),
    _DrawerItem(icon: Icons.timer_rounded, label: 'Pomodoro'),
    _DrawerItem(icon: Icons.mic_rounded, label: 'Grabaciones'),
    _DrawerItem(icon: Icons.collections_rounded, label: 'Galería'),
  ];

  static const List<_DrawerItem> _drawerItemsSettings = [
    _DrawerItem(icon: Icons.settings_rounded, label: 'Ajustes'),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final perfilProvider = context.watch<PerfilProvider>();
    final screens = [
      ResumenScreen(onNavigate: navigateTo),
      HorarioScreen(
        mostrarSabado: _mostrarSabado,
        mostrarDomingo: _mostrarDomingo,
      ),
      CalendarioEventosScreen(key: _calendarioKey),
      const CalificacionesScreen(),
      const ProfesoresScreen(),
      const PomodoroScreen(),
      const GrabacionesScreen(),
      const GaleriaScreen(),
      const AjustesScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
        backgroundColor: colorScheme.surface,
        surfaceTintColor: colorScheme.surfaceTint,
        elevation: 0,
        scrolledUnderElevation: 2,
        actions: _buildAppBarActions(),
      ),
      drawer: NavigationDrawer(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          if (_currentIndex != index) {
            setState(() {
              _currentIndex = index;
              _history.add(index);
            });
          }
          Navigator.pop(context);
        },
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 24, 16, 10),
            child: Row(
              children: [
                Icon(
                  Icons.school_rounded,
                  size: 32,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Text(
                  perfilProvider.esAlumnoExterno
                      ? 'Mis Horarios'
                      : 'Horarios UNGS',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          const Divider(indent: 28, endIndent: 28),
          const SizedBox(height: 8),

          for (final item in _drawerItemsMain)
            NavigationDrawerDestination(
              icon: Icon(item.icon),
              label: Text(item.label),
            ),

          const Divider(indent: 28, endIndent: 28),
          const SizedBox(height: 8),

          for (final item in _drawerItemsStudy)
            NavigationDrawerDestination(
              icon: Icon(item.icon),
              label: Text(item.label),
            ),

          const Divider(indent: 28, endIndent: 28),
          const SizedBox(height: 8),
          for (final item in _drawerItemsSettings)
            NavigationDrawerDestination(
              icon: Icon(item.icon),
              label: Text(item.label),
            ),
        ],
      ),
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) return;

          if (_history.length > 1) {
            setState(() {
              _history.removeLast();
              _currentIndex = _history.last;
            });
          } else if (_currentIndex != 0) {
            setState(() {
              _currentIndex = 0;
              _history.clear();
              _history.add(0);
            });
          } else {
            final confirm = await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('¿Cerrar aplicación?'),
                content: const Text('¿Estás seguro de que querés salir?'),
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
                    child: const Text('Salir'),
                  ),
                ],
              ),
            );
            if (confirm == true) {
              SystemNavigator.pop();
            }
          }
        },
        child: IndexedStack(index: _currentIndex, children: screens),
      ),
    );
  }

  List<Widget>? _buildAppBarActions() {
    if (_currentIndex == 1) {
      return [
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          itemBuilder: (_) => [
            CheckedPopupMenuItem<String>(
              value: 'domingo',
              checked: _mostrarDomingo,
              child: const Text('Mostrar Domingo'),
            ),
            CheckedPopupMenuItem<String>(
              value: 'sabado',
              checked: _mostrarSabado,
              child: const Text('Mostrar Sábado'),
            ),
            const PopupMenuItem(
              value: 'compartir',
              child: Row(
                children: [
                  Icon(Icons.ios_share_rounded, size: 20),
                  SizedBox(width: 12),
                  Text('Compartir horario'),
                ],
              ),
            ),
          ],
          onSelected: (val) {
            if (val == 'sabado') {
              setState(() {
                _mostrarSabado = !_mostrarSabado;
                _guardarPreferencia('mostrar_sabado', _mostrarSabado);
              });
            } else if (val == 'domingo') {
              setState(() {
                _mostrarDomingo = !_mostrarDomingo;
                _guardarPreferencia('mostrar_domingo', _mostrarDomingo);
              });
            } else if (val == 'compartir') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const VistaPreviaGrillaScreen(),
                ),
              );
            }
          },
        ),
      ];
    } else if (_currentIndex == 2) {
      return [
        IconButton(
          icon: const Icon(Icons.calendar_today_rounded),
          tooltip: 'Ir a hoy',
          onPressed: () {
            _calendarioKey.currentState?.irAHoy();
          },
        ),
      ];
    } else if (_currentIndex == 3) {
      return [
        PopupMenuButton<String>(
          icon: const Icon(Icons.sort_rounded),
          itemBuilder: (_) => [
            const PopupMenuItem(value: 'materia', child: Text('Por materia')),
            const PopupMenuItem(value: 'reciente', child: Text('Más reciente')),
            const PopupMenuItem(value: 'antigua', child: Text('Más antigua')),
            const PopupMenuItem(value: 'alta', child: Text('Nota más alta')),
            const PopupMenuItem(value: 'baja', child: Text('Nota más baja')),
          ],
          onSelected: (val) {
            context.read<CalificacionesProvider>().ordenarPor(val);
          },
        ),
        IconButton(
          icon: const Icon(Icons.calculate_rounded),
          tooltip: 'Calculadora de notas',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CalculadoraNotasScreen()),
            );
          },
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          onSelected: (val) {
            final provider = context.read<CalificacionesProvider>();
            if (val == 'archivadas') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CalificacionesArchivadasScreen(),
                ),
              );
            } else if (val == 'archivar_todas') {
              provider.archivarTodasActivas();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Todas las calificaciones fueron archivadas.'),
                ),
              );
            } else if (val == 'toggle_visibilidad') {
              provider.toggleModoArchivado();
            }
          },
          itemBuilder: (_) => [
            const PopupMenuItem(
              value: 'archivadas',
              child: Text('Ver Archivadas'),
            ),
            const PopupMenuItem(
              value: 'archivar_todas',
              child: Text('Archivar Todas'),
            ),
            PopupMenuItem(
              value: 'toggle_visibilidad',
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Archivar individualmente'),
                  if (context
                      .read<CalificacionesProvider>()
                      .modoArchivadoVisible) ...[
                    const SizedBox(width: 8),
                    Icon(
                      Icons.check,
                      size: 20,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ];
    }
    return null;
  }
}

class _DrawerItem {
  final IconData icon;
  final String label;
  const _DrawerItem({required this.icon, required this.label});
}

class PlaceholderScreen extends StatelessWidget {
  final String title;
  final IconData icon;

  const PlaceholderScreen({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 64,
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'Próximamente: $title',
            style: TextStyle(
              fontSize: 18,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}
