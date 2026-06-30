import 'package:pokedex_application/pokedex_screens/domain/entities/pokemon_entity.dart';
import 'package:pokedex_application/pokedex_screens/domain/repositories/pokemon_repository.dart';
import 'package:pokedex_application/pokedex_screens/infrastructure/datasources/pokemon_local_datasource.dart';
import 'package:pokedex_application/pokedex_screens/infrastructure/datasources/pokemon_remote_datasource.dart';
import 'package:pokedex_application/pokedex_screens/infrastructure/models/pokemon_models.dart';

class PokemonRepositoryImpl implements PokemonRepository {
  final PokemonRemoteDataSource remoteDataSource;
  final PokemonLocalDataSource localDataSource;

  PokemonRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<PokemonEntity>> getPokedex() async {
    try {
      final remotePokemons = await remoteDataSource.fetchFromDjango();
      await localDataSource.cachePokedex(remotePokemons);
      return remotePokemons;
    } catch (e) {
      final localPokemons = localDataSource.getCachedPokedex();
      if (localPokemons.isNotEmpty) return localPokemons;
      throw Exception("No connection and no cache found.");
    }
  }

  @override
Future<void> addPokemon(Map<String, dynamic> pokemonData) async {
  // Convert the Map into a PokemonModel (which is a PokemonEntity)
  final newPokemon = PokemonModel(
    id: 0, // Django usually generates the ID, so 0 is a fine placeholder
    name: pokemonData['name'],
    type: (pokemonData['type'] as List).join(', '),
    hp: pokemonData['hp'],
    attack: pokemonData['attack'],
    defense: pokemonData['defense'],
    image: pokemonData['image'], // Add this if your entity supports it
  );

  // Now the types match! Entity goes in, Entity is received.
  await remoteDataSource.postToDjango(newPokemon);
}

  @override
  Future<void> updatePokemon(PokemonEntity pokemon) async {
    // Satisfies the 'missing concrete implementation' error
    print("Update not implemented yet");
  }
}
