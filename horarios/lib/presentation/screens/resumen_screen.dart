import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/horario_provider.dart';
import '../../providers/eventos_provider.dart';
import '../../providers/perfil_provider.dart';
import '../../data/sources/local_datasource.dart';

class ResumenScreen extends StatelessWidget {
  final void Function(int index)? onNavigate;
  const ResumenScreen({super.key, this.onNavigate});

  String _diaActual() {
    const dias = [
      'Lunes',
      'Martes',
      'Miércoles',
      'Jueves',
      'Viernes',
      'Sábado',
      'Domingo',
    ];
    return dias[DateTime.now().weekday - 1];
  }

  String _fechaHoy() {
    final now = DateTime.now();
    const meses = [
      'ene',
      'feb',
      'mar',
      'abr',
      'may',
      'jun',
      'jul',
      'ago',
      'sep',
      'oct',
      'nov',
      'dic',
    ];
    return '${now.day} ${meses[now.month - 1]} ${now.year}';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final diaHoy = _diaActual();

    return Scaffold(
      body: Consumer3<HorarioProvider, EventosProvider, PerfilProvider>(
        builder:
            (context, horarioProvider, eventosProvider, perfilProvider, _) {
              final horario = horarioProvider.horario;
              final materiasHoy =
                  horario?.materiasSeleccionadas
                      .where((m) => m.bloques.any((b) => b.dia == diaHoy))
                      .toList() ??
                  [];

              final ahora = DateTime.now();
              final eventos7dias =
                  eventosProvider.eventos
                      .where(
                        (e) =>
                            e.fecha.isAfter(
                              ahora.subtract(const Duration(days: 1)),
                            ) &&
                            e.fecha.isBefore(
                              ahora.add(const Duration(days: 8)),
                            ),
                      )
                      .toList()
                    ..sort((a, b) => a.fecha.compareTo(b.fecha));

              return ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _NavCard(
                          icon: Icons.grid_view_rounded,
                          label: 'Horario',
                          onTap: () => _navegar(context, 1),
                        ),
                        const SizedBox(width: 12),
                        _NavCard(
                          icon: Icons.calendar_month_rounded,
                          label: 'Calendario',
                          onTap: () => _navegar(context, 2),
                        ),
                        const SizedBox(width: 12),
                        _NavCard(
                          icon: Icons.note_alt_rounded,
                          label: 'Notas',
                          onTap: () => _navegar(context, 3),
                        ),
                        const SizedBox(width: 12),
                        _NavCard(
                          icon: Icons.person_search_rounded,
                          label: 'Profesores',
                          onTap: () => _navegar(context, 4),
                        ),
                        const SizedBox(width: 12),
                        _NavCard(
                          icon: Icons.mic_rounded,
                          label: 'Grabaciones',
                          onTap: () => _navegar(context, 5),
                        ),
                        const SizedBox(width: 12),
                        _NavCard(
                          icon: Icons.settings_rounded,
                          label: 'Ajustes',
                          onTap: () => _navegar(context, 6),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  _SectionHeader(title: 'Hoy • $diaHoy', trailing: _fechaHoy()),
                  const SizedBox(height: 8),

                  if (materiasHoy.isEmpty)
                    _EmptyCard(
                      icon: Icons.coffee_rounded,
                      message: 'Sin clases hoy',
                      sub: 'Disfruta tu día',
                    )
                  else
                    ...materiasHoy.expand((materia) {
                      final bloquesHoy =
                          materia.bloques.where((b) => b.dia == diaHoy).toList()
                            ..sort(
                              (a, b) => (a.horaInicio ?? '').compareTo(
                                b.horaInicio ?? '',
                              ),
                            );
                      return bloquesHoy.map(
                        (bloque) => _ClaseCard(
                          nombre: materia.materiaNombre ?? '',
                          horaInicio: bloque.horaInicio ?? '',
                          horaFin: bloque.horaFin ?? '',
                          aula: bloque.aula,
                          color: Color(materia.colorARGB ?? 0xFF1E88E5),
                        ),
                      );
                    }),

                  const SizedBox(height: 20),

                  const _SectionHeader(title: 'Próximos eventos'),
                  const SizedBox(height: 8),

                  if (eventos7dias.isEmpty)
                    _EmptyCard(
                      icon: Icons.thumb_up_alt_rounded,
                      message: 'No hay eventos próximos',
                      sub: 'Disfruta tu semana',
                    )
                  else
                    ...eventos7dias.map((evento) {
                      final materia = horario?.materiasSeleccionadas
                          .where((m) => m.materiaId == evento.materiaId)
                          .firstOrNull;
                      final color = materia != null
                          ? Color(materia.colorARGB ?? 0xFF1E88E5)
                          : colorScheme.primary;
                      return _EventoCard(
                        titulo: evento.titulo,
                        tipo: evento.tipo,
                        materia: materia?.materiaNombre ?? '',
                        fecha: evento.fecha,
                        color: color,
                      );
                    }),

                  const SizedBox(height: 20),

                  if (perfilProvider.carrerasSeleccionadas.isNotEmpty) ...[
                    const _SectionHeader(title: 'Progreso académico'),
                    const SizedBox(height: 8),
                    ...perfilProvider.carrerasSeleccionadas.map(
                      (nombreCarrera) => _ProgresoCard(
                        nombreCarrera: nombreCarrera,
                        perfilProvider: perfilProvider,
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ],
              );
            },
      ),
    );
  }

  void _navegar(BuildContext context, int index) {
    onNavigate?.call(index);
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String? trailing;
  const _SectionHeader({required this.title, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        if (trailing != null)
          Text(
            trailing!,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
      ],
    );
  }
}

class _NavCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _NavCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.zero,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          borderRadius: BorderRadius.zero,
          border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: colorScheme.primary),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyCard extends StatelessWidget {
  final IconData icon;
  final String message;
  final String sub;
  const _EmptyCard({
    required this.icon,
    required this.message,
    required this.sub,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Icon(
              icon,
              size: 36,
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.7),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                Text(
                  sub,
                  style: TextStyle(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.5),
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

class _ClaseCard extends StatelessWidget {
  final String nombre;
  final String horaInicio;
  final String horaFin;
  final String? aula;
  final Color color;
  const _ClaseCard({
    required this.nombre,
    required this.horaInicio,
    required this.horaFin,
    this.aula,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = color.computeLuminance() > 0.5
        ? Colors.black87
        : Colors.white;
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(width: 5, color: color),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: color,
                      radius: 18,
                      child: Text(
                        nombre.isNotEmpty ? nombre[0] : '?',
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            nombre,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            '$horaInicio – $horaFin${aula?.isNotEmpty == true ? ' • Aula $aula' : ''}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EventoCard extends StatelessWidget {
  final String titulo;
  final String tipo;
  final String materia;
  final DateTime fecha;
  final Color color;
  const _EventoCard({
    required this.titulo,
    required this.tipo,
    required this.materia,
    required this.fecha,
    required this.color,
  });

  String _formatFecha(DateTime d) {
    const dias = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];
    const meses = [
      'ene',
      'feb',
      'mar',
      'abr',
      'may',
      'jun',
      'jul',
      'ago',
      'sep',
      'oct',
      'nov',
      'dic',
    ];
    return '${dias[d.weekday - 1]} ${d.day} ${meses[d.month - 1]}';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(width: 5, color: color),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: color.withValues(alpha: 0.15),
                      radius: 18,
                      child: Icon(
                        tipo == 'TP' ? Icons.assignment : Icons.assignment_late,
                        color: color,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            titulo,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            '$tipo • $materia',
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _formatFecha(fecha),
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: color,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgresoCard extends StatelessWidget {
  final String nombreCarrera;
  final PerfilProvider perfilProvider;
  const _ProgresoCard({
    required this.nombreCarrera,
    required this.perfilProvider,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: LocalDatasource().leerCarreraPorNombre(nombreCarrera),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const LinearProgressIndicator();
        final carrera = snapshot.data!;
        int aprobadas = 0;
        final total = carrera.materiasIds.length;
        for (var mId in carrera.materiasIds) {
          if (mId.contains(':')) {
            if (mId.split(':').any((p) => perfilProvider.estaAprobada(p)))
              aprobadas++;
          } else {
            if (perfilProvider.estaAprobada(mId)) aprobadas++;
          }
        }
        final pct = total > 0 ? aprobadas / total : 0.0;
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nombreCarrera,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: pct,
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(4),
                ),
                const SizedBox(height: 4),
                Text(
                  '$aprobadas / $total aprobadas (${(pct * 100).toStringAsFixed(1)}%)',
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
