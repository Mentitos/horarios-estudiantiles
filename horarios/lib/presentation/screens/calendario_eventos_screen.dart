import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../data/models/evento.dart';
import '../../providers/eventos_provider.dart';
import '../../providers/horario_provider.dart';

//  No tengo dialogo interno y cuando hablo en ingles siento que seria util?
class CalendarioEventosScreen extends StatefulWidget {
  const CalendarioEventosScreen({super.key});

  @override
  State<CalendarioEventosScreen> createState() =>
      CalendarioEventosScreenState();
}

class CalendarioEventosScreenState extends State<CalendarioEventosScreen> {
  DateTime _focusedMonth = DateTime(DateTime.now().year, DateTime.now().month);
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
  }

  void irAHoy() {
    setState(() {
      final now = DateTime.now();
      _focusedMonth = DateTime(now.year, now.month);
      _selectedDay = now;
    });
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  List<DateTime> _daysInMonth(DateTime month) {
    final last = DateTime(month.year, month.month + 1, 0);
    return List.generate(
      last.day,
      (i) => DateTime(month.year, month.month, i + 1),
    );
  }

  Future<void> _mostrarDialogoAgregarEvento(BuildContext context) async {
    final horarioProvider = context.read<HorarioProvider>();
    final materias = horarioProvider.horario?.materiasSeleccionadas ?? [];

    if (materias.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Configura tus materias primero en Gestor de Clases.'),
        ),
      );
      return;
    }

    String titulo = '';
    String tipo = 'Examen';
    String materiaId = materias.first.materiaId!;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text('Nuevo Evento'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      decoration: const InputDecoration(labelText: 'Título'),
                      onChanged: (val) => titulo = val,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: tipo,
                      decoration: const InputDecoration(labelText: 'Tipo'),
                      items: ['Examen', 'Parcial', 'TP', 'Final', 'Otro']
                          .map(
                            (t) => DropdownMenuItem(value: t, child: Text(t)),
                          )
                          .toList(),
                      onChanged: (val) {
                        if (val != null) setStateDialog(() => tipo = val);
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: materiaId,
                      decoration: const InputDecoration(labelText: 'Materia'),
                      items: materias.map((m) {
                        return DropdownMenuItem(
                          value: m.materiaId,
                          child: Text(m.materiaNombre ?? 'Desconocida'),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setStateDialog(() => materiaId = val);
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (titulo.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('El título es requerido')),
                      );
                      return;
                    }

                    final nuevoEvento = Evento(
                      id: const Uuid().v4(),
                      titulo: titulo,
                      fecha: _selectedDay ?? _focusedMonth,
                      materiaId: materiaId,
                      tipo: tipo,
                    );

                    context.read<EventosProvider>().agregarEvento(nuevoEvento);
                    Navigator.of(context).pop();
                  },
                  child: const Text('Guardar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<EventosProvider>(
        builder: (context, eventosProvider, child) {
          if (eventosProvider.cargando) {
            return const Center(child: CircularProgressIndicator());
          }

          final dias = _daysInMonth(_focusedMonth);
          final primerDia = dias.first;

          final offset = (primerDia.weekday - 1) % 7;

          final eventosDelDia = _selectedDay != null
              ? eventosProvider.obtenerEventosParaDia(_selectedDay!)
              : <Evento>[];

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.chevron_left),
                          onPressed: () => setState(() {
                            _focusedMonth = DateTime(
                              _focusedMonth.year,
                              _focusedMonth.month - 1,
                            );
                          }),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.chevron_right),
                              onPressed: () => setState(() {
                                _focusedMonth = DateTime(
                                  _focusedMonth.year,
                                  _focusedMonth.month + 1,
                                );
                              }),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Text(
                      _monthLabel(_focusedMonth),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    _DowLabel('L'),
                    _DowLabel('M'),
                    _DowLabel('Mi'),
                    _DowLabel('J'),
                    _DowLabel('V'),
                    _DowLabel('S'),
                    _DowLabel('D'),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    childAspectRatio: 1,
                  ),
                  itemCount: offset + dias.length,
                  itemBuilder: (context, i) {
                    if (i < offset) return const SizedBox();
                    final day = dias[i - offset];
                    final isSelected =
                        _selectedDay != null && _isSameDay(day, _selectedDay!);
                    final isToday = _isSameDay(day, DateTime.now());
                    final hasEvent = eventosProvider
                        .obtenerEventosParaDia(day)
                        .isNotEmpty;
                    final colorScheme = Theme.of(context).colorScheme;

                    return GestureDetector(
                      onTap: () => setState(() => _selectedDay = day),
                      child: Container(
                        margin: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? colorScheme.primary
                              : isToday
                              ? colorScheme.primaryContainer
                              : null,
                          shape: BoxShape.circle,
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Text(
                              '${day.day}',
                              style: TextStyle(
                                color: isSelected
                                    ? colorScheme.onPrimary
                                    : isToday
                                    ? colorScheme.onPrimaryContainer
                                    : null,
                                fontWeight: isToday || isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                            if (hasEvent)
                              Positioned(
                                bottom: 4,
                                child: Container(
                                  width: 5,
                                  height: 5,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? colorScheme.onPrimary
                                        : colorScheme.error,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const Divider(),

              Expanded(
                child: eventosDelDia.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.calendar_today_outlined,
                              size: 48,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withOpacity(0.3),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Sin eventos',
                              style: TextStyle(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withOpacity(0.5),
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: eventosDelDia.length,
                        itemBuilder: (context, index) {
                          final evento = eventosDelDia[index];
                          final materiaData = context
                              .read<HorarioProvider>()
                              .horario
                              ?.materiasSeleccionadas
                              .firstWhere(
                                (m) => m.materiaId == evento.materiaId,
                                orElse: () => throw Exception(),
                              );

                          final Color mColor = materiaData != null
                              ? Color(materiaData.colorARGB ?? 0xFF000000)
                              : Colors.grey;

                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 4.0,
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: mColor,
                                child: Icon(
                                  evento.tipo == 'TP'
                                      ? Icons.assignment
                                      : Icons.assignment_late,
                                  color: mColor.computeLuminance() > 0.5
                                      ? Colors.black
                                      : Colors.white,
                                ),
                              ),
                              title: Text(evento.titulo),
                              subtitle: Text(
                                '${evento.tipo} - ${materiaData?.materiaNombre ?? ''}',
                              ),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  eventosProvider.eliminarEvento(evento.id);
                                },
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _mostrarDialogoAgregarEvento(context),
        tooltip: 'Agregar Examen/TP',
        child: const Icon(Icons.add),
      ),
    );
  }

  String _monthLabel(DateTime d) {
    const months = [
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre',
    ];
    return '${months[d.month - 1]} ${d.year}';
  }
}

class _DowLabel extends StatelessWidget {
  final String text;
  const _DowLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      ),
    );
  }
}
