import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:uuid/uuid.dart';

import '../../data/models/evento.dart';
import '../../providers/eventos_provider.dart';
import '../../providers/horario_provider.dart';

class CalendarioEventosScreen extends StatefulWidget {
  const CalendarioEventosScreen({super.key});

  @override
  State<CalendarioEventosScreen> createState() =>
      _CalendarioEventosScreenState();
}

class _CalendarioEventosScreenState extends State<CalendarioEventosScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });
    }
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
                      fecha: _selectedDay ?? _focusedDay,
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
      appBar: AppBar(
        title: const Text('Calendario de Exámenes'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Consumer<EventosProvider>(
        builder: (context, eventosProvider, child) {
          if (eventosProvider.cargando) {
            return const Center(child: CircularProgressIndicator());
          }

          final eventosDelDia = eventosProvider.obtenerEventosParaDia(
            _selectedDay ?? _focusedDay,
          );

          return Column(
            children: [
              TableCalendar<Evento>(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: _onDaySelected,
                eventLoader: (day) =>
                    eventosProvider.obtenerEventosParaDia(day),
                startingDayOfWeek: StartingDayOfWeek.monday,
                calendarStyle: const CalendarStyle(
                  markerDecoration: BoxDecoration(
                    color: Colors.redAccent,
                    shape: BoxShape.circle,
                  ),
                ),
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                ),
              ),
              const SizedBox(height: 8.0),
              Expanded(
                child: ListView.builder(
                  itemCount: eventosDelDia.length,
                  itemBuilder: (context, index) {
                    final evento = eventosDelDia[index];
                    final materiaData = context
                        .read<HorarioProvider>()
                        .horario
                        ?.materiasSeleccionadas
                        .firstWhere((m) => m.materiaId == evento.materiaId);

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
                          icon: const Icon(Icons.delete, color: Colors.red),
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
        child: const Icon(Icons.add),
        tooltip: 'Agregar Examen/TP',
      ),
    );
  }
}
