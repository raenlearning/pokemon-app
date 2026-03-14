import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemon_app/features/pokemon/domain/entities/pokemon.dart';

import '../../../../core/utility/pokemon_color.dart';
import '../bloc/pokemon_bloc.dart';
import '../bloc/pokemon_event.dart';
import '../bloc/pokemon_state.dart';
import '../components/pokemon_detail_appbar.dart';
import '../components/pokemon_physical_info.dart';
import '../components/pokemon_stats.dart';

class PokemonDetailPage extends StatefulWidget {
  final int id;

  const PokemonDetailPage({super.key, required this.id});

  @override
  State<PokemonDetailPage> createState() => _PokemonDetailPageState();
}

class _PokemonDetailPageState extends State<PokemonDetailPage> {
  final Color themeColor = const Color(0xFF4A90E2);

  @override
  void initState() {
    super.initState();
    context.read<PokemonDetailBloc>().add(FetchPokemonDetail(widget.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<PokemonDetailBloc, PokemonDetailState>(
        builder: (context, state) {
          if (state is PokemonDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is PokemonDetailError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Failed to load Pokemon details:\\n${state.message}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            );
          }
          if (state is PokemonDetailLoaded) {
            final p = state.pokemon;
            final pokemonTypeColor = getPokemonTypeColor(p.types.first);
            return CustomScrollView(
              slivers: [
                PokemonDetailAppBar(pokemon: p),
                SliverToBoxAdapter(
                  child: Transform.translate(
                    offset: const Offset(0, 0),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color(0xff010720),
                      ),
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _PokemonHeader(pokemon: p),

                          const SizedBox(height: 30),

                          // About Section
                          const Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.menu_book, color: Colors.grey),

                              SizedBox(width: 5),

                              Text(
                                "About",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                width: 1,
                                color: pokemonTypeColor.withValues(alpha: 0.5),
                              ),
                              color: Colors.black,
                            ),
                            child: Text(
                              "\"${p.description.replaceAll('\n', ' ')}\"",
                              style: TextStyle(
                                fontSize: 15,
                                fontStyle: FontStyle.italic,
                                color: pokemonTypeColor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),

                          const SizedBox(height: 25),
                          PokemonPhysicalInfo(
                            height: p.height,
                            weight: p.weight,
                          ),

                          const SizedBox(height: 10),

                          const Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.bar_chart,
                                color: Colors.green,
                                size: 22,
                              ),

                              SizedBox(width: 5),

                              Text(
                                "Base Stats",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          PokemonStats(stats: p.stats),

                          const SizedBox(height: 20),

                          _PokemonAbilities(pokemon: p, themeColor: themeColor),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}

class _PokemonHeader extends StatelessWidget {
  final PokemonDetailEntity pokemon;

  const _PokemonHeader({required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              pokemon.name.toUpperCase(),
              style: const TextStyle(
                fontSize: 16,
                fontFamily: 'pressStart2P',
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              children:
                  pokemon.types.map((type) => _TypeChip(label: type)).toList(),
            ),
          ],
        ),
      ],
    );
  }
}

class _PokemonAbilities extends StatelessWidget {
  final PokemonDetailEntity pokemon;
  final Color themeColor;

  const _PokemonAbilities({required this.pokemon, required this.themeColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.bolt, color: Colors.yellow, size: 22),

            SizedBox(width: 5),

            Text(
              "Abilities",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          children:
              pokemon.abilities
                  .map(
                    (a) => Chip(
                      label: Text(
                        a.name.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      backgroundColor: a.isHidden ? Colors.red : themeColor,
                      side: BorderSide.none,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  )
                  .toList(),
        ),
      ],
    );
  }
}

class _TypeChip extends StatelessWidget {
  final String label;

  const _TypeChip({required this.label});

  @override
  Widget build(BuildContext context) {
    final Color baseColor = getPokemonTypeColor(label);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: baseColor,
      ),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(fontSize: 12, color: Colors.white),
      ),
    );
  }
}
