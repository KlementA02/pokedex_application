class PokemonEntity {
  final int id;
  final String name;
  final String type;
  final String image;
  final int hp;
  final int attack;
  final int defense;

  PokemonEntity({
    required this.id,
    required this.name,
    required this.type,
    required this.hp,
    required this.image,
    required this.attack,
    required this.defense,
  });
}
