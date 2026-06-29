import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:pokedex_application/auth/application/auth_provider.dart';
import 'package:pokedex_application/pokedex_screens/application/pokedex_state.dart';
import 'package:pokedex_application/pokedex_screens/domain/repositories/pokemon_repository.dart';
import 'package:pokedex_application/pokedex_screens/infrastructure/datasources/pokemon_local_datasource.dart';
import 'package:pokedex_application/pokedex_screens/infrastructure/datasources/pokemon_remote_datasource.dart';
import 'package:pokedex_application/pokedex_screens/infrastructure/repositories/pokemon_repository_impl.dart';

final remoteDataSourceProvider = Provider((ref) {
  final dioApi = ref.read(authDioApiProvider);
  return PokemonRemoteDataSource(dioApi);
});

final localDataSourceProvider = Provider((ref) => PokemonLocalDataSource());

final pokemonRepositoryProvider = Provider<PokemonRepository>((ref) {
  final remote = ref.read(remoteDataSourceProvider);
  final local = ref.read(localDataSourceProvider);

  return PokemonRepositoryImpl(
    remoteDataSource: remote,
    localDataSource: local,
  );
});

// --- 2. Application Providers (The Engine) ---

// This is the "Brain" that the UI talks to
class PokedexNotifier extends StateNotifier<PokedexState> {
  final PokemonRepository _repository;

  PokedexNotifier(this._repository) : super(PokedexInitial());

  Future<void> fetchPokedex() async {
    // Only show the full loading screen if we don't have data yet
    if (state is! PokedexLoaded) {
      state = PokedexLoading();
    }

    try {
      final pokemons = await _repository.getPokedex();
      state = PokedexLoaded(pokemons: pokemons);
    } catch (e) {
      state = PokedexError(e.toString());
    }
  }

  /// Post a new Pokemon to the backend and refresh the Pokedex
  /// Ensures the UI transitions from PokedexLoading to PokedexLoaded or PokedexError
  Future<void> postPokemon(Map<String, dynamic> pokemonData) async {
    try {
      // Transition to loading state
      state = PokedexLoading();

      // Attempt to post the Pokemon
      await _repository.addPokemon(pokemonData);

      // On success, immediately fetch the updated Pokedex
      // This ensures we transition from PokedexLoading to PokedexLoaded
      await fetchPokedex();
    } catch (e) {
      // On any error, transition to PokedexError state
      // This prevents the UI from hanging on a loading/black screen
      debugPrint('Error posting Pokemon: $e');
      state = PokedexError(
        'Failed to add Pokemon: ${e.toString()}. Please try again.',
      );
    }
  }
}

// This is what your GetPage calls ref.watch(pokedexNotifierProvider) on
final pokedexNotifierProvider =
    StateNotifierProvider<PokedexNotifier, PokedexState>((ref) {
      final repository = ref.watch(pokemonRepositoryProvider);
      return PokedexNotifier(repository);
    });
