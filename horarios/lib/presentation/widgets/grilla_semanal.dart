import 'package:flutter/material.dart';
import '../../data/models/horario_usuario.dart';

class GrillaSemanal extends StatefulWidget {
  final HorarioUsuario horario;
  final bool modoExportacion;

  const GrillaSemanal({
    super.key,
    required this.horario,
    this.modoExportacion = false,
  });

  @override
  State<GrillaSemanal> createState() => _GrillaSemanalState();
}

class _GrillaSemanalState extends State<GrillaSemanal> {
  static const double _alturaFranja = 52.0;
  static const int _horaInicio = 0;
  static const int _horaFin = 24;
  static const int _totalFranjas = _horaFin - _horaInicio;

  static const List<String> _diasSemana = [
    'Domingo',
    'Lunes',
    'Martes',
    'Miércoles',
    'Jueves',
    'Viernes',
    'Sábado',
  ];

  final ScrollController _headerScrollController = ScrollController();
  final ScrollController _bodyScrollController = ScrollController();
  final ScrollController _verticalScrollController = ScrollController();

  bool _isSyncing = false;

  @override
  void initState() {
    super.initState();
    _headerScrollController.addListener(() {
      if (_isSyncing) return;
      if (_headerScrollController.hasClients &&
          _bodyScrollController.hasClients) {
        if (_headerScrollController.offset != _bodyScrollController.offset) {
          _isSyncing = true;
          _bodyScrollController.jumpTo(_headerScrollController.offset);
          _isSyncing = false;
        }
      }
    });
    _bodyScrollController.addListener(() {
      if (_isSyncing) return;
      if (_headerScrollController.hasClients &&
          _bodyScrollController.hasClients) {
        if (_bodyScrollController.offset != _headerScrollController.offset) {
          _isSyncing = true;
          _headerScrollController.jumpTo(_bodyScrollController.offset);
          _isSyncing = false;
        }
      }
    });
  }

  @override
  void dispose() {
    _headerScrollController.dispose();
    _bodyScrollController.dispose();
    _verticalScrollController.dispose();
    super.dispose();
  }

  String _abreviarDia(String dia) {
    if (dia == 'Miércoles') return 'Mié';
    if (dia == 'Sábado') return 'Sáb';
    return dia.substring(0, 3);
  }

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
    final ThemeData theme = widget.modoExportacion
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
        final double minDayWidth = 100.0;
        final double totalDaysWidth = _diasSemana.length * minDayWidth;
        final double availableWidth = constraints.maxWidth - 60;
        final bool shouldScrollHorizontally = availableWidth < totalDaysWidth;

        final double dayWidth = shouldScrollHorizontally
            ? minDayWidth
            : availableWidth / _diasSemana.length;

        return Container(
          color: bgColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (widget.modoExportacion)
                Padding(
                  padding: const EdgeInsets.only(top: 24.0, bottom: 16.0),
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
                  const SizedBox(width: 60),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      controller: _headerScrollController,
                      physics: const NeverScrollableScrollPhysics(),
                      child: Row(
                        children: _diasSemana.map((dia) {
                          return Container(
                            width: dayWidth,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: borderColor),
                                left: BorderSide(color: borderColor),
                              ),
                            ),
                            child: Text(
                              _abreviarDia(dia),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: textColor,
                                fontSize: widget.modoExportacion ? 14 : 13,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),

              Expanded(
                child: SingleChildScrollView(
                  controller: _verticalScrollController,
                  physics: widget.modoExportacion
                      ? const NeverScrollableScrollPhysics()
                      : const AlwaysScrollableScrollPhysics(),
                  child: SizedBox(
                    height: (_totalFranjas + 1) * _alturaFranja,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          width: 60,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: List.generate(_totalFranjas + 1, (index) {
                              if (index == _totalFranjas)
                                return const SizedBox.shrink();

                              final horaStr =
                                  '${(_horaInicio + index).toString().padLeft(2, '0')}:00';
                              return Positioned(
                                top: index * _alturaFranja,
                                left: 0,
                                right: 0,
                                child: Transform.translate(
                                  offset: const Offset(0, -8),
                                  child: Container(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: Text(
                                      horaStr,
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: textColor.withValues(alpha: 0.7),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),

                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            controller: _bodyScrollController,
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: Row(
                              children: _diasSemana.map((dia) {
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
                                      ...List.generate(
                                        _totalFranjas,
                                        (index) => Positioned(
                                          top: (index + 1) * _alturaFranja,
                                          left: 0,
                                          right: 0,
                                          child: Container(
                                            height: 1,
                                            color: borderColor.withValues(
                                              alpha: 0.5,
                                            ),
                                          ),
                                        ),
                                      ),

                                      ..._buildBloquesDelDia(
                                        dia,
                                        widget.horario.materiasSeleccionadas,
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
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
      },
    );
  }

  List<Widget> _buildBloquesDelDia(
    String dia,
    List<MateriaSeleccionada> materias,
  ) {
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

    return bloquesDia.map((info) {
      final BloqueHorario b = info['bloque'];

      final minInicio = _parseMinutosDesdeInicio(b.horaInicio ?? '07:00');
      final minFin = _parseMinutosDesdeInicio(b.horaFin ?? '09:00');

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
            color: info['color'],
            borderRadius: BorderRadius.circular(4),
            boxShadow: widget.modoExportacion
                ? null
                : [
                    const BoxShadow(
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
              Text(
                info['materiaNombre'] ?? '',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: widget.modoExportacion ? 11 : 10,
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
                    fontSize: widget.modoExportacion ? 10 : 9,
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
