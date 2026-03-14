import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemon_app/core/utility/pokemon_color.dart';
import 'package:pokemon_app/features/pokemon/presentation/bloc/pokemon_bloc.dart';
import 'package:pokemon_app/features/pokemon/presentation/bloc/pokemon_event.dart';
import 'package:pokemon_app/features/pokemon/presentation/bloc/pokemon_state.dart';
import 'package:pokemon_app/features/pokemon/presentation/pages/home_page.dart';

import '../components/pokemon_moves_searchbar.dart';

class PokemonMovesPage extends StatefulWidget {
  final int id;

  const PokemonMovesPage({super.key, required this.id});

  @override
  State<PokemonMovesPage> createState() => _PokemonMovesPageState();
}

class _PokemonMovesPageState extends State<PokemonMovesPage> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    context.read<PokemonMovesBloc>().add(FetchPokemonMoves(widget.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'List Pokemon Moves',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            PokemonMovesSearchBar(
              controller: _searchController,
              onChanged:
                  (q) => context.read<PokemonBloc>().add(SearchPokemon(q)),
              id: widget.id,
            ),

            Expanded(
              child: BlocBuilder<PokemonMovesBloc, PokemonMovesState>(
                builder: (context, state) {
                  if (state is PokemonMovesLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is PokemonMovesError) {
                    return Center(
                      child: Text(
                        state.message,
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  if (state is PokemonMovesLoaded) {
                    final moveList = state.moves;

                    if (moveList.isEmpty) {
                      return const Center(child: Text('No moves available'));
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: moveList.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final move = moveList[index];

                        return Card(
                          color: getPokemonTypeColor(move.movesType),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side: const BorderSide(
                              width: 1,
                            ),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: getPokemonTypeColor(
                                move.movesType,
                              ),
                              child: Text(
                                move.id.toString(),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            title: Text(
                              move.movesName.toCapitalized(),
                              style: const TextStyle(color: Colors.white),
                            ),
                            subtitle: Text(
                              'Type: ${move.movesType}',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      },
                    );
                  }

                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
