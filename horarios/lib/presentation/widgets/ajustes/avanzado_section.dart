import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../providers/horario_provider.dart';
import '../../../providers/eventos_provider.dart';
import '../../../providers/perfil_provider.dart';
import '../../../providers/calificaciones_provider.dart';

class AvanzadoSection extends StatelessWidget {
  const AvanzadoSection({super.key});

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
      final calificacionesProv = context.read<CalificacionesProvider>();

      await horarioProv.formatear();
      await eventosProv.formatear();
      await perfilProv.formatear();
      await calificacionesProv.formatear();
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

  @override
  Widget build(BuildContext context) {
    return Card(
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
    );
  }
}
