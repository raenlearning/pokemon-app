import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pokemon_app/core/utility/pokemon_color.dart';
import 'package:pokemon_app/features/pokemon/domain/entities/pokemon.dart';

class PokemonDetailAppBar extends StatefulWidget {
  final PokemonDetailEntity pokemon;

  const PokemonDetailAppBar({super.key, required this.pokemon});

  @override
  State<PokemonDetailAppBar> createState() => _PokemonDetailAppBarState();
}

class _PokemonDetailAppBarState extends State<PokemonDetailAppBar> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final Color baseColor = getPokemonTypeColor(
      widget.pokemon.types.isNotEmpty ? widget.pokemon.types.first : null,
    );

    return SliverAppBar(
      actions: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: IconButton(
            onPressed: () {
              setState(() {
                isFavorite = !isFavorite;
              });
            },
            icon:
                isFavorite
                    ? const Icon(Icons.favorite_sharp)
                    : const Icon(Icons.favorite_outline_outlined),
          ),
        ),
      ],
      pinned: true,
      expandedHeight: 320,
      elevation: 0,
      backgroundColor: baseColor,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              right: -20,
              bottom: 20,
              child: Icon(
                Icons.catching_pokemon,
                size: 200,
                color: Colors.white.withValues(alpha: 0.15),
              ),
            ),

            Hero(
              tag: 'pokemon-${widget.pokemon.id}',
              child: CachedNetworkImage(
                imageUrl: widget.pokemon.image,
                width: 220,
                fit: BoxFit.contain,
              ),
            ),

            Positioned(
              left: 20,
              bottom: 20,
              child: Text(
                "#${widget.pokemon.id.toString().padLeft(3, '0')}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),

            Positioned(
              right: 20,
              bottom: 12.5,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                onPressed: () {
                  context.go('/detail/${widget.pokemon.id}/moves');
                },
                child: const Text(
                  'All Moves',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
