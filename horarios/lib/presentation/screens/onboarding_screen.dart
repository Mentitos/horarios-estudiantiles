import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../providers/perfil_provider.dart';
import '../../providers/materias_provider.dart';
import '../../utils/carreras_grupos.dart';
import 'home_screen.dart';

const String _kOnboardingDone = 'onboarding_done';

Future<bool> onboardingCompleted() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool(_kOnboardingDone) ?? false;
}

Future<void> markOnboardingDone() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool(_kOnboardingDone, true);
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final List<String> _carrerasSeleccionadas = [];

  void _nextPage() {
    if (_currentPage < 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      _finish();
    }
  }

  void _finish() async {
    await markOnboardingDone();
    if (mounted) {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  for (int i = 0; i < 2; i++) ...[
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: _currentPage == i ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _currentPage == i
                            ? colorScheme.primary
                            : colorScheme.primary.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    if (i < 1) const SizedBox(width: 6),
                  ],
                ],
              ),
            ),

            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (i) => setState(() => _currentPage = i),
                children: [
                  _PaginaCarrera(
                    seleccionadas: _carrerasSeleccionadas,
                    onChanged: (lista) => setState(() {
                      _carrerasSeleccionadas
                        ..clear()
                        ..addAll(lista);
                    }),
                  ),
                  _PaginaAprobadas(carreras: _carrerasSeleccionadas),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: Row(
                children: [
                  TextButton(
                    onPressed: _finish,
                    child: Text(
                      'Omitir',
                      style: TextStyle(
                        color: colorScheme.onSurface.withOpacity(0.5),
                      ),
                    ),
                  ),
                  const Spacer(),
                  FilledButton(
                    onPressed: () async {
                      if (_currentPage == 0 &&
                          _carrerasSeleccionadas.isNotEmpty) {
                        await context.read<PerfilProvider>().setCarreras(
                          List.from(_carrerasSeleccionadas),
                        );
                      }
                      _nextPage();
                    },
                    child: Text(_currentPage == 1 ? 'Finalizar' : 'Continuar'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PaginaCarrera extends StatefulWidget {
  final List<String> seleccionadas;
  final void Function(List<String>) onChanged;
  const _PaginaCarrera({required this.seleccionadas, required this.onChanged});

  @override
  State<_PaginaCarrera> createState() => _PaginaCarreraState();
}

class _PaginaCarreraState extends State<_PaginaCarrera> {
  late List<String> _selected;

  @override
  void initState() {
    super.initState();
    _selected = List.from(widget.seleccionadas);
  }

  void _toggle(String carrera) {
    setState(() {
      if (_selected.contains(carrera)) {
        _selected.remove(carrera);
      } else {
        if (_selected.length >= 2) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Máximo 2 carreras')));
          return;
        }
        _selected.add(carrera);
      }
    });
    widget.onChanged(_selected);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.school_rounded,
                size: 48,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 16),
              const Text(
                '¿Qué carrera cursás?',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                'Podés elegir hasta 2 carreras.',
                style: TextStyle(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),

        Expanded(
          child: ListView(
            children: gruposCarreras.entries.map((entry) {
              return _GrupoCarrera(
                titulo: entry.key,
                carreras: entry.value,
                seleccionadas: _selected,
                onToggle: _toggle,
                initiallyExpanded: _selected.any(
                  (s) => entry.value.contains(s),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _GrupoCarrera extends StatefulWidget {
  final String titulo;
  final List<String> carreras;
  final List<String> seleccionadas;
  final void Function(String) onToggle;
  final bool initiallyExpanded;

  const _GrupoCarrera({
    required this.titulo,
    required this.carreras,
    required this.seleccionadas,
    required this.onToggle,
    required this.initiallyExpanded,
  });

  @override
  State<_GrupoCarrera> createState() => _GrupoCarreraState();
}

class _GrupoCarreraState extends State<_GrupoCarrera>
    with SingleTickerProviderStateMixin {
  late bool _expandido;
  late AnimationController _ctrl;
  late Animation<double> _rotacion;

  @override
  void initState() {
    super.initState();
    _expandido = widget.initiallyExpanded;
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      value: _expandido ? 1.0 : 0.0,
    );
    _rotacion = Tween<double>(
      begin: 0,
      end: 0.5,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _toggleExpand() {
    setState(() {
      _expandido = !_expandido;
      _expandido ? _ctrl.forward() : _ctrl.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InkWell(
          onTap: _toggleExpand,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 14),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.titulo,
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                RotationTransition(
                  turns: _rotacion,
                  child: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ),

        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          child: _expandido
              ? Column(
                  children: widget.carreras.map((c) {
                    final sel = widget.seleccionadas.contains(c);
                    return InkWell(
                      onTap: () => widget.onToggle(c),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 64,
                          vertical: 4,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                c,
                                style: textTheme.bodyMedium?.copyWith(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 24,
                              height: 24,
                              child: Checkbox(
                                value: sel,
                                onChanged: (_) => widget.onToggle(c),
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                visualDensity: VisualDensity.compact,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}

class _PaginaAprobadas extends StatelessWidget {
  final List<String> carreras;
  const _PaginaAprobadas({required this.carreras});

  @override
  Widget build(BuildContext context) {
    if (carreras.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Icon(
              Icons.check_circle_outline_rounded,
              size: 48,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            const Text(
              'Materias aprobadas',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Omitiste la selección de carrera. Podés configurar las materias aprobadas desde Ajustes.',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Icon(
            Icons.check_circle_outline_rounded,
            size: 48,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 16),
          const Text(
            'Materias aprobadas',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'Marcá las que ya cursaste. Podés cambiar esto después en Ajustes.',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: DefaultTabController(
              length: carreras.length,
              child: Column(
                children: [
                  if (carreras.length > 1)
                    TabBar(
                      tabs: carreras
                          .map((c) => Tab(text: c.split(' ').last))
                          .toList(),
                    ),
                  Expanded(
                    child: TabBarView(
                      children: carreras
                          .map(
                            (c) => _ListaAprobadasOnboarding(nombreCarrera: c),
                          )
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ListaAprobadasOnboarding extends StatefulWidget {
  final String nombreCarrera;
  const _ListaAprobadasOnboarding({required this.nombreCarrera});

  @override
  State<_ListaAprobadasOnboarding> createState() =>
      _ListaAprobadasOnboardingState();
}

class _ListaAprobadasOnboardingState extends State<_ListaAprobadasOnboarding> {
  late Future<List<dynamic>> _futureMaterias;

  @override
  void initState() {
    super.initState();
    _futureMaterias = context.read<MateriasProvider>().getMateriasDeCarrera(
      widget.nombreCarrera,
    );
  }

  @override
  Widget build(BuildContext context) {
    final perfilProvider = context.watch<PerfilProvider>();
    return FutureBuilder<List<dynamic>>(
      future: _futureMaterias,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final materias = snapshot.data!;
        return ListView.builder(
          itemCount: materias.length,
          itemBuilder: (context, i) {
            final item = materias[i];
            final id = (item as dynamic).materiaId as String?;
            if (id == null) return const SizedBox.shrink();
            final aprobada = perfilProvider.estaAprobada(id);
            return CheckboxListTile(
              title: Text(
                item.nombre ?? '',
                style: TextStyle(
                  fontSize: 16,
                  decoration: aprobada ? TextDecoration.lineThrough : null,
                  color: aprobada ? Colors.grey : null,
                ),
              ),
              value: aprobada,
              onChanged: (_) => perfilProvider.toggleMateriaAprobada(id),
            );
          },
        );
      },
    );
  }
}
