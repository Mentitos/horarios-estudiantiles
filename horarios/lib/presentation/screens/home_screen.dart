import 'package:flutter/material.dart';
import 'resumen_screen.dart';
import 'horario_screen.dart';
import 'calendario_eventos_screen.dart';
import 'ajustes_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  // Opciones del calendario semanal
  bool _mostrarSabado = false;
  bool _mostrarDomingo = false;

  void navigateTo(int index) {
    setState(() => _currentIndex = index);
  }

  static const List<String> _titles = [
    'Resumen',
    'Horario',
    'Calendario',
    'Ajustes',
  ];

  static const List<_DrawerItem> _drawerItems = [
    _DrawerItem(icon: Icons.home_rounded, label: 'Resumen'),
    _DrawerItem(icon: Icons.grid_view_rounded, label: 'Horario'),
    _DrawerItem(icon: Icons.calendar_month_rounded, label: 'Calendario'),
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
      const CalendarioEventosScreen(),
      const AjustesScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
        backgroundColor: colorScheme.surface,
        surfaceTintColor: colorScheme.surfaceTint,
        elevation: 0,
        scrolledUnderElevation: 2,
        // ── Botón ⋮ solo en la pestaña Horario ─────────────────
        actions: _currentIndex == 1
            ? [
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
              ]
            : null,
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
          for (final item in _drawerItems)
            NavigationDrawerDestination(
              icon: Icon(item.icon),
              label: Text(item.label),
            ),
        ],
      ),
      body: IndexedStack(index: _currentIndex, children: screens),
    );
  }
}

class _DrawerItem {
  final IconData icon;
  final String label;
  const _DrawerItem({required this.icon, required this.label});
}
