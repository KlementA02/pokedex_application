import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:pokedex_application/auth/presentation/auth_gate.dart';
import 'package:pokedex_application/pokedex_screens/infrastructure/models/pokemon_models.dart';

void main() async {
  // 2. Ensure Flutter bindings are ready for async setup
  WidgetsFlutterBinding.ensureInitialized();

  // 3. Initialize Hive
  await Hive.initFlutter();

  Hive.registerAdapter(PokemonModelAdapter());

  // 4. Open the box (Use the SAME name you used in PokemonLocalDataSource)
  await Hive.openBox<PokemonModel>('pokedex_cache');

  // 5. Run the app
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthGate(),
    );
  }
}
