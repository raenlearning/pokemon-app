

import 'package:pokemon_app/features/pokemon/domain/entities/pokemon.dart';
import 'package:pokemon_app/features/pokemon/domain/entities/pokemon_move.dart';

abstract class PokemonRepository {
  Future<List<PokemonListEntity>> getPokemonList({
    int offset,
    int limit,
    String searchQuery,
    List<String> types,
  });

  Future<PokemonDetailEntity> getPokemonDetail(int id);

  Future<List<PokemonMovesEntity>> getPokemonMoves({
    required int id,
    String searchQuery,
  });
}