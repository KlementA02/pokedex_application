import 'package:hive_ce/hive.dart';
import 'package:pokedex_application/pokedex_screens/domain/entities/pokemon_entity.dart';

part 'pokemon_models.g.dart';

@HiveType(typeId: 0)
class PokemonModel extends PokemonEntity {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String type;

  @HiveField(3)
  final int hp;

  @HiveField(4)
  final int attack;

  @HiveField(5)
  final int defense;

  @HiveField(6) // Added Hive index for image
  final String image;

  PokemonModel({
    required this.id,
    required this.name,
    required this.type,
    required this.hp,
    required this.attack,
    required this.defense,
    required this.image, // Corrected this line
  }) : super(
         id: id,
         name: name,
         type: type,
         hp: hp,
         attack: attack,
         defense: defense,
         image: image, // Passing image to the Entity
       );

  factory PokemonModel.fromJson(Map<String, dynamic> json, String key) {
    // Safely parse the type field: handle List, String, or null
    String parsedType;
    try {
      final typeField = json['type'];
      if (typeField == null) {
        parsedType = 'Unknown';
      } else if (typeField is List) {
        // If it's a List, join all elements
        parsedType = (typeField)
            .map((e) => e.toString().trim())
            .where((e) => e.isNotEmpty)
            .join(', ');
        parsedType = parsedType.isEmpty ? 'Unknown' : parsedType;
      } else {
        // If it's a String or any other type, convert to String
        parsedType = typeField.toString().trim();
        parsedType = parsedType.isEmpty ? 'Unknown' : parsedType;
      }
    } catch (e) {
      print('Error parsing type field: $e');
      parsedType = 'Unknown';
    }

    // Safely parse numeric fields with null-safety fallbacks
    int parsedHp = 0;
    try {
      final hp = json['hp'];
      if (hp == null) {
        parsedHp = 0;
      } else if (hp is int) {
        parsedHp = hp;
      } else if (hp is double) {
        parsedHp = hp.toInt();
      } else if (hp is String) {
        parsedHp = int.tryParse(hp) ?? 0;
      }
    } catch (e) {
      print('Error parsing hp field: $e');
      parsedHp = 0;
    }

    int parsedAttack = 0;
    try {
      final attack = json['attack'];
      if (attack == null) {
        parsedAttack = 0;
      } else if (attack is int) {
        parsedAttack = attack;
      } else if (attack is double) {
        parsedAttack = attack.toInt();
      } else if (attack is String) {
        parsedAttack = int.tryParse(attack) ?? 0;
      }
    } catch (e) {
      print('Error parsing attack field: $e');
      parsedAttack = 0;
    }

    int parsedDefense = 0;
    try {
      final defense = json['defense'];
      if (defense == null) {
        parsedDefense = 0;
      } else if (defense is int) {
        parsedDefense = defense;
      } else if (defense is double) {
        parsedDefense = defense.toInt();
      } else if (defense is String) {
        parsedDefense = int.tryParse(defense) ?? 0;
      }
    } catch (e) {
      print('Error parsing defense field: $e');
      parsedDefense = 0;
    }

    return PokemonModel(
      id: int.tryParse(key) ?? 0,
      name: json['name']?.toString().trim() ?? 'Unknown',
      type: parsedType,
      hp: parsedHp,
      attack: parsedAttack,
      defense: parsedDefense,
      image: json['image']?.toString() ?? '🥚',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'hp': hp,
      'attack': attack,
      'defense': defense,
      'image': image,
    };
  }
}
