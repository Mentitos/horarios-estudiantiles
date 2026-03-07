import 'package:flutter/material.dart';
import '../../data/models/horario_usuario.dart';

class GrillaSemanal extends StatefulWidget {
  final HorarioUsuario horario;
  final bool modoExportacion;
  final bool mostrarSabado;
  final bool mostrarDomingo;

  const GrillaSemanal({
    super.key,
    required this.horario,
    this.modoExportacion = false,
    this.mostrarSabado = false,
    this.mostrarDomingo = false,
  });

  @override
  State<GrillaSemanal> createState() => _GrillaSemanalState();
}

class _GrillaSemanalState extends State<GrillaSemanal> {
  double _alturaFranja = 52.0;
  static const double _alturaMin = 28.0;
  static const double _alturaMax = 100.0;
  double _alturaBase = 52.0;

  static const int _horaInicio = 0;
  static const int _horaFin = 24;
  static const int _totalFranjas = _horaFin - _horaInicio;

  final ScrollController _verticalScrollController = ScrollController();

  List<String> get _diasSemana {
    final dias = <String>[];
    if (widget.mostrarDomingo) dias.add('Domingo');
    dias.addAll(['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes']);
    if (widget.mostrarSabado) dias.add('Sábado');
    return dias;
  }

  @override
  void dispose() {
    _verticalScrollController.dispose();
    super.dispose();
  }

  String _abreviarDia(String dia) {
    if (dia == 'Miércoles') return 'Mié';
    if (dia == 'Sábado') return 'Sáb';
    if (dia == 'Domingo') return 'Dom';
    return dia.substring(0, 3);
  }

  int _parseMinutos(String horaAAMM) {
    if (horaAAMM.isEmpty) return 0;
    try {
      final partes = horaAAMM.split(':');
      final h = int.parse(partes[0]);
      final m = int.parse(partes[1]);
      return ((h - _horaInicio) * 60) + m;
    } catch (_) {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.modoExportacion
        ? ThemeData.light().copyWith(
            scaffoldBackgroundColor: Colors.white,
            cardTheme: const CardThemeData(
              elevation: 0,
              margin: EdgeInsets.zero,
              color: Colors.white,
            ),
          )
        : Theme.of(context);

    final bgColor = widget.modoExportacion
        ? Colors.white
        : theme.scaffoldBackgroundColor;
    final borderColor = widget.modoExportacion
        ? Colors.grey[300]!
        : theme.dividerColor;
    final textColor = widget.modoExportacion
        ? Colors.black87
        : theme.textTheme.bodyMedium?.color ?? Colors.black;

    return LayoutBuilder(
      builder: (context, constraints) {
        const double horasColWidth = 60.0;
        final int numDias = _diasSemana.length;
        final double dayWidth =
            (constraints.maxWidth - horasColWidth) / numDias;

        return Container(
          color: bgColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (widget.modoExportacion)
                Padding(
                  padding: const EdgeInsets.only(top: 24, bottom: 16),
                  child: Text(
                    widget.horario.titulo ?? 'Mi Horario',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),

              Row(
                children: [
                  SizedBox(width: horasColWidth),
                  ...List.generate(_diasSemana.length, (i) {
                    return Container(
                      width: dayWidth,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: borderColor),
                          left: BorderSide(color: borderColor),
                        ),
                      ),
                      child: Text(
                        _abreviarDia(_diasSemana[i]),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: textColor,
                          fontSize: widget.modoExportacion ? 14 : 13,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }),
                ],
              ),

              Expanded(
                child: GestureDetector(
                  onScaleStart: (_) {
                    _alturaBase = _alturaFranja;
                  },
                  onScaleUpdate: (details) {
                    if (details.pointerCount < 2) return;
                    final nueva = (_alturaBase * details.verticalScale).clamp(
                      _alturaMin,
                      _alturaMax,
                    );
                    setState(() => _alturaFranja = nueva);
                  },
                  child: SingleChildScrollView(
                    controller: _verticalScrollController,
                    physics: widget.modoExportacion
                        ? const NeverScrollableScrollPhysics()
                        : const AlwaysScrollableScrollPhysics(),
                    child: SizedBox(
                      height: _totalFranjas * _alturaFranja,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                            width: horasColWidth,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: List.generate(_totalFranjas + 1, (
                                index,
                              ) {
                                if (index == _totalFranjas || index == 0) {
                                  return const SizedBox.shrink();
                                }
                                final hora = _horaInicio + index;
                                final label =
                                    '${hora.toString().padLeft(2, '0')}:00';
                                return Positioned(
                                  top: index * _alturaFranja,
                                  left: 0,
                                  right: 0,
                                  child: Transform.translate(
                                    offset: const Offset(0, -8),
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: Text(
                                        label,
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: textColor.withValues(
                                            alpha: 0.7,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),

                          ...List.generate(_diasSemana.length, (i) {
                            final dia = _diasSemana[i];
                            return Container(
                              width: dayWidth,
                              decoration: BoxDecoration(
                                border: Border(
                                  left: BorderSide(color: borderColor),
                                ),
                              ),
                              child: Stack(
                                clipBehavior: Clip.hardEdge,
                                children: [
                                  ...List.generate(_totalFranjas, (idx) {
                                    return Positioned(
                                      top: (idx + 1) * _alturaFranja,
                                      left: 0,
                                      right: 0,
                                      child: Container(
                                        height: 1,
                                        color: borderColor.withValues(
                                          alpha: 0.5,
                                        ),
                                      ),
                                    );
                                  }),
                                  ..._buildBloquesDelDia(
                                    dia,
                                    widget.horario.materiasSeleccionadas,
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildBloquesDelDia(
    String dia,
    List<MateriaSeleccionada> materias,
  ) {
    final List<Map<String, dynamic>> bloquesDia = [];

    for (final materia in materias) {
      for (final bloque in materia.bloques) {
        if (bloque.dia == dia) {
          bloquesDia.add({
            'bloque': bloque,
            'materiaNombre': materia.materiaNombre,
            'color': Color(materia.colorARGB ?? 0xFF1E88E5),
          });
        }
      }
    }

    return bloquesDia.map((info) {
      final BloqueHorario b = info['bloque'] as BloqueHorario;
      final minInicio = _parseMinutos(b.horaInicio ?? '07:00');
      final minFin = _parseMinutos(b.horaFin ?? '09:00');
      final double top = (minInicio / 60.0) * _alturaFranja;
      double height = ((minFin - minInicio) / 60.0) * _alturaFranja;
      if (height <= 0) height = _alturaFranja;

      return Positioned(
        top: top,
        height: height,
        left: 2,
        right: 2,
        child: Container(
          decoration: BoxDecoration(
            color: info['color'] as Color,
            borderRadius: BorderRadius.circular(4),
            boxShadow: widget.modoExportacion
                ? null
                : const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 3,
                      offset: Offset(1, 2),
                    ),
                  ],
          ),
          padding: const EdgeInsets.all(4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  info['materiaNombre'] as String? ?? '',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: widget.modoExportacion ? 14 : 13,
                    height: 1.2,
                  ),
                  overflow: TextOverflow.fade,
                ),
              ),
              if ((b.aula?.isNotEmpty ?? false) && height > 44)
                Text(
                  'Aula: ${b.aula}',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 11,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),
      );
    }).toList();
  }
}
