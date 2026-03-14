import 'package:equatable/equatable.dart';

class PokemonMovesEntity extends Equatable {
  final int id;
  final String movesName;
  final String movesType;

  const PokemonMovesEntity({
    required this.id,
    required this.movesName,
    required this.movesType,
  });

  @override
  List<Object?> get props => [id, movesName, movesType];
}
