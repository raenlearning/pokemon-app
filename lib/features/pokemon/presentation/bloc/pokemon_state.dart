// state atau "Status" aplikasi saat ini

import 'package:equatable/equatable.dart';
import 'package:pokemon_app/features/pokemon/domain/entities/pokemon.dart';
import '../../domain/entities/pokemon_move.dart';

abstract class PokemonState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PokemonInitial extends PokemonState {}

class PokemonLoading extends PokemonState {}

class PokemonLoaded extends PokemonState {
  final List<PokemonListEntity> pokemons;
  final bool hasReachedMax;
  final bool isLoadingMore;
  final String query;
  final List<String> selectedTypes;

  PokemonLoaded({
    required this.pokemons,
    this.hasReachedMax = false,
    this.isLoadingMore = false,
    this.query = '',
    this.selectedTypes = const [],
  });

  PokemonLoaded copyWith({
    List<PokemonListEntity>? pokemons,
    bool? hasReachedMax,
    bool? isLoadingMore,
    String? query,
    List<String>? selectedTypes,
  }) {
    return PokemonLoaded(
      pokemons: pokemons ?? this.pokemons,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      query: query ?? this.query,
      selectedTypes: selectedTypes ?? this.selectedTypes,
    );
  }

  @override
  List<Object?> get props => [
    Object.hashAll(pokemons),
    hasReachedMax,
    isLoadingMore,
    query,
    Object.hashAll(selectedTypes),
  ];
}

class PokemonError extends PokemonState {
  final String message;

  PokemonError(this.message);

  @override
  List<Object?> get props => [message];
}

// Pokemon Detail State

abstract class PokemonDetailState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PokemonDetailInitial extends PokemonDetailState {}

class PokemonDetailLoading extends PokemonDetailState {}

class PokemonDetailLoaded extends PokemonDetailState {
  final PokemonDetailEntity pokemon;

  PokemonDetailLoaded(this.pokemon);

  @override
  List<Object?> get props => [pokemon];
}

class PokemonDetailError extends PokemonDetailState {
  final String message;
  PokemonDetailError(this.message);

  @override
  List<Object?> get props => [message];
}

//  Pokemon Moves State
abstract class PokemonMovesState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PokemonMovesInitial extends PokemonMovesState {}

class PokemonMovesLoading extends PokemonMovesState {}

class PokemonMovesLoaded extends PokemonMovesState {
  final List<PokemonMovesEntity> moves;
  final List<String> selectedTypes;

  PokemonMovesLoaded({required this.moves, this.selectedTypes = const []});

  PokemonMovesLoaded copyWith({
    List<PokemonMovesEntity>? moves,
    List<String>? selectedTypes,
  }) {
    return PokemonMovesLoaded(
      moves: moves ?? this.moves,
      selectedTypes: selectedTypes ?? this.selectedTypes,
    );
  }
}

class PokemonMovesError extends PokemonMovesState {
  final String message;
  PokemonMovesError(this.message);

  @override
  List<Object?> get props => [message];
}
