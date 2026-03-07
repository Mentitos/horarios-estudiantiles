import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/models/profesor.dart';
import '../../providers/profesores_provider.dart';

class AgregarProfesorScreen extends StatefulWidget {
  final Profesor? profesorEdit;

  const AgregarProfesorScreen({super.key, this.profesorEdit});

  @override
  State<AgregarProfesorScreen> createState() => _AgregarProfesorScreenState();
}

class _AgregarProfesorScreenState extends State<AgregarProfesorScreen> {
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _correoController = TextEditingController();
  final _direccionController = TextEditingController();
  final _sitioWebController = TextEditingController();
  String? _rutaImagen;

  @override
  void initState() {
    super.initState();
    if (widget.profesorEdit != null) {
      final p = widget.profesorEdit!;
      _nombreController.text = p.nombre;
      _apellidoController.text = p.apellido;
      _telefonoController.text = p.telefono;
      _correoController.text = p.correo;
      _direccionController.text = p.direccion;
      _sitioWebController.text = p.sitioWeb;
      _rutaImagen = p.rutaImagen;
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidoController.dispose();
    _telefonoController.dispose();
    _correoController.dispose();
    _direccionController.dispose();
    _sitioWebController.dispose();
    super.dispose();
  }

  void _guardarProfesor() {
    if (_nombreController.text.trim().isEmpty &&
        _apellidoController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debes introducir un nombre o apellido')),
      );
      return;
    }

    final data = Profesor(
      id:
          widget.profesorEdit?.id ??
          DateTime.now().microsecondsSinceEpoch.toString(),
      nombre: _nombreController.text.trim(),
      apellido: _apellidoController.text.trim(),
      telefono: _telefonoController.text.trim(),
      correo: _correoController.text.trim(),
      direccion: _direccionController.text.trim(),
      rutaImagen: _rutaImagen,
      sitioWeb: _sitioWebController.text.trim(),
    );

    if (widget.profesorEdit == null) {
      context.read<ProfesoresProvider>().agregarProfesor(data);
    } else {
      context.read<ProfesoresProvider>().actualizarProfesor(data);
    }

    Navigator.pop(context);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Profesor guardado')));
  }

  Future<void> _seleccionarFoto() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _rutaImagen = image.path;
      });
    }
  }

  Widget _buildField({
    required IconData icon,
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 56,
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        Expanded(
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: label,
            ),
          ),
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  Widget _buildNombresField() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 56,
          child: Padding(
            padding: const EdgeInsets.only(top: 14.0),
            child: Icon(
              Icons.person_outline,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Expanded(
          child: Column(
            children: [
              TextField(
                controller: _nombreController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Nombre',
                ),
              ),
              const Divider(height: 1),
              TextField(
                controller: _apellidoController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Apellido',
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: FilledButton(
              onPressed: _guardarProfesor,
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                foregroundColor: Theme.of(
                  context,
                ).colorScheme.onPrimaryContainer,
              ),
              child: const Text('Guardar'),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 32),
            GestureDetector(
              onTap: _seleccionarFoto,
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                backgroundImage: _rutaImagen != null
                    ? FileImage(File(_rutaImagen!))
                    : null,
                child: _rutaImagen == null
                    ? Icon(
                        Icons.camera_alt,
                        size: 40,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 32),
            const Divider(),
            _buildNombresField(),
            const Divider(),
            _buildField(
              icon: Icons.phone_outlined,
              label: 'Teléfono',
              controller: _telefonoController,
              keyboardType: TextInputType.phone,
            ),
            const Divider(),
            _buildField(
              icon: Icons.email_outlined,
              label: 'Correo electrónico',
              controller: _correoController,
              keyboardType: TextInputType.emailAddress,
            ),
            const Divider(),
            _buildField(
              icon: Icons.location_on_outlined,
              label: 'Dirección',
              controller: _direccionController,
            ),
            const Divider(),
            _buildField(
              icon: Icons.public_outlined,
              label: 'Sitio web',
              controller: _sitioWebController,
              keyboardType: TextInputType.url,
            ),
            const Divider(),
            if (widget.profesorEdit != null) ...[
              const SizedBox(height: 32),
              TextButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Eliminar contacto'),
                        content: const Text(
                          '¿Estás seguro de que deseas eliminar a este profesor? Esta acción no se puede deshacer.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context); // Cierra el diálogo
                            },
                            child: const Text('Cancelar'),
                          ),
                          TextButton(
                            onPressed: () {
                              context
                                  .read<ProfesoresProvider>()
                                  .eliminarProfesor(widget.profesorEdit!.id);
                              Navigator.pop(context); // Cierra el diálogo
                              Navigator.pop(
                                context,
                              ); // Cierra la pantalla de edición
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Profesor eliminado'),
                                ),
                              );
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: Theme.of(
                                context,
                              ).colorScheme.error,
                            ),
                            child: const Text('Eliminar'),
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: const Icon(Icons.delete_outline),
                label: const Text('Eliminar contacto'),
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.error,
                ),
              ),
              const SizedBox(height: 32),
            ],
          ],
        ),
      ),
    );
  }
}
