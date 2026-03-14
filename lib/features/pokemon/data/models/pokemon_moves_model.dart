import 'package:pokemon_app/features/pokemon/domain/entities/pokemon_move.dart';

class PokemonMovesModels {
  final int id;
  final String movesName;
  final String movesType;

  PokemonMovesModels({
    required this.id,
    required this.movesName,
    required this.movesType,
  });

  factory PokemonMovesModels.fromJson(Map<String, dynamic> json) {
    return PokemonMovesModels(
      id: json['id'],
      movesName: json['moves']?['name'] ?? '',
      movesType: json['types'],
    );
  }

  PokemonMovesEntity toEntity() {
    return PokemonMovesEntity(
      id: id,
      movesName: movesName,
      movesType: movesType,
    );
  }
}
