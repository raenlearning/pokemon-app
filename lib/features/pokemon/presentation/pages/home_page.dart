import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:pokemon_app/features/pokemon/presentation/bloc/pokemon_bloc.dart';
import 'package:pokemon_app/features/pokemon/presentation/bloc/pokemon_event.dart';
import 'package:pokemon_app/features/pokemon/presentation/bloc/pokemon_state.dart';
import 'package:pokemon_app/features/pokemon/presentation/components/pokemon_card.dart';

import '../../../../core/utility/pokemon_color.dart';
import '../components/pokemon_searchbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<PokemonBloc>().add(FetchPokemon());
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final state = context.read<PokemonBloc>().state;
    if (state is PokemonLoaded &&
        !_scrollController.position.outOfRange &&
        _scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent * 0.85 &&
        !state.hasReachedMax) {
      context.read<PokemonBloc>().add(FetchMorePokemon());
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  String sprite(int id) =>
      "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png";

  void _showFilterBottomSheet() {
    final state = context.read<PokemonBloc>().state;
    List<String> currentSelectedTypes = [];
    if (state is PokemonLoaded) {
      currentSelectedTypes = List.from(state.selectedTypes);
    }

    final List<String> availableTypes = [
      'normal',
      'fire',
      'water',
      'electric',
      'grass',
      'ice',
      'fighting',
      'poison',
      'ground',
      'flying',
      'psychic',
      'bug',
      'rock',
      'ghost',
      'dragon',
      'dark',
      'steel',
      'fairy',
    ];

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Filter Pokemon by Type",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children:
                        availableTypes.map((type) {
                          final isSelected = currentSelectedTypes.contains(
                            type,
                          );
                          return FilterChip(
                            backgroundColor: getPokemonTypeColor(type),
                            label: Text(
                              type.toCapitalized(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            selected: isSelected,
                            onSelected: (selected) {
                              setModalState(() {
                                if (selected) {
                                  currentSelectedTypes.add(type);
                                } else {
                                  currentSelectedTypes.remove(type);
                                }
                              });
                            },
                          );
                        }).toList(),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4A90E2),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        context.read<PokemonBloc>().add(
                          FilterPokemon(currentSelectedTypes),
                        );
                        Navigator.pop(context);
                      },
                      child: const Text("Apply Filters"),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              Icon(
                Icons.catching_pokemon,
                color: Color.fromARGB(255, 79, 6, 175),
                size: 30,
              ),

              SizedBox(width: 5),
              Text(
                "Pokédex",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        actions: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.settings),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: PokemonSearchBar(
                controller: _searchController,
                onChanged:
                    (q) => context.read<PokemonBloc>().add(SearchPokemon(q)),
                onFilterTap: _showFilterBottomSheet,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: BlocBuilder<PokemonBloc, PokemonState>(
              builder: (context, state) {
                if (state is PokemonLoading) {
                  return Center(
                    child: Lottie.asset(
                      'assets/lottie/pokeballLoading.json',
                      width: 120,
                    ),
                  );
                }

                if (state is PokemonLoaded) {
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      int crossAxisCount = 2;
                      double padding = 16.0;

                      if (constraints.maxWidth > 900) {
                        crossAxisCount = 5;
                        padding = 32.0;
                      } else if (constraints.maxWidth > 600) {
                        crossAxisCount = 3;
                        padding = 24.0;
                      }

                      return GridView.builder(
                        controller: _scrollController,
                        padding: EdgeInsets.symmetric(
                          horizontal: padding,
                          vertical: 8,
                        ),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          childAspectRatio: 0.85,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount:
                            state.hasReachedMax
                                ? state.pokemons.length
                                : state.pokemons.length + 1,
                        itemBuilder: (context, index) {
                          if (index >= state.pokemons.length) {
                            return Center(
                              child: Lottie.asset(
                                'assets/lottie/pokeballLoading.json',
                                width: 80,
                              ),
                            );
                          }
                          return PokemonCard(
                            pokemon: state.pokemons[index],
                            onTap:
                                () => context.go(
                                  '/detail/${state.pokemons[index].id}',
                                ),
                          );
                        },
                      );
                    },
                  );
                }

                if (state is PokemonError) {
                  return Center(child: Text(state.message));
                }

                return const SizedBox();
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.build), label: 'Team'),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }
}

extension StringExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';

  String toTitleCase() => replaceAll(
    RegExp(' +'),
    ' ',
  ).split(' ').map((str) => str.toCapitalized()).join(' ');
}
