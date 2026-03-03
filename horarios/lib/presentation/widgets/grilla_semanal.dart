import 'package:flutter/material.dart';
import '../../data/models/horario_usuario.dart';

class GrillaSemanal extends StatelessWidget {
  final HorarioUsuario horario;
  final bool modoExportacion;

  const GrillaSemanal({
    super.key,
    required this.horario,
    this.modoExportacion = false,
  });

  static const double _alturaFranja = 52.0;
  static const int _horaInicio = 7;
  static const int _horaFin = 22;
  static const int _totalFranjas = _horaFin - _horaInicio;

  static const List<String> _diasSemana = [
    'Lunes',
    'Martes',
    'Miércoles',
    'Jueves',
    'Viernes',
  ];

  int _parseMinutosDesdeInicio(String horaAAMM) {
    if (horaAAMM.isEmpty) return 0;
    try {
      final partes = horaAAMM.split(':');
      final horas = int.parse(partes[0]);
      final minutos = int.parse(partes[1]);
      final horasRelativas = horas - _horaInicio;
      return (horasRelativas * 60) + minutos;
    } catch (_) {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Si estamos en modo exportación, usamos un tema claro forzado
    final ThemeData theme = modoExportacion
        ? ThemeData.light().copyWith(
            scaffoldBackgroundColor: Colors.white,
            cardTheme: const CardTheme(
              elevation: 0,
              margin: EdgeInsets.zero,
              color: Colors.white,
            ),
          )
        : Theme.of(context);

    final bgColor = modoExportacion
        ? Colors.white
        : theme.scaffoldBackgroundColor;
    final borderColor = modoExportacion
        ? Colors.grey[300]!
        : theme.dividerColor;
    final textColor = modoExportacion
        ? Colors.black87
        : theme.textTheme.bodyMedium?.color ?? Colors.black;

    return Container(
      color: bgColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (modoExportacion)
            Padding(
              padding: const EdgeInsets.only(top: 24.0, bottom: 16.0),
              child: Text(
                horario.titulo ?? 'Mi Horario',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),

          // Header de Días
          Row(
            children: [
              // Columna vacía arriba de la columna de horas
              const SizedBox(width: 50),
              // Días
              ..._diasSemana.map(
                (dia) => Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: borderColor),
                        left: BorderSide(color: borderColor),
                      ),
                    ),
                    child: Text(
                      dia,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: textColor,
                        fontSize: modoExportacion ? 14 : 12,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Cuerpo de la grilla (Horas + Stacks de Días)
          Expanded(
            child: SingleChildScrollView(
              physics: modoExportacion
                  ? const NeverScrollableScrollPhysics()
                  : null,
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Columna Y: Horas
                    SizedBox(
                      width: 50,
                      child: Stack(
                        children: List.generate(_totalFranjas + 1, (index) {
                          final horaStr =
                              '${(_horaInicio + index).toString().padLeft(2, '0')}:00';
                          return Positioned(
                            top: index * _alturaFranja,
                            left: 0,
                            right: 0,
                            child: Transform.translate(
                              // Subimos el texto un poquito para que el medio del texto
                              // quede apoyando sobre la linea separadora.
                              offset: const Offset(0, -8),
                              child: Text(
                                horaStr,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: textColor.withValues(alpha: 255 * 0.6),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),

                    // Columnas de cada día
                    ..._diasSemana.map(
                      (dia) => Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              left: BorderSide(color: borderColor),
                            ),
                          ),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              // Líneas horizontales de fondo
                              ...List.generate(
                                _totalFranjas,
                                (index) => Positioned(
                                  top: (index + 1) * _alturaFranja,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    height: 1,
                                    color: borderColor.withValues(
                                      alpha: 255 * 0.5,
                                    ),
                                  ),
                                ),
                              ),

                              // Bloques de las materias de este día
                              ..._buildBloquesDelDia(
                                dia,
                                horario.materiasSeleccionadas,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildBloquesDelDia(
    String dia,
    List<MateriaSeleccionada> materias,
  ) {
    // 1. Extraer los bloques que corresponden a este día
    List<Map<String, dynamic>> bloquesDia = [];

    for (var materia in materias) {
      for (var bloque in materia.bloques) {
        if (bloque.dia == dia) {
          bloquesDia.add({
            'bloque': bloque,
            'materiaNombre': materia.materiaNombre,
            'color': Color(materia.colorARGB ?? 0xFF1E88E5),
          });
        }
      }
    }

    // 2. Mapearlos a Positioned
    return bloquesDia.map((info) {
      final BloqueHorario b = info['bloque'];

      final minInicio = _parseMinutosDesdeInicio(b.horaInicio ?? '07:00');
      final minFin = _parseMinutosDesdeInicio(b.horaFin ?? '09:00');

      final double top = (minInicio / 60.0) * _alturaFranja;
      double height = ((minFin - minInicio) / 60.0) * _alturaFranja;

      if (height <= 0) height = _alturaFranja; // Failsafe mínimo

      return Positioned(
        top: top,
        height: height,
        left: 2,
        right: 2,
        child: Container(
          decoration: BoxDecoration(
            color: info['color'],
            borderRadius: BorderRadius.circular(4),
            boxShadow: modoExportacion
                ? null
                : [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 2,
                      offset: Offset(0, 1),
                    ),
                  ],
          ),
          padding: const EdgeInsets.all(4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                info['materiaNombre'] ?? '',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: modoExportacion ? 11 : 10,
                ),
                maxLines: height < 40 ? 1 : 2,
                overflow: TextOverflow.ellipsis,
              ),
              if ((b.aula?.isNotEmpty ?? false) && height > 35) ...[
                const SizedBox(height: 2),
                Text(
                  'Aula: ${b.aula}',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 255 * 0.9),
                    fontSize: modoExportacion ? 10 : 9,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      );
    }).toList();
  }
}
