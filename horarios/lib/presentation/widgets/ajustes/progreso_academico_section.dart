import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/perfil_provider.dart';
import '../../../providers/materias_provider.dart';
import '../../screens/materias_aprobadas_screen.dart';
import '../../screens/gestionar_materias_locales_screen.dart' as file_gestionar;

class ProgresoAcademicoSection extends StatelessWidget {
  const ProgresoAcademicoSection({super.key});

  @override
  Widget build(BuildContext context) {
    final perfilProvider = context.watch<PerfilProvider>();

    if (perfilProvider.esAlumnoExterno ||
        perfilProvider.carrerasSeleccionadas.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Progreso académico',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ...perfilProvider.carrerasSeleccionadas.map((nombreCarrera) {
                  return FutureBuilder(
                    future: context
                        .read<MateriasProvider>()
                        .getMateriasDeCarrera(nombreCarrera),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const LinearProgressIndicator();
                      }

                      final materiasMixtas = snapshot.data as List<dynamic>;
                      int aprobadasCount = 0;
                      int totalMaterias = 0;

                      for (var item in materiasMixtas) {
                        if (item is List) {
                          totalMaterias++;
                          bool estaAprobada = item.any(
                            (m) => perfilProvider.estaAprobada(m.materiaId),
                          );
                          if (estaAprobada) aprobadasCount++;
                        } else {
                          totalMaterias++;
                          if (perfilProvider.estaAprobada(item.materiaId)) {
                            aprobadasCount++;
                          }
                        }
                      }

                      final percentDouble = totalMaterias > 0
                          ? (aprobadasCount / totalMaterias)
                          : 0.0;
                      final percentageText = (percentDouble * 100)
                          .toStringAsFixed(1);

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            nombreCarrera,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: percentDouble,
                            minHeight: 12,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '$aprobadasCount / $totalMaterias aprobadas ($percentageText%)',
                          ),
                          const SizedBox(height: 16),
                        ],
                      );
                    },
                  );
                }),
                ElevatedButton.icon(
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text('Materias aprobadas'),
                  onPressed: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const MateriasAprobadasScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  icon: const Icon(Icons.edit_note),
                  label: const Text('Gestionar materias'),
                  onPressed: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>
                            const file_gestionar.GestionarMateriasLocalesScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
