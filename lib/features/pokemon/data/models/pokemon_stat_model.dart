import 'package:pokemon_app/features/pokemon/domain/entities/pokemon.dart';

class PokemonStat {
  final String name;
  final int base;

  PokemonStat({required this.name, required this.base});

  factory PokemonStat.fromJson(Map<String, dynamic> json) {
    return PokemonStat(
      name: json['stat']?['name'] ?? '',
      base: json['base_stat'] ?? 0,
    );
  }

  PokemonStatEntity toEntity() {
    return PokemonStatEntity(name: name, base: base);
  }
}
