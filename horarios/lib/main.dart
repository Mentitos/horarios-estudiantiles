import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'providers/horario_provider.dart';
import 'providers/materias_provider.dart';
import 'providers/perfil_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/eventos_provider.dart';
import 'providers/calificaciones_provider.dart';
import 'providers/profesores_provider.dart';
import 'providers/grabaciones_provider.dart';
import 'data/sources/local_datasource.dart';
import 'data/repositories/horario_repository.dart';
import 'presentation/screens/splash_screen.dart';

//  Me gusta mucho mi mujer, si bien este proyecto esta ampliamente
//  Vinculado con la UNGS me gustaria poder expandirlo a su universidad
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('es', null);

  final localDatasource = LocalDatasource();
  await localDatasource.prepopulateDemoData();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MateriasProvider()),
        ChangeNotifierProvider(
          create: (_) => HorarioProvider(
            repository: HorarioRepository(localDatasource: localDatasource),
          ),
        ),
        ChangeNotifierProvider(create: (_) => PerfilProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => EventosProvider()),
        ChangeNotifierProvider(create: (_) => CalificacionesProvider()),
        ChangeNotifierProvider(create: (_) => ProfesoresProvider()),
        ChangeNotifierProvider(create: (_) => GrabacionesProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Horarios UNGS',
          debugShowCheckedModeBanner: false,
          themeMode: themeProvider.themeMode,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF1565C0),
            ),
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF1565C0),
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
          ),
          home: const SplashScreen(),
        );
      },
    );
  }
}
