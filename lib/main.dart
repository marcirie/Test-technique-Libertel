import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:test_technique/core/theme/app_theme.dart';
import 'package:test_technique/features/vehicles/presentation/bloc/vehicle_bloc.dart';
import 'package:test_technique/features/vehicles/presentation/pages/vehicles_page.dart';
import 'package:test_technique/injection_container.dart' as di;

void main() async {
  // Obligatoire quand on veut lancer du code (comme get_it) avant runApp
  WidgetsFlutterBinding.ensureInitialized();

  // Barre de statut transparente pour un look immersif
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
  );

  await Hive.initFlutter();
  // 2. Ouvrir une boîte pour stocker nos données
  await Hive.openBox('vehiclesBox');

  // On allume notre "distributeur automatique" de classes
  await di.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test Technique NHTSA',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      // BlocProvider agit comme un parapluie.
      // Il rend le BLoC disponible pour la page et ses enfants.
      home: BlocProvider(
        // On demande à get_it (sl) de nous fabriquer le BLoC
        create: (context) => di.sl<VehicleBloc>(),
        child: const VehiclesPage(),
      ),
    );
  }
}
