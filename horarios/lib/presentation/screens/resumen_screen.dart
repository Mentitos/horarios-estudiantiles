import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/horario_provider.dart';
import '../../providers/eventos_provider.dart';
import '../../providers/perfil_provider.dart';
import '../../data/sources/local_datasource.dart';
import '../../data/models/materia_custom.dart';
import 'materias_aprobadas_screen.dart';

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
                  vertical: 12,
                ),
                children: [
                  SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(vertical: 4),
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
                          icon: Icons.collections_rounded,
                          label: 'Galería',
                          onTap: () => _navegar(context, 6),
                        ),
                        const SizedBox(width: 12),
                        _NavCard(
                          icon: Icons.settings_rounded,
                          label: 'Ajustes',
                          onTap: () => _navegar(context, 7),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

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
                          aula: bloque.aula?.isNotEmpty == true ? bloque.aula : materia.aula,
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
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.5),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: 95,
          height: 100,
          decoration: BoxDecoration(
            color: isDark
                ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.3)
                : colorScheme.surface.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.1)
                  : colorScheme.outlineVariant.withValues(alpha: 0.5),
            ),
            boxShadow: [
              if (!isDark)
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, size: 28, color: colorScheme.primary),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
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
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark
            ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.2)
            : colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(icon, size: 28, color: colorScheme.primary),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                sub,
                style: TextStyle(
                  fontSize: 13,
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ],
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark
            ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.2)
            : colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              width: 6,
              decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          nombre.isNotEmpty ? nombre[0] : '?',
                          style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            nombre,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.access_time_rounded,
                                size: 14,
                                color: colorScheme.onSurface.withValues(
                                  alpha: 0.5,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '$horaInicio – $horaFin',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: colorScheme.onSurface.withValues(
                                    alpha: 0.6,
                                  ),
                                ),
                              ),
                              if (aula?.isNotEmpty == true) ...[
                                const SizedBox(width: 12),
                                Icon(
                                  Icons.room_rounded,
                                  size: 14,
                                  color: colorScheme.onSurface.withValues(
                                    alpha: 0.5,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Aula $aula',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: colorScheme.onSurface.withValues(
                                      alpha: 0.6,
                                    ),
                                  ),
                                ),
                              ],
                            ],
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
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark
            ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.2)
            : colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              width: 6,
              decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        tipo == 'TP'
                            ? Icons.assignment_rounded
                            : Icons.event_note_rounded,
                        color: color,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            titulo,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '$tipo • $materia',
                            style: TextStyle(
                              fontSize: 13,
                              color: colorScheme.onSurface.withValues(
                                alpha: 0.6,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        _formatFecha(fecha),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
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
        final carrera = snapshot.data;
        int aprobadas = 0;
        int total = 0;

        if (carrera != null) {
          total = carrera.materiasIds.length;
          for (var mId in carrera.materiasIds) {
            if (mId.contains(':')) {
              if (mId.split(':').any((p) => perfilProvider.estaAprobada(p))) {
                aprobadas++;
              }
            } else {
              if (perfilProvider.estaAprobada(mId)) {
                aprobadas++;
              }
            }
          }
        } else {
          return FutureBuilder<List<MateriaCustom>>(
            future: LocalDatasource().leerMateriasCustom(),
            builder: (context, customSnapshot) {
              if (!customSnapshot.hasData)
                return const LinearProgressIndicator();
              final misMaterias = customSnapshot.data!
                  .where((m) => m.carreraAsociada == nombreCarrera)
                  .toList();
              total = misMaterias.length;
              aprobadas = misMaterias
                  .where(
                    (m) =>
                        m.materiaId != null &&
                        perfilProvider.estaAprobada(m.materiaId!),
                  )
                  .length;
              final pct = total > 0 ? aprobadas / total : 0.0;
              return InkWell(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const MateriasAprobadasScreen(),
                  ),
                ),
                child: _buildProgresoUI(context, pct, aprobadas, total),
              );
            },
          );
        }

        final pct = total > 0 ? aprobadas / total : 0.0;
        return InkWell(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const MateriasAprobadasScreen()),
          ),
          child: _buildProgresoUI(context, pct, aprobadas, total),
        );
      },
    );
  }

  Widget _buildProgresoUI(
    BuildContext context,
    double pct,
    int aprobadas,
    int total,
  ) {
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
  }
}
