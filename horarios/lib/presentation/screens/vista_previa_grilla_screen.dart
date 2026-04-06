import 'dart:ui' as ui;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../providers/horario_provider.dart';
import '../../data/models/horario_usuario.dart';

class VistaPreviaGrillaScreen extends StatefulWidget {
  const VistaPreviaGrillaScreen({super.key});

  @override
  State<VistaPreviaGrillaScreen> createState() => _VistaPreviaGrillaScreenState();
}

class _VistaPreviaGrillaScreenState extends State<VistaPreviaGrillaScreen> {
  final GlobalKey _repaintKey = GlobalKey();
  bool _exportando = false;

  static const _diasOrden = [
    'Lunes',
    'Martes',
    'Miércoles',
    'Jueves',
    'Viernes',
    'Sábado',
    'Domingo',
  ];

  Map<String, List<_ClaseInfo>> _agruparPorDia(HorarioUsuario horario) {
    final Map<String, List<_ClaseInfo>> map = {};
    for (final dia in _diasOrden) {
      map[dia] = [];
    }
    for (final materia in horario.materiasSeleccionadas) {
      for (final bloque in materia.bloques) {
        final dia = bloque.dia ?? '';
        if (map.containsKey(dia)) {
          map[dia]!.add(_ClaseInfo(
            nombre: materia.materiaNombre ?? '',
            horaInicio: bloque.horaInicio ?? '',
            horaFin: bloque.horaFin ?? '',
            aula: bloque.aula?.isNotEmpty == true ? bloque.aula! : materia.aula ?? '',
            color: Color(materia.colorARGB ?? 0xFF1565C0),
          ));
        }
      }
    }
    for (final dia in map.keys) {
      map[dia]!.sort((a, b) => a.horaInicio.compareTo(b.horaInicio));
    }
    map.removeWhere((_, clases) => clases.isEmpty);
    return map;
  }

  Future<void> _compartir() async {
    setState(() => _exportando = true);
    try {
      final boundary = _repaintKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      await Future.delayed(const Duration(milliseconds: 200));
      final image = await boundary.toImage(pixelRatio: 4.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData!.buffer.asUint8List();
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/horario_oficial.png');
      await file.writeAsBytes(pngBytes);
      await Share.shareXFiles(
        [XFile(file.path)],
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al exportar: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _exportando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HorarioProvider>();
    final horario = provider.horario;

    if (horario == null) {
      return const Scaffold(backgroundColor: Color(0xFFF3F4F6), body: Center(child: CircularProgressIndicator()));
    }

    final diasConClases = _agruparPorDia(horario);

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        foregroundColor: Colors.black87,
        title: const Text(
          'Exportación de Horario',
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: Center(
                  child: RepaintBoundary(
                    key: _repaintKey,
                    child: _ExportDocument(diasConClases: diasConClases, userName: horario.titulo ?? 'Usuario'),
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
              ),
              child: SafeArea(
                top: false,
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: _exportando ? null : _compartir,
                    icon: _exportando 
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Icon(Icons.print_rounded, size: 20),
                    label: Text(
                      _exportando ? 'Procesando...' : 'Exportar Documento',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0F172A),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExportDocument extends StatelessWidget {
  final Map<String, List<_ClaseInfo>> diasConClases;
  final String userName;

  const _ExportDocument({required this.diasConClases, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 420,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header del documento
          Container(
            padding: const EdgeInsets.all(32.0),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB), width: 1.5)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'HORARIO SEMANAL',
                        style: TextStyle(
                          color: Colors.grey.shade900,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'REPORTE DE CLASES',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 2.0,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: Text(
                    'REF: ${DateTime.now().year}',
                    style: const TextStyle(
                      color: Color(0xFF374151),
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Información del Titular
          Padding(
            padding: const EdgeInsets.fromLTRB(32, 24, 32, 8),
            child: Row(
              children: [
                _InfoBlock(title: 'TITULAR', value: userName),
                const SizedBox(width: 48),
                _InfoBlock(title: 'TOTAL DÍAS', value: '${diasConClases.length} DÍAS'),
              ],
            ),
          ),
          
          // Contenido de Clases
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              children: diasConClases.entries.map((entry) {
                return _MinimalDaySection(dia: entry.key, clases: entry.value);
              }).toList(),
            ),
          ),

          // Footer
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Color(0xFFE5E7EB), width: 1.0)),
              color: Color(0xFFFAFAFA),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'GENERADO: ${DateTime.now().day}/${DateTime.now().month.toString().padLeft(2, '0')}/${DateTime.now().year}',
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.0,
                  ),
                ),
                Text(
                  'SISTEMA DE HORARIOS UNGS',
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoBlock extends StatelessWidget {
  final String title;
  final String value;

  const _InfoBlock({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.grey.shade500,
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value.toUpperCase(),
          style: TextStyle(
            color: Colors.grey.shade900,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}

class _MinimalDaySection extends StatelessWidget {
  final String dia;
  final List<_ClaseInfo> clases;

  const _MinimalDaySection({required this.dia, required this.clases});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: const BoxDecoration(
              color: Color(0xFFF3F4F6),
              border: Border(left: BorderSide(color: Color(0xFF1F2937), width: 3)),
            ),
            child: Text(
              dia.toUpperCase(),
              style: const TextStyle(
                color: Color(0xFF1F2937),
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 12),
          ...clases.map((clase) => _MinimalClaseRow(clase: clase)),
        ],
      ),
    );
  }
}

class _MinimalClaseRow extends StatelessWidget {
  final _ClaseInfo clase;

  const _MinimalClaseRow({required this.clase});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12, left: 4),
      decoration: BoxDecoration(
        color: clase.color.withOpacity(0.05),
        border: Border(left: BorderSide(color: clase.color, width: 4)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Horario
          SizedBox(
            width: 90,
            child: Text(
              '${clase.horaInicio} - ${clase.horaFin}',
              style: TextStyle(
                color: clase.color.computeLuminance() > 0.5 ? Colors.black87 : clase.color.withOpacity(0.9),
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
          
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  clase.nombre,
                  style: const TextStyle(
                    color: Color(0xFF111827),
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.2,
                  ),
                ),
                if (clase.aula.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    'Aula: ${clase.aula}',
                    style: const TextStyle(
                      color: Color(0xFF6B7280),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ClaseInfo {
  final String nombre;
  final String horaInicio;
  final String horaFin;
  final String aula;
  final Color color;

  const _ClaseInfo({
    required this.nombre,
    required this.horaInicio,
    required this.horaFin,
    required this.aula,
    required this.color,
  });
}
