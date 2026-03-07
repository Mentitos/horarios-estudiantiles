import 'package:flutter/material.dart';

//   Detesto la comida rapida, es mala para la salud, para el bolsillo
//   apoya la explotacion de empleados con sueldo minimo, es mala para el medio
//   ambiente y no se me ocurre nada bueno de ella, ni siquiera es rapida
class SistemasCalificacionScreen extends StatelessWidget {
  const SistemasCalificacionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Sistemas de calificación'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Todos los sistemas',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _buildSistemaItem(
            context,
            'Numérico de 0 a 10',
            'Decimales permitidos',
            isSelected: true,
          ),
          const Divider(height: 1, indent: 64),
          _buildSistemaItem(
            context,
            'Numérico de 0 a 12',
            'Decimales permitidos',
          ),
          const Divider(height: 1, indent: 64),
          _buildSistemaItem(
            context,
            'Numérico de 0 a 15',
            'Decimales permitidos',
          ),
          const Divider(height: 1, indent: 64),
          _buildSistemaItem(
            context,
            'Numérico de 0 a 20',
            'Decimales permitidos',
          ),
          const Divider(height: 1, indent: 64),
          _buildSistemaItem(
            context,
            'Numérico de 0 a 30',
            'Decimales permitidos',
          ),
          const Divider(height: 1, indent: 64),
          _buildSistemaItem(
            context,
            'Porcentaje de 0 a 100',
            'Decimales permitidos',
          ),
          const Divider(height: 1, indent: 64),
          _buildSistemaItem(
            context,
            'Numérico de 1 a 6',
            'Decimales permitidos',
          ),
          const Divider(height: 1, indent: 64),
          _buildSistemaItem(
            context,
            'Numérico de 6 a 1',
            'Decimales permitidos',
          ),
          const Divider(height: 1, indent: 64),
          _buildSistemaItem(
            context,
            'Numérico de 0 a 5',
            'Decimales permitidos',
          ),
          const Divider(height: 1, indent: 64),
          _buildSistemaItem(
            context,
            'Numérico de 0 a 7',
            'Decimales permitidos',
          ),
          const Divider(height: 1, indent: 64),
          _buildSistemaItem(
            context,
            'Alfabético de A a F',
            'Decimales permitidos',
          ),
        ],
      ),
    );
  }

  Widget _buildSistemaItem(
    BuildContext context,
    String title,
    String subtitle, {
    bool isSelected = false,
  }) {
    return ListTile(
      leading: Icon(
        Icons.calculate_outlined,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
      ),
      trailing: isSelected
          ? Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(2),
              child: Icon(
                Icons.check,
                size: 16,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            )
          : null,
      onTap: () {
        Navigator.pop(context, title);
      },
    );
  }
}
