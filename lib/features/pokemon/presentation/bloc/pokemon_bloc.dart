import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/usecases/get_pokemon_detail.dart';
import '../../domain/usecases/get_pokemon_list.dart';
import '../../domain/usecases/get_pokemon_moves.dart';
import 'pokemon_event.dart';
import 'pokemon_state.dart';

@injectable
class PokemonBloc extends Bloc<PokemonEvent, PokemonState> {
  final GetPokemonList getPokemonList;

  static const int _limit = 10;
  int _offset = 0;
  bool _isFetching = false;

  String _query = '';
  List<String> _selectedTypes = [];

  PokemonBloc(this.getPokemonList) : super(PokemonInitial()) {
    on<FetchPokemon>(_onFetchPokemon);
    on<FetchMorePokemon>(_onFetchMorePokemon);
    on<RefreshPokemon>(_onRefreshPokemon);
    on<SearchPokemon>(_onSearchPokemon);
    on<FilterPokemon>(_onFilterPokemon);
  }

  Future<void> _onFetchPokemon(
    FetchPokemon event,
    Emitter<PokemonState> emit,
  ) async {
    _offset = 0;
    _isFetching = true;

    emit(PokemonLoading());

    try {
      final pokemons = await getPokemonList(
        offset: _offset,
        limit: _limit,
        searchQuery: _query,
        types: _selectedTypes,
      );

      _offset += pokemons.length;

      emit(
        PokemonLoaded(
          pokemons: pokemons,
          hasReachedMax: pokemons.length < _limit,
          query: _query,
          selectedTypes: _selectedTypes,   
        ),
      );
    } catch (e) {
      emit(PokemonError(e.toString()));
    } finally {
      _isFetching = false;
    }
  }

  Future<void> _onFetchMorePokemon(
    FetchMorePokemon event,
    Emitter<PokemonState> emit,
  ) async {
    final currentState = state;

    if (currentState is! PokemonLoaded) return;
    if (currentState.hasReachedMax || _isFetching) return;

    _isFetching = true;

    emit(currentState.copyWith(isLoadingMore: true));

    try {
      final newPokemons = await getPokemonList(
        offset: _offset,
        limit: _limit,
        searchQuery: _query,
        types: _selectedTypes,
      );

      _offset += newPokemons.length;

      emit(
        currentState.copyWith(
          pokemons: List.of(currentState.pokemons)..addAll(newPokemons),
          hasReachedMax: newPokemons.length < _limit,
          isLoadingMore: false,
        ),
      );
    } catch (e) {
      emit(PokemonError(e.toString()));
    } finally {
      _isFetching = false;
    }
  }

  Future<void> _onRefreshPokemon(
    RefreshPokemon event,
    Emitter<PokemonState> emit,
  ) async {
    _query = '';
    _selectedTypes = [];
    add(FetchPokemon());
  }

  Future<void> _onSearchPokemon(
    SearchPokemon event,
    Emitter<PokemonState> emit,
  ) async {
    if (_query == event.query) return;

    _query = event.query;
    add(FetchPokemon());
  }

  Future<void> _onFilterPokemon(
    FilterPokemon event,
    Emitter<PokemonState> emit,
  ) async {
    _selectedTypes = event.types;
    add(FetchPokemon());
  }
}

@injectable
class PokemonMovesBloc extends Bloc<PokemonEvent, PokemonMovesState> {
  final GetPokemonMoves getPokemonMoves;

  String query = '';

  PokemonMovesBloc(this.getPokemonMoves) : super(PokemonMovesInitial()) {
    on<FetchPokemonMoves>(_onFetchPokemonMoves);
    on<SearchPokemonMoves>(_onSearchPokemonMoves);
  }

  Future<void> _onFetchPokemonMoves(
    FetchPokemonMoves event,
    Emitter<PokemonMovesState> emit,
  ) async {
    emit(PokemonMovesLoading());

    try {
      final moves = await getPokemonMoves(
        id: event.id,
        searchQuery: query,
      );
      moves.sort((a, b) => a.id.compareTo(b.id));

      emit(PokemonMovesLoaded(moves: moves));
    } catch (e) {
      emit(PokemonMovesError(e.toString()));
    }
  }

  Future<void> _onSearchPokemonMoves(
    SearchPokemonMoves event,
    Emitter<PokemonMovesState> emit,
  ) async {
    emit(PokemonMovesLoading());

    final moves = await getPokemonMoves(
      id: event.id,
      searchQuery: event.query,
    );

      moves.sort((a, b) => a.id.compareTo(b.id));    

    emit(PokemonMovesLoaded(moves: moves));
  }
}

@injectable
class PokemonDetailBloc extends Bloc<PokemonEvent, PokemonDetailState> {
  final GetPokemonDetail getPokemonDetail;

  PokemonDetailBloc(this.getPokemonDetail)
      : super(PokemonDetailInitial()) {
    on<FetchPokemonDetail>(_onFetchDetail);
  }

  Future<void> _onFetchDetail(
    FetchPokemonDetail event,
    Emitter<PokemonDetailState> emit,
  ) async {
    emit(PokemonDetailLoading());

    try {
      final data = await getPokemonDetail(event.id);
      emit(PokemonDetailLoaded(data));
    } catch (e) {
      emit(PokemonDetailError(e.toString()));
    }
  }
}