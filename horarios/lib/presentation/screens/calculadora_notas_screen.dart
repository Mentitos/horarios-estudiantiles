import 'package:flutter/material.dart';
import 'dart:ui';

class CalculadoraNotasScreen extends StatefulWidget {
  const CalculadoraNotasScreen({super.key});

  @override
  State<CalculadoraNotasScreen> createState() => _CalculadoraNotasScreenState();
}

class _CalculadoraNotasScreenState extends State<CalculadoraNotasScreen> {
  final List<_NotaInput> _notas = [
    _NotaInput(nombre: 'Examen 1', peso: 40, nota: -1),
    _NotaInput(nombre: 'Examen 2', peso: 60, nota: -1),
  ];

  double _targetGrade = 4.0;
  String _resultado = "";
  Color _resultadoColor = Colors.grey;

  void _calcular() {
    double sumaPuntos = 0;
    double pesoTotal = 0;
    double pesoRestante = 0;

    for (var n in _notas) {
      if (n.nota >= 0) {
        sumaPuntos += (n.nota * n.peso / 100);
        pesoTotal += n.peso;
      } else {
        pesoRestante += n.peso;
      }
    }

    if (pesoRestante == 0) {
      setState(() {
        final promedio = sumaPuntos * (100 / pesoTotal);
        _resultado = "Promedio Final: ${promedio.toStringAsFixed(1)}";
        _resultadoColor = promedio >= _targetGrade ? Colors.green : Colors.red;
      });
      return;
    }

    double necesaria = (_targetGrade - sumaPuntos) * 100 / pesoRestante;

    setState(() {
      if (necesaria <= 0) {
        _resultado = "¡Ya aprobaste! Podes sacarte un 0 y aun así llegas.";
        _resultadoColor = Colors.green;
      } else if (necesaria > 10) {
        _resultado =
            "Imposible. Necesitarías un ${necesaria.toStringAsFixed(1)} para llegar.";
        _resultadoColor = Colors.red;
      } else {
        _resultado =
            "Necesitás un ${necesaria.toStringAsFixed(1)} en lo que falta.";
        _resultadoColor = Theme.of(context).colorScheme.primary;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora de Notas'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildInfoCard(colorScheme, isDark),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Nota objetivo:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              DropdownButton<double>(
                value: _targetGrade,
                items: [4.0, 7.0, 10.0]
                    .map(
                      (v) => DropdownMenuItem(
                        value: v,
                        child: Text(
                          v.toInt().toString(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _targetGrade = val);
                    _calcular();
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),
          ...List.generate(
            _notas.length,
            (i) => _buildNotaItem(i, colorScheme, isDark),
          ),
          const SizedBox(height: 16),
          TextButton.icon(
            onPressed: () {
              setState(() {
                _notas.add(
                  _NotaInput(nombre: 'Nueva Evaluación', peso: 0, nota: -1),
                );
              });
            },
            icon: const Icon(Icons.add_circle_outline),
            label: const Text('Agregar otra nota'),
          ),
          const SizedBox(height: 32),
          if (_resultado.isNotEmpty) _buildResultCard(colorScheme, isDark),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ElevatedButton(
            onPressed: _calcular,
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text(
              'CALCULAR',
              style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(ColorScheme colorScheme, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.secondary.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(Icons.lightbulb_outline, color: colorScheme.secondary),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Ingresá tus notas o dejá el campo vacío si aún no rendiste.',
              style: TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotaItem(int index, ColorScheme colorScheme, bool isDark) {
    final nota = _notas[index];
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Nombre',
                isDense: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              controller: TextEditingController(text: nota.nombre)
                ..selection = TextSelection.fromPosition(
                  TextPosition(offset: nota.nombre.length),
                ),
              onChanged: (val) => nota.nombre = val,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Peso %',
                isDense: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (val) {
                nota.peso = double.tryParse(val) ?? 0;
              },
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Nota',
                isDense: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (val) {
                nota.nota = double.tryParse(val) ?? -1;
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
            onPressed: () {
              setState(() => _notas.removeAt(index));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard(ColorScheme colorScheme, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _resultadoColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _resultadoColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(Icons.auto_awesome, color: _resultadoColor, size: 32),
          const SizedBox(height: 12),
          Text(
            _resultado,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: _resultadoColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _NotaInput {
  String nombre;
  double peso;
  double nota;

  _NotaInput({required this.nombre, required this.peso, required this.nota});
}
