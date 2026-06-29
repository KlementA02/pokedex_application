// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pokemon_models.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PokemonModelAdapter extends TypeAdapter<PokemonModel> {
  @override
  final typeId = 0;

  @override
  PokemonModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PokemonModel(
      id: (fields[0] as num).toInt(),
      name: fields[1] as String,
      type: fields[2] as String,
      hp: (fields[3] as num).toInt(),
      attack: (fields[4] as num).toInt(),
      defense: (fields[5] as num).toInt(),
      image: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PokemonModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.hp)
      ..writeByte(4)
      ..write(obj.attack)
      ..writeByte(5)
      ..write(obj.defense)
      ..writeByte(6)
      ..write(obj.image);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PokemonModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
