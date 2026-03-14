import '../../domain/entities/pokemon.dart';

class PokemonAbility {
  final String name;
  final bool isHidden;

  PokemonAbility({required this.name, required this.isHidden});

  factory PokemonAbility.fromJson(Map<String, dynamic> json) {
    return PokemonAbility(
      name: json['ability']?['name'] ?? '',
      isHidden: json['is_hidden'] ?? false,
    );
  }

  PokemonAbilityEntity toEntity() {
    return PokemonAbilityEntity(
      name: name,
      isHidden: isHidden,
    );
  }
}