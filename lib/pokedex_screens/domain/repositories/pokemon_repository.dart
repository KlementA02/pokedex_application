import 'package:pokedex_application/pokedex_screens/domain/entities/pokemon_entity.dart';

abstract class PokemonRepository {
  Future<List<PokemonEntity>> getPokedex();
  Future<void> addPokemon(Map<String, dynamic> pokemonData);
  Future<void> updatePokemon(PokemonEntity pokemon);
}
