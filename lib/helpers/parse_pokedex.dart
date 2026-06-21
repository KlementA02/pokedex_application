// import 'package:pokedex_application/infrastructure/models/pokemon_models.dart';

// List<Pokemon> parsePokedex(Map<String, dynamic> pokedexJson) {
//   List<Pokemon> pokemons = [];

//   pokedexJson.forEach((key, value) {
//     // value is the internal map for each Pokemon
//     pokemons.add(
//       Pokemon.fromJson({
//         'id': key, // This is the '1', '2', etc. from the dictionary keys
//         ...value,  // This spreads all other keys (name, hp, etc.) into this map
//       }),
//     );
//   });

//   return pokemons;
// }