import 'package:flutter/material.dart';
import '../../../../services/backup_service.dart';

class BackupSection extends StatefulWidget {
  const BackupSection({super.key});

  @override
  State<BackupSection> createState() => _BackupSectionState();
}

class _BackupSectionState extends State<BackupSection> {
  final BackupService _backupService = BackupService();
  bool _isWorking = false;

  Future<void> _exportar() async {
    setState(() => _isWorking = true);
    final success = await _backupService.exportarBackup();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? 'Preparando copia de seguridad...'
                : 'Hubo un error al preparar la copia.',
          ),
        ),
      );
      setState(() => _isWorking = false);
    }
  }

  Future<void> _importar() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('⚠️ Advertencia'),
        content: const Text(
          'Restaurar una copia de seguridad sobrescribirá TODOS tus datos actuales '
          '(materias, notas, eventos del calendario, etc.).\n\n'
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

    if (confirm != true) return;

    if (mounted) setState(() => _isWorking = true);

    final result = await _backupService.importarBackup();

    if (mounted) {
      if (result != 'OK' && result != 'Cancelado por el usuario') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result)),
        );
      }
      setState(() => _isWorking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (_isWorking) {
      return const Card(
        margin: EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Center(
            child: Column(
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Realizando operación...'),
              ],
            ),
          ),
        ),
      );
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.save_rounded,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Copias de Seguridad',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Guardá o recuperá tus datos. La copia incluye:',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 6),
            // Lista de qué incluye el backup
            ...const [
              _BackupIncludeItem(icon: Icons.grid_view_rounded, label: 'Materias y horario'),
              _BackupIncludeItem(icon: Icons.calendar_month_rounded, label: 'Eventos del calendario (parciales, TPs)'),
              _BackupIncludeItem(icon: Icons.people_alt_rounded, label: 'Directorio de profesores'),
              _BackupIncludeItem(icon: Icons.note_alt_rounded, label: 'Calificaciones y progreso'),
              _BackupIncludeItem(icon: Icons.tune_rounded, label: 'Configuraciones'),
            ],
            const SizedBox(height: 4),
            Text(
              '⚠ No incluye grabaciones de audio ni fotos.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              'También podés tocar un archivo ".horarios" desde WhatsApp o tu gestor de archivos para restaurarlo.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _exportar,
                    icon: const Icon(Icons.upload_file_rounded),
                    label: const Text('Exportar'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _importar,
                    icon: const Icon(Icons.download_rounded),
                    label: const Text('Restaurar'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _BackupIncludeItem extends StatelessWidget {
  final IconData icon;
  final String label;
  const _BackupIncludeItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(icon, size: 14, color: colorScheme.primary),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(fontSize: 13, color: colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
