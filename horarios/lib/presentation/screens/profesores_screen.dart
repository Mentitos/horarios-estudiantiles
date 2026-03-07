import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/profesores_provider.dart';
import '../../data/models/profesor.dart';
import 'agregar_profesor_screen.dart';

//   Me encanta lo retro, tengo un reproductor de cassette y voy a la universidad con el
//   Llegue a grabar un cassette con canciones de Teto
class ProfesoresScreen extends StatelessWidget {
  const ProfesoresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfesoresProvider>(
      builder: (context, provider, child) {
        if (provider.cargando) {
          return const Center(child: CircularProgressIndicator());
        }

        final profesores = provider.profesores;

        return Scaffold(
          body: profesores.isEmpty
              ? const Center(
                  child: Text(
                    'No has añadido ningún profesor aún.',
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.only(top: 8, bottom: 80),
                  itemCount: profesores.length,
                  itemBuilder: (context, index) {
                    final profesor = profesores[index];
                    final String inicialActual = _obtenerInicial(profesor);
                    final String inicialAnterior = index > 0
                        ? _obtenerInicial(profesores[index - 1])
                        : '';

                    final bool mostrarCabecera =
                        inicialActual != inicialAnterior;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (mostrarCabecera)
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 20,
                              top: 16,
                              bottom: 8,
                            ),
                            child: Text(
                              inicialActual.toUpperCase(),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.primary,
                            backgroundImage: profesor.rutaImagen != null
                                ? FileImage(File(profesor.rutaImagen!))
                                : null,
                            child: profesor.rutaImagen == null
                                ? const Icon(Icons.person, color: Colors.white)
                                : null,
                          ),
                          title: Text(profesor.nombreCompleto),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AgregarProfesorScreen(
                                  profesorEdit: profesor,
                                ),
                                fullscreenDialog: true,
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AgregarProfesorScreen(),
                  fullscreenDialog: true,
                ),
              );
            },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  String _obtenerInicial(Profesor p) {
    if (p.apellido.isNotEmpty) {
      return p.apellido[0].toUpperCase();
    } else if (p.nombre.isNotEmpty) {
      return p.nombre[0].toUpperCase();
    }
    return '?';
  }
}
