import 'package:pokedex_application/domain/entities/pokemon_entity.dart';

abstract class PokedexState {
  
}

class PokedexInitial extends PokedexState {}
  class PokedexLoading extends PokedexState {}
  class PokedexLoaded extends PokedexState {
    final List<PokemonEntity> pokemons;

  PokedexLoaded({required this.pokemons});
  }

  class PokedexError extends PokedexState {
    final String message;

    PokedexError(this.message);
  }