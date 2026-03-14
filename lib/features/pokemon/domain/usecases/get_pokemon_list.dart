import 'package:injectable/injectable.dart';
import 'package:pokemon_app/features/pokemon/domain/entities/pokemon.dart';

import '../repositories/pokemon_repository.dart';

@lazySingleton
class GetPokemonList {
  final PokemonRepository repository;

  GetPokemonList(this.repository);

  Future<List<PokemonListEntity>> call({
    int offset = 0,
    final int limit = 10,
    String searchQuery = '',
    List<String> types = const [],
  }) {
    return repository.getPokemonList(
      offset: offset,
      limit: limit,
      searchQuery: searchQuery,
      types: types,
    );
  }
}