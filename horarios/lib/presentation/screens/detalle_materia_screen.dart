import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/horario_usuario.dart';
import '../../providers/calificaciones_provider.dart';
import '../../providers/horario_provider.dart';
import 'agregar_calificacion_screen.dart';

//  Ayer no pude dormir hasta las 9 de la mañana pq me costaba respirar
//  Pude comprar unas curitas que se ponen en la nariz para abrirla
//  Que bien que dormi dios mio, seguramente compre los internos que duran mas
class DetalleMateriaScreen extends StatefulWidget {
  final MateriaSeleccionada materia;

  const DetalleMateriaScreen({super.key, required this.materia});

  @override
  State<DetalleMateriaScreen> createState() => _DetalleMateriaScreenState();
}

class _DetalleMateriaScreenState extends State<DetalleMateriaScreen> {
  late TextEditingController _notasController;
  Timer? _debounce;
  late HorarioProvider _horarioProvider;
  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    _notasController = TextEditingController(text: '');
    _horarioProvider = context.read<HorarioProvider>();
    _cargarNotasIniciales();
  }

  Future<void> _cargarNotasIniciales() async {
    final notas = await _horarioProvider.obtenerNotasMateria(
      widget.materia.materiaId!,
    );
    if (mounted) {
      if (notas.isNotEmpty) {
        _notasController.text = notas;
      } else {
        _notasController.text = widget.materia.notas ?? '';
      }
    }
  }

  @override
  void dispose() {
    if (_debounce?.isActive ?? false) {
      _debounce!.cancel();
      _horarioProvider.actualizarNotasMateria(
        widget.materia.materiaId!,
        _notasController.text,
      );
    }
    _notasController.dispose();
    super.dispose();
  }

  Future<void> _guardarNotas() async {
    if (!mounted) {
      await _horarioProvider.actualizarNotasMateria(
        widget.materia.materiaId!,
        _notasController.text,
      );
      return;
    }

    setState(() => _guardando = true);
    try {
      await _horarioProvider.actualizarNotasMateria(
        widget.materia.materiaId!,
        _notasController.text,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Notas guardadas correctamente'),
            duration: Duration(seconds: 1),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _guardando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (_debounce?.isActive ?? false) {
          _debounce!.cancel();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.materia.materiaNombre ?? 'Detalle'),
          actions: [
            IconButton(
              icon: const Icon(Icons.check_rounded),
              onPressed: _guardarNotas,
              tooltip: 'Guardar ahora',
            ),
            if (_guardando)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              )
            else
              const Icon(
                Icons.cloud_done_rounded,
                size: 20,
                color: Colors.green,
              ),
            const SizedBox(width: 8),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPromedioCard(context),
              const SizedBox(height: 24),
              Row(
                children: [
                  Icon(Icons.menu_book_rounded, color: colorScheme.primary),
                  const SizedBox(width: 8),
                  Text(
                    'Bibliografía y Notas',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest.withValues(
                    alpha: 0.3,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: colorScheme.outlineVariant),
                ),
                child: TextField(
                  controller: _notasController,
                  maxLines: null,
                  decoration: const InputDecoration(
                    hintText: 'Anotá bibliografía o claves...',
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(height: 1.5),
                  onChanged: (value) {
                    if (_debounce?.isActive ?? false) _debounce!.cancel();
                    _debounce = Timer(const Duration(milliseconds: 500), () {
                      _guardarNotas();
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    AgregarCalificacionScreen(initialMateria: widget.materia),
                fullscreenDialog: true,
              ),
            );
          },
          icon: const Icon(Icons.add_chart_rounded),
          label: const Text('Añadir Calificación'),
        ),
      ),
    );
  }

  Widget _buildPromedioCard(BuildContext context) {
    return Consumer<CalificacionesProvider>(
      builder: (context, provider, child) {
        final notasMateria = provider.calificacionesActivas
            .where((c) => c.materiaId == widget.materia.materiaId)
            .toList();

        final colorScheme = Theme.of(context).colorScheme;

        if (notasMateria.isEmpty) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Center(child: Text('Sin calificaciones registradas')),
          );
        }

        double puntosAcumulados = 0;
        double sumaPesos = 0;
        bool tienePesos = false;

        for (var n in notasMateria) {
          final valor = double.tryParse(n.titulo);
          if (valor != null) {
            if (n.valorPorcentual > 0) {
              puntosAcumulados += (valor * n.valorPorcentual / 100);
              sumaPesos += n.valorPorcentual;
              tienePesos = true;
            }
          }
        }

        double valorPrincipal = puntosAcumulados;
        if (!tienePesos) {
          double sumaSimple = 0;
          int count = 0;
          for (var n in notasMateria) {
            final v = double.tryParse(n.titulo);
            if (v != null) {
              sumaSimple += v;
              count++;
            }
          }
          valorPrincipal = count > 0 ? sumaSimple / count : 0;
        }

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                colorScheme.primaryContainer,
                colorScheme.secondaryContainer,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: colorScheme.primary.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                tienePesos ? 'Puntos Acumulados' : 'Promedio Actual',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onPrimaryContainer.withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                valorPrincipal.toStringAsFixed(2),
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
              if (tienePesos) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.onPrimaryContainer.withValues(
                      alpha: 0.1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Porcentaje usado:',
                            style: TextStyle(
                              color: colorScheme.onPrimaryContainer.withValues(
                                alpha: 0.8,
                              ),
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            '${sumaPesos.toStringAsFixed(0)}%',
                            style: TextStyle(
                              color: colorScheme.onPrimaryContainer,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      _buildInfoPromocion(
                        valorPrincipal,
                        sumaPesos,
                        colorScheme,
                      ),
                    ],
                  ),
                ),
              ] else
                Text(
                  'Basado en tus calificaciones registradas',
                  style: TextStyle(
                    fontSize: 12,
                    color: colorScheme.onPrimaryContainer.withValues(
                      alpha: 0.6,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoPromocion(
    double puntosAct,
    double pesoUsado,
    ColorScheme colors,
  ) {
    if (puntosAct >= 7.0) {
      return Text(
        '¡MATERIA PROMOCIONADA! 🎉',
        style: TextStyle(
          color: colors.onPrimaryContainer,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      );
    }

    final puntosFaltantes = 7.0 - puntosAct;
    final pesoRestante = 100.0 - pesoUsado;

    if (pesoRestante <= 0) {
      return Text(
        'No alcanza para promocionar (Final)',
        style: TextStyle(
          color: colors.onPrimaryContainer.withValues(alpha: 0.8),
          fontSize: 12,
        ),
      );
    }

    final notaNecesaria = (puntosFaltantes * 100) / pesoRestante;

    if (notaNecesaria > 10) {
      return Text(
        'Imposible promocionar (Necesitás ${notaNecesaria.toStringAsFixed(1)})',
        style: TextStyle(
          color: colors.onPrimaryContainer.withValues(alpha: 0.8),
          fontSize: 12,
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Para llegar a 7 necesitás:',
          style: TextStyle(
            color: colors.onPrimaryContainer.withValues(alpha: 0.8),
            fontSize: 13,
          ),
        ),
        Text(
          '${notaNecesaria.toStringAsFixed(1)} en el ${pesoRestante.toStringAsFixed(0)}% restante',
          style: TextStyle(
            color: colors.onPrimaryContainer,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}
