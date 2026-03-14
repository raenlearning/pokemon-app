import 'package:flutter/material.dart';
import 'package:pokemon_app/features/pokemon/domain/entities/pokemon.dart';

class PokemonStats extends StatelessWidget {
  final List<PokemonStatEntity> stats;

  const PokemonStats({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        
        const SizedBox(height: 10),
        ...stats.map((s) => _StatBar(name: s.name, value: s.base)),
      ],
    );
  }
}

class _StatBar extends StatelessWidget {
  final String name;
  final int value;

  const _StatBar({required this.name, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 55,
            child: Text(
              name.length > 3
                  ? name.substring(0, 3).toUpperCase()
                  : name.toUpperCase(),
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            width: 35,
            child: Text(value.toString(), style: const TextStyle(fontSize: 13)),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: value / 150,
                minHeight: 8,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation(
                  value > 75 ? Colors.green : Colors.orange,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
