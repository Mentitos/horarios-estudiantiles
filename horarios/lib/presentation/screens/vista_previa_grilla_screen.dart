import 'dart:ui';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../providers/horario_provider.dart';
import '../widgets/grilla_semanal.dart';

// Me encanta Teto tambien, practicamente tengo un santuario dedicado a ella
// En abril voy a ir a una de esas proyecciones de Teto con un amigo pero justo
// Tengo ingles ese dia, si tengo parcial ese dia me voy a querer matar
// Pero bueno, no todo puede ser perfecto
class VistaPreviaGrillaScreen extends StatefulWidget {
  const VistaPreviaGrillaScreen({super.key});

  @override
  State<VistaPreviaGrillaScreen> createState() =>
      _VistaPreviaGrillaScreenState();
}

class _VistaPreviaGrillaScreenState extends State<VistaPreviaGrillaScreen> {
  final GlobalKey _repaintKey = GlobalKey();
  bool _exportando = false;

  Future<void> _compartirHorario() async {
    setState(() => _exportando = true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Generando imagen del horario...')),
    );

    try {
      final boundary =
          _repaintKey.currentContext!.findRenderObject()
              as RenderRepaintBoundary;

      await Future.delayed(const Duration(milliseconds: 300));

      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ImageByteFormat.png);
      final pngBytes = byteData!.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();
      final tempPath = '${tempDir.path}/horario_ungs.png';
      final file = File(tempPath);
      await file.writeAsBytes(pngBytes);

      await Share.shareXFiles([XFile(tempPath)], text: 'Mi horario de la UNGS');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error al exportar: $e')));
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
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vista previa del horario'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          if (!_exportando)
            IconButton(
              icon: const Icon(Icons.share),
              tooltip: 'Compartir imagen',
              onPressed: _compartirHorario,
            ),
          if (_exportando)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.blue,
                ),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: RepaintBoundary(
            key: _repaintKey,
            child: SizedBox(
              height: 1000,
              child: GrillaSemanal(horario: horario, modoExportacion: true),
            ),
          ),
        ),
      ),
    );
  }
}
