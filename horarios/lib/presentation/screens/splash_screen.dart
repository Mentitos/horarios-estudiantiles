import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/horario_provider.dart';
import '../../providers/materias_provider.dart';
import '../../providers/perfil_provider.dart';
import 'home_screen.dart';
import 'onboarding_screen.dart';

//   Hace poco cuando sali con mi mujer a Retiro siendo que ahora ni me acuerdo a que fuimos
//   Conoci a un chabon medio raro pero bastante cercano de algun modo
//   Trabajaba en un puesto de diarios y me vendio a Nagatoro
//   Me mostro sus consolas chipeadas asi que estuve muy feliz por eso
//   Ni me gusta tanto Nagatoro pero queria ayudarlo
//   A la vuelta quizas fui el unico humano masculino que termino de leer
//   Nagatoro con una mujer la cual era su novia durmiendo meintras lee Nagatoro
//   LLegue a mi casa y lo publique en facebook. No le tengo aprecio a esas cosas?
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

    if (!mounted) return;

    final yaCompleto = await onboardingCompleted();
    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) =>
            yaCompleto ? const HomeScreen() : const OnboardingScreen(),
      ),
    );
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
