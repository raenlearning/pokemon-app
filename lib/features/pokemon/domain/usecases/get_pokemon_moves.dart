import 'package:injectable/injectable.dart';
import 'package:pokemon_app/features/pokemon/domain/entities/pokemon_move.dart';

import '../repositories/pokemon_repository.dart';
@lazySingleton
class GetPokemonMoves {
  final PokemonRepository repository;

  GetPokemonMoves(this.repository);

  Future<List<PokemonMovesEntity>> call({
    required int id,
    String searchQuery = '',
  }) {
    return repository.getPokemonMoves(
      id: id,
      searchQuery: searchQuery,
    );
  }
}