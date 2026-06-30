import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pokedex_application/core/dio_api.dart';
import 'package:pokedex_application/pokedex_screens/domain/entities/pokemon_entity.dart';
import 'package:pokedex_application/pokedex_screens/infrastructure/models/pokemon_models.dart';

class PokemonRemoteDataSource {
  final DioApi dioApi;
  PokemonRemoteDataSource(this.dioApi);

  // GET logic
  Future<List<PokemonModel>> fetchFromDjango() async {
    final response = await dioApi.get('/pokedex/api/');

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = response.data;

      debugPrint('Response data: ${response.data}');

      return data.entries.map((entry) {
        return PokemonModel.fromJson(entry.value, entry.key);
      }).toList();
    }
    throw Exception('Failed to load Pokedex');
  }

  Future<void> postToDjango(PokemonEntity pokemon) async {
    try {
      final Map<String, dynamic> data = {
        'name': pokemon.name,
        'type': pokemon.type.contains(',')
            ? pokemon.type.split(',').map((e) => e.trim()).toList()
            : [pokemon.type.trim()],
        'image': pokemon.image.isEmpty
            ? 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png'
            : pokemon.image,
        'hp': pokemon.hp,
        'attack': pokemon.attack,
        'defense': pokemon.defense,
      };

      await dioApi.post('/pokedex/api/post_pokemon/', data: data);
      debugPrint('data: $data');
    } on DioException catch (e) {
      final errorMessage = e.response?.data ?? e.message;
      debugPrint("Django Error Details: $errorMessage");
      throw Exception('Failed to post Pokemon: $errorMessage');
    }
  }
}
