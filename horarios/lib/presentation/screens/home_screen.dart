import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/calificaciones_provider.dart';
import 'resumen_screen.dart';
import 'horario_screen.dart';
import 'calendario_eventos_screen.dart';
import 'ajustes_screen.dart';
import 'calificaciones_screen.dart';
import 'calificaciones_archivadas_screen.dart';
import 'profesores_screen.dart';
import 'grabaciones_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  bool _mostrarSabado = false;
  bool _mostrarDomingo = false;

  final GlobalKey<CalendarioEventosScreenState> _calendarioKey =
      GlobalKey<CalendarioEventosScreenState>();

  void navigateTo(int index) {
    setState(() => _currentIndex = index);
  }

  static const List<String> _titles = [
    'Resumen',
    'Horario',
    'Calendario',
    'Calificaciones',
    'Profesores',
    'Grabaciones',
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
    _DrawerItem(icon: Icons.mic_rounded, label: 'Grabaciones'),
  ];

  static const List<_DrawerItem> _drawerItemsSettings = [
    _DrawerItem(icon: Icons.settings_rounded, label: 'Ajustes'),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final screens = [
      ResumenScreen(onNavigate: navigateTo),
      HorarioScreen(
        mostrarSabado: _mostrarSabado,
        mostrarDomingo: _mostrarDomingo,
      ),
      CalendarioEventosScreen(key: _calendarioKey),
      const CalificacionesScreen(),
      const ProfesoresScreen(),
      const GrabacionesScreen(),
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
          setState(() => _currentIndex = index);
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
                  'Horarios UNGS',
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
      body: IndexedStack(index: _currentIndex, children: screens),
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
          ],
          onSelected: (val) {
            setState(() {
              if (val == 'sabado') _mostrarSabado = !_mostrarSabado;
              if (val == 'domingo') _mostrarDomingo = !_mostrarDomingo;
            });
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
            color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'Próximamente: $title',
            style: TextStyle(
              fontSize: 18,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }
}
