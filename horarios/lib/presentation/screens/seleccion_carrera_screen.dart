import 'package:flutter/material.dart';
import 'seleccion_materia_screen.dart';

class SeleccionCarreraScreen extends StatelessWidget {
  const SeleccionCarreraScreen({super.key});

  final Map<String, List<String>> grupos = const {
    'Ingeniería': ['Electromecanica', 'Industrial', 'Quimica'],
    'Licenciatura': [
      'Administracion De Empresas',
      'Administracion Publica',
      'Comunicaciones',
      'Cultura Y Lenguajes Artisticos',
      'Ecologia',
      'Economia Industrial',
      'Economia Politica',
      'Educacion',
      'Estudios Politicos',
      'Politica Social',
      'Sistemas',
      'Urbanismos',
    ],
    'Profesorado': [
      'Filosofia',
      'Fisica',
      'Geografia',
      'Historia',
      'Literatura',
      'Matematica',
      'Prof Economia',
    ],
    'Tecnicatura': [
      'Automatizacion Y Control',
      'Informatica',
      'Sist. De Info. Geografica',
      'Tec. Quimica',
    ],
  };

  @override
  Widget build(BuildContext context) {
    final tipos = grupos.keys.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleccionar Carrera'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView.builder(
        itemCount: tipos.length,
        itemBuilder: (context, index) {
          final tipo = tipos[index];
          final carrerasInfo = grupos[tipo]!;

          return ExpansionTile(
            title: Text(
              tipo,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            children: carrerasInfo.map((nombreCarrera) {
              return ListTile(
                title: Text(nombreCarrera),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) =>
                          SeleccionMateriaScreen(nombreCarrera: nombreCarrera),
                    ),
                  );
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
