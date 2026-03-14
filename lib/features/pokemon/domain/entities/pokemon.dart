import 'package:equatable/equatable.dart';

class PokemonListEntity extends Equatable {
  final int id;
  final String name;
  final String imageUrl;

  const PokemonListEntity({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  @override
  List<Object?> get props => [id, name, imageUrl];
}

class PokemonAbilityEntity extends Equatable {
  final String name;
  final bool isHidden;

  const PokemonAbilityEntity({required this.name, required this.isHidden});

  @override
  List<Object> get props => [name, isHidden];
}

class PokemonStatEntity extends Equatable {
  final String name;
  final int base;

  const PokemonStatEntity({required this.name, required this.base});

  @override
  List<Object?> get props => [name, base];
}

class PokemonDetailEntity extends Equatable {
  final int id;
  final String name;
  final double height;
  final double weight;
  final List<PokemonStatEntity> stats;
  final List<PokemonAbilityEntity> abilities;
  final String image;
  final String description;
  final List<String> types;

  const PokemonDetailEntity({
    required this.id,
    required this.name,
    required this.types,
    required this.height,
    required this.weight,
    required this.stats,
    required this.abilities,
    required this.image,
    required this.description,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    types,
    height,
    weight,
    stats,
    abilities,
    image,
    description,
  ];
}
