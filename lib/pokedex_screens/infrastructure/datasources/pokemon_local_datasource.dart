import 'package:hive_ce/hive.dart';
import 'package:pokedex_application/pokedex_screens/infrastructure/models/pokemon_models.dart';

class PokemonLocalDataSource {
  static const String boxName = 'pokedex_cache';

  // Save to Hive
  Future<void> cachePokedex(List<PokemonModel> pokemons) async {
    final box = Hive.box<PokemonModel>(boxName);
    await box.clear();

    final Map<int, PokemonModel> pokemonMap = {
      for (var pokemon in pokemons) pokemon.id: pokemon,
    };

    await box.putAll(pokemonMap);
    print("DEBUG: Cached ${box.length} items in Hive");
  }

  // Read from Hive
  List<PokemonModel> getCachedPokedex() {
    final box = Hive.box<PokemonModel>(boxName);
    if (box.isEmpty) {
      return [
        PokemonModel(
          id: 0,
          name: 'Bulbasaur',
          type: 'Grass, Poison',
          hp: 45,
          attack: 49,
          defense: 49,
          image:
              'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png',
        ),
      ];
    }
    return box.values.toList();
  }
}
