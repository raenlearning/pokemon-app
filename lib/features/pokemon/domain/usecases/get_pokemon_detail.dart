import 'package:injectable/injectable.dart';
import 'package:pokemon_app/features/pokemon/domain/entities/pokemon.dart';

import '../repositories/pokemon_repository.dart';

@lazySingleton
class GetPokemonDetail {
  final PokemonRepository repository;

  GetPokemonDetail(this.repository);

  Future<PokemonDetailEntity> call(int id) {
    return repository.getPokemonDetail(id);
  }
}