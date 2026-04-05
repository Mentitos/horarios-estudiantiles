import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import '../../../providers/version_provider.dart';
import '../../../providers/donaciones_provider.dart';

class AcercaDeSection extends StatelessWidget {
  const AcercaDeSection({super.key});

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

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Acerca de',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Consumer<VersionProvider>(
                  builder: (context, vProv, _) {
                    final date = vProv.buildDate;
                    final dateStr =
                        '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
                    return Text(
                      'Actualizado: $dateStr',
                      style: TextStyle(
                        fontSize: 11,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            Consumer<VersionProvider>(
              builder: (context, vProv, _) => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (vProv.isUpdateAvailable)
                    Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.update,
                            color: Theme.of(
                              context,
                            ).colorScheme.onPrimaryContainer,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              '¡Nueva versión disponible!',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onPrimaryContainer,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () => _abrirLink(vProv.downloadUrl),
                            child: const Text('DESCARGAR'),
                          ),
                        ],
                      ),
                    ),
                  if (vProv.checkPerformed && vProv.isUpToDate)
                    Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.green.withValues(alpha: 0.3),
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 20,
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Tenés la versión más reciente.',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (vProv.error != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(
                        vProv.error!,
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ElevatedButton.icon(
                    onPressed: vProv.loading
                        ? null
                        : () => vProv.checkUpdates(),
                    icon: vProv.loading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.refresh, size: 18),
                    label: Text(
                      vProv.loading
                          ? 'Verificando...'
                          : 'Buscar actualizaciones',
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 24),
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
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
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
                            content: Text('Alias copiado al portapapeles.'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Consumer<DonacionesProvider>(
              builder: (context, donacionesProv, child) {
                final status = donacionesProv.status;

                Color? statusColor;
                switch (status) {
                  case SyncStatus.success:
                    statusColor = Colors.green.withOpacity(0.2);
                    break;
                  case SyncStatus.noChanges:
                    statusColor = Colors.blue.withOpacity(0.2);
                    break;
                  case SyncStatus.error:
                    statusColor = Colors.red.withOpacity(0.2);
                    break;
                  case SyncStatus.idle:
                    statusColor = null;
                }

                final titulo = donacionesProv.titulo;
                final montoActual = donacionesProv.montoActual;
                final metas = donacionesProv.metas;
                final metaActiva = donacionesProv.metaProxima;
                final porcentaje = donacionesProv.porcentaje;
                final porcentajeTexto = (porcentaje * 100).toStringAsFixed(1);

                final nFormat = NumberFormat.currency(
                  locale: 'es_AR',
                  symbol: '\$',
                  decimalDigits: 0,
                );

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          titulo,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (donacionesProv.ultimaActualizacion != null)
                          InkWell(
                            onTap: () => donacionesProv.limpiarMensajes(),
                            borderRadius: BorderRadius.circular(4),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: statusColor,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'Act: ${DateFormat('HH:mm:ss').format(donacionesProv.ultimaActualizacion!)}',
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ),
                        if (donacionesProv.cargando)
                          const SizedBox(
                            width: 24,
                            height: 24,
                            child: Padding(
                              padding: EdgeInsets.all(4.0),
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          )
                        else
                          IconButton(
                            icon: const Icon(Icons.refresh, size: 20),
                            onPressed: () =>
                                donacionesProv.refrescar(force: true),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            tooltip: 'Actualizar donaciones',
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (status == SyncStatus.error)
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.errorContainer.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Theme.of(
                              context,
                            ).colorScheme.error.withOpacity(0.2),
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.wifi_off_rounded,
                              color: Theme.of(
                                context,
                              ).colorScheme.error.withOpacity(0.6),
                              size: 32,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              donacionesProv.error ??
                                  'Las donaciones se ven con internet',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(
                                  context,
                                ).colorScheme.error.withOpacity(0.8),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Conectate para ver las metas y el top de donantes.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 11,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.primaryContainer.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withOpacity(0.2),
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    metaActiva?.nombre ??
                                        '¡Metas de la Comunidad!',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Text(
                                  '$porcentajeTexto%',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: LinearProgressIndicator(
                                value: porcentaje,
                                minHeight: 12,
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.surface,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Recaudado: ${nFormat.format(montoActual)}',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                if (metaActiva != null)
                                  Text(
                                    'Meta de la etapa: ${nFormat.format(metaActiva.monto)}',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                              ],
                            ),
                            if (metas.isNotEmpty) ...[
                              const Divider(height: 24),
                              ...metas.map((m) {
                                final alcanzada = montoActual >= m.monto;
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Row(
                                    children: [
                                      Icon(
                                        alcanzada
                                            ? Icons.check_circle
                                            : Icons.circle_outlined,
                                        size: 14,
                                        color: alcanzada
                                            ? Colors.green
                                            : Theme.of(context)
                                                  .colorScheme
                                                  .onSurface
                                                  .withOpacity(0.5),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          m.nombre,
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: alcanzada
                                                ? null
                                                : Theme.of(context)
                                                      .colorScheme
                                                      .onSurface
                                                      .withOpacity(0.7),
                                            decoration: alcanzada
                                                ? TextDecoration.lineThrough
                                                : null,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        nFormat.format(m.monto),
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: alcanzada
                                              ? Colors.green
                                              : null,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ],
                            const SizedBox(height: 8),
                            const Text(
                              'Con tu ayuda puedo cubrir los costos del servidor y seguir mejorando la app con las funciones que me pidan. ¡Gracias por el aguante!',
                              style: TextStyle(
                                fontSize: 11,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            if (donacionesProv.topDonantes.isNotEmpty) ...[
                              const Divider(height: 32),
                              const Row(
                                children: [
                                  Icon(
                                    Icons.emoji_events_outlined,
                                    size: 18,
                                    color: Colors.amber,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Top Donantes',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .surfaceContainerHighest
                                      .withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  children: List.generate(
                                    donacionesProv.topDonantes.length,
                                    (index) {
                                      final d =
                                          donacionesProv.topDonantes[index];
                                      final medalColor = index == 0
                                          ? Colors.amber
                                          : index == 1
                                          ? const Color(0xFFC0C0C0)
                                          : const Color(0xFFCD7F32);

                                      return Padding(
                                        padding: EdgeInsets.only(
                                          bottom:
                                              index <
                                                  donacionesProv
                                                          .topDonantes
                                                          .length -
                                                      1
                                              ? 8.0
                                              : 0,
                                        ),
                                        child: Row(
                                          children: [
                                            if (index < 3)
                                              Icon(
                                                Icons.workspace_premium,
                                                size: 16,
                                                color: medalColor,
                                              )
                                            else
                                              const SizedBox(width: 16),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                d.nombre,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              nFormat.format(d.monto),
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Theme.of(
                                                  context,
                                                ).colorScheme.primary,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                  ],
                );
              },
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
            const SizedBox(height: 4),
            const Text(
              '¿Tenés alguna sugerencia o encontraste un error? Escribime a:',
              style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 2),
            GestureDetector(
              onTap: () =>
                  _abrirLink('mailto:sugerenciasfinanzaslibre@gmail.com'),
              child: Text(
                'sugerenciasfinanzaslibre@gmail.com',
                style: TextStyle(
                  fontSize: 13,
                  color: Theme.of(context).colorScheme.primary,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.w500,
                ),
              ),
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
                onPressed: () =>
                    _abrirLink('https://mentitos.github.io/Presentacion/'),
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
    );
  }
}
