import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/theme_provider.dart';

class AparienciaSection extends StatelessWidget {
  const AparienciaSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
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
                      themeProvider.toggleTheme(selected == ThemeMode.dark);
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
