import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/calificaciones_provider.dart';
import '../../providers/horario_provider.dart';
import 'agregar_calificacion_screen.dart';
import 'detalle_calificacion_screen.dart';
import 'detalle_materia_screen.dart';

//   No entiendo la monopolizacion de los diseños de ui
//   Espero haberlo hecho lo suficientemente distinto, obviamente me base en
//   Mi agenda estudiantil o algo asi era pero dios mio tiene anuncios cada
//   3 segundos, que feo
class CalificacionesScreen extends StatefulWidget {
  final int initialIndex;
  const CalificacionesScreen({super.key, this.initialIndex = 0});

  @override
  State<CalificacionesScreen> createState() => _CalificacionesScreenState();
}

class _CalificacionesScreenState extends State<CalificacionesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _showFab = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialIndex,
    );
    _tabController.addListener(_handleTabSelection);
    _showFab = _tabController.index == 0;
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) return;
    setState(() {
      _showFab = _tabController.index == 0;
    });
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Clasificaciones'),
            Tab(text: 'Materias'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCalificacionesTab(context),
          _buildMateriasTab(context),
        ],
      ),
      floatingActionButton: _showFab
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AgregarCalificacionScreen(),
                    fullscreenDialog: true,
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Agregar'),
            )
          : null,
    );
  }

  Widget _buildCalificacionesTab(BuildContext context) {
    return Consumer<CalificacionesProvider>(
      builder: (context, provider, child) {
        if (provider.cargando) {
          return const Center(child: CircularProgressIndicator());
        }

        final notas = provider.calificacionesActivas;

        if (notas.isEmpty) return _buildEmptyState(context);

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: notas.length,
          itemBuilder: (ctx, i) {
            final nota = notas[i];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              elevation: 0,
              color: Theme.of(
                context,
              ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.emoji_events,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
                title: Text(
                  nota.nombreMateria,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Text(
                  '${nota.tipoEvaluacion} • ${nota.valorPorcentual > 0 ? nota.valorPorcentual : 0}%',
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      nota.titulo,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    if (provider.modoArchivadoVisible) ...[
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.inventory_2_outlined),
                        onPressed: () {
                          provider.toggleArchivar(nota.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Calificación archivada'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        tooltip: 'Archivar',
                      ),
                    ],
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          DetalleCalificacionScreen(calificacionId: nota.id),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildMateriasTab(BuildContext context) {
    return Consumer2<HorarioProvider, CalificacionesProvider>(
      builder: (context, horarioProv, califProv, child) {
        final materias = horarioProv.horario?.materiasSeleccionadas ?? [];

        if (materias.isEmpty) {
          return const Center(
            child: Text('Cargá materias en tu horario para verlas aquí'),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: materias.length,
          itemBuilder: (context, index) {
            final materia = materias[index];
            final color = Color(materia.colorARGB ?? 0xFF000000);

            final notasMateria = califProv.calificacionesActivas
                .where((c) => c.materiaId == materia.materiaId)
                .toList();

            double promedio = 0;
            if (notasMateria.isNotEmpty) {
              double sumaPuntosPonderados = 0;
              double sumaPesos = 0;
              double sumaSimple = 0;
              int countSimple = 0;

              for (var n in notasMateria) {
                final valor = double.tryParse(n.titulo);
                if (valor != null) {
                  if (n.valorPorcentual > 0) {
                    sumaPuntosPonderados += (valor * n.valorPorcentual / 100);
                    sumaPesos += n.valorPorcentual;
                  } else {
                    sumaSimple += valor;
                    countSimple++;
                  }
                }
              }

              if (sumaPesos > 0) {
                promedio = sumaPuntosPonderados;
              } else if (countSimple > 0) {
                promedio = sumaSimple / countSimple;
              }
            }

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: Container(
                  width: 12,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                title: Text(
                  materia.materiaNombre ?? 'Materia',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  notasMateria.isEmpty
                      ? 'Sin calificaciones'
                      : '${notasMateria.length} calificaciones registradas',
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      promedio > 0 ? promedio.toStringAsFixed(1) : '--',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const Text('Promedio', style: TextStyle(fontSize: 10)),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DetalleMateriaScreen(materia: materia),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(48),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.mark_email_unread_rounded,
              size: 80,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            'Sin calificaciones',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Las notas que añadas\naparecerán aquí',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}
