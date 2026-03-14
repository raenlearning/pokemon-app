import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/pokemon_bloc.dart';
import '../bloc/pokemon_event.dart';

class PokemonMovesSearchBar extends StatefulWidget {
  final int id;
  final TextEditingController controller;
  final Function(String) onChanged;

  const PokemonMovesSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.id,
  });

  @override
  State<PokemonMovesSearchBar> createState() => _PokemonSearchBarState();
}

class _PokemonSearchBarState extends State<PokemonMovesSearchBar> {
  Timer? _debounce;

  void _onSearchChanged(String value) {
    context.read<PokemonMovesBloc>().add(SearchPokemonMoves(widget.id, value));
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Search Field
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(
                      alpha: 0.04,
                    ), // Softer shadow
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: TextField(
                controller: widget.controller,
                onChanged: _onSearchChanged,
                decoration: InputDecoration(
                  hintText: "Search Pokémon Moves...",
                  hintStyle: const TextStyle(color: Color(0xFFB0B0B0)),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Color(0xFF4A90E2),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 20,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(width: 2, color: Colors.grey),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
    );
  }
}
