import '../../domain/entities/pokemon.dart';
import 'pokemon_ability_model.dart';
import 'pokemon_stat_model.dart'; 

class PokemonDetailModel {
  final int id;
  final String name;
  final double height;
  final double weight;
  final List<PokemonStat> stats; 
  final List<PokemonAbility> abilities; 
  final String image;
  final String description;
  final List<String> types;

  PokemonDetailModel({
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

  factory PokemonDetailModel.fromJson(Map<String, dynamic> json, String description) {
    return PokemonDetailModel(
      id: json['id'],
      name: json['name'],
      height: (json['height'] as num).toDouble() / 10,
      weight: (json['weight'] as num).toDouble() / 10,
      image: json['sprites']?['other']?['official-artwork']?['front_default'] ?? 
             json['sprites']?['front_default'] ?? "",
      description: description,
      types: (json['types'] as List? ?? []).map((t) => t['type']['name'] as String).toList(),
      stats: (json['stats'] as List).map((s) => PokemonStat.fromJson(s)).toList(),
      abilities: (json['abilities'] as List).map((a) => PokemonAbility.fromJson(a)).toList(),
    );
  }

  PokemonDetailEntity toEntity() {
    return PokemonDetailEntity(
      id: id,
      name: name,
      height: height,
      weight: weight,
      image: image,
      description: description,
      types: types,
      stats: stats.map((s) => s.toEntity()).toList(),
      abilities: abilities.map((a) => a.toEntity()).toList(),
    );
  }
}