import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pokemon_app/features/pokemon/presentation/pages/home_page.dart';
import '../../domain/entities/pokemon.dart';

class PokemonCard extends StatelessWidget {
  final PokemonListEntity pokemon;
  final VoidCallback onTap;

  const PokemonCard({super.key, required this.pokemon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: const Color(0xffe3350d),
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [BoxShadow(blurRadius: 15, offset: Offset(0, 5))],
          ),
          child: Stack(
            children: [
              // Background (Pokeball)
              Positioned(
                bottom: -20,
                right: -20,
                child: Opacity(
                  opacity: 0.5,
                  child: Image.asset(
                    'assets/images/pokeball_card_bg.png',
                    width: 140,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // : Name and ID
                    _buildIdBadge(pokemon.id),

                    const SizedBox(height: 8),

                    // Pokemon Image
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Hero(
                              tag: 'pokemon-${pokemon.id}',
                              child: CachedNetworkImage(
                                imageUrl: pokemon.imageUrl,
                                fit: BoxFit.contain,
                                width: 200,
                                memCacheHeight: 400,
                                placeholder:
                                    (_, __) => const Center(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Color(0xFFE0E0E0),
                                            ),
                                      ),
                                    ),
                                errorWidget:
                                    (_, __, ___) => const Icon(
                                      Icons.error,
                                      color: Colors.grey,
                                    ),
                              ),
                            ),
                            // Pokemon Name
                            Expanded(
                              child: Text(
                                pokemon.name.toCapitalized(),
                                style: const TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontFamily: 'pressStart2P',
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.visible,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIdBadge(int id) {
    return Text(
      "#${id.toString().padLeft(3, '0')}",
      style: const TextStyle(
        fontSize: 12,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
