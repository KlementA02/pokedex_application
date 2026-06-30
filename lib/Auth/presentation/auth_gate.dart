import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokedex_application/auth/application/auth_provider.dart';
import 'package:pokedex_application/auth/presentation/auth_screen.dart';
import 'package:pokedex_application/pokedex_screens/presentation/skeleton.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);

    return authState.maybeWhen(
      authenticated: (_) => const Skeleton(),
      unauthenticated: () => const AuthScreen(),
      failure: (_) => const AuthScreen(),
      orElse: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }
}
