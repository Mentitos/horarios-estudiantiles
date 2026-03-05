import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/horario_provider.dart';
import '../../providers/materias_provider.dart';
import '../../providers/perfil_provider.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initApp();
  }

  Future<void> _initApp() async {
    final materiasProvider = context.read<MateriasProvider>();
    final horarioProvider = context.read<HorarioProvider>();
    final perfilProvider = context.read<PerfilProvider>();

    await Future.wait([
      materiasProvider.inicializar(),
      horarioProvider.inicializar(),
      perfilProvider.inicializar(),
    ]);

    if (mounted) {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.school, size: 80, color: Colors.blue),
            SizedBox(height: 24),
            Text(
              'Horarios UNGS',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 48),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
