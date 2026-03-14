// Event yang akan dilakukan user

import 'package:equatable/equatable.dart';

abstract class PokemonEvent extends Equatable {
  const PokemonEvent();

  @override
  List<Object?> get props => [];
}

class FetchPokemon extends PokemonEvent {}

class FetchMorePokemon extends PokemonEvent {}

class RefreshPokemon extends PokemonEvent {}

class SearchPokemon extends PokemonEvent {
  final String query;

  const SearchPokemon(this.query);

  @override
  List<Object?> get props => [query];
}

class FilterPokemon extends PokemonEvent {
  final List<String> types;

  const FilterPokemon(this.types);

  @override
  List<Object?> get props => [types];
}

class FetchPokemonDetail extends PokemonEvent {
  final int id;

  const FetchPokemonDetail(this.id);
}

class FetchPokemonMoves extends PokemonEvent {
  final int id;

  const FetchPokemonMoves(this.id);
}

class SearchPokemonMoves extends PokemonEvent {
  final int id;
  final String query;

  const SearchPokemonMoves(this.id, this.query);

  @override
  List<Object?> get props => [id];
}