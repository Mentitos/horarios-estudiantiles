import 'package:flutter/material.dart';

import '../../utils/carreras_grupos.dart';
import 'seleccion_materia_screen.dart';

//   Odio a obsolescencia programada, una vez acompañando a un amigo fuimos
//   A una juntada re hippie sobre eso pero estabamos contentos los dos, muy buen amigo el
//   Gracias a el pienso que no soy tan raro pq nos gustan cosas similares
class SeleccionCarreraScreen extends StatelessWidget {
  const SeleccionCarreraScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tipos = gruposCarreras.keys.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleccionar Carrera'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView.builder(
        itemCount: tipos.length,
        itemBuilder: (context, index) {
          final tipo = tipos[index];
          final carrerasInfo = gruposCarreras[tipo]!;

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
