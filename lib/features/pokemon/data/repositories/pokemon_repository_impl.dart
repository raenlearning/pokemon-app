import 'package:injectable/injectable.dart';
import 'package:pokemon_app/features/pokemon/data/models/pokemon_list_model.dart';
import 'package:pokemon_app/features/pokemon/data/models/pokemon_moves_model.dart';
import 'package:pokemon_app/features/pokemon/domain/entities/pokemon.dart';
import '../../domain/entities/pokemon_move.dart';
import '../../domain/repositories/pokemon_repository.dart';
import '../data_sources/pokemon_remote_datasource.dart';
import '../models/pokemon_detail_model.dart';

@LazySingleton(as: PokemonRepository)
class PokemonRepositoryImpl implements PokemonRepository {
  final PokemonRemoteDataSource remote;

  PokemonRepositoryImpl(this.remote);

  @override
  Future<List<PokemonListEntity>> getPokemonList({
    int offset = 0,
    int limit = 10,
    String searchQuery = '',
    List<String> types = const [],
  }) async {
    final List<String> conditions = [];
    final Map<String, dynamic> variables = {'limit': limit, 'offset': offset};

    if (searchQuery.isNotEmpty) {
      conditions.add('name: {_ilike: \$search}');
      variables['search'] = '%${searchQuery.toLowerCase()}%';
    }

    if (types.isNotEmpty) {
      final typesString = types.map((t) => '"$t"').join(',');
      conditions.add(
        'pokemon_v2_pokemontypes: {pokemon_v2_type: {name: {_in: [$typesString]}}}',
      );
    }

    String whereClause = '';
    if (conditions.isNotEmpty) {
      whereClause = 'where: {${conditions.join(',')}}';
    }

    final query = '''
    query getPokemon(\$limit: Int, \$offset: Int${searchQuery.isNotEmpty ? ', \$search: String' : ''}) {
      pokemon_v2_pokemon(
        limit: \$limit,
        offset: \$offset,
        $whereClause
      ) {
        id
        name
      }
    }
    ''';

    final res = await remote.getPokemonList(
      offset: offset,
      limit: limit,
      query: query,
      variables: variables,
    );

    final List results = res.data['data']['pokemon_v2_pokemon'];

    return results.map((e) {
      final id = e['id'];

      return PokemonListModel(
        id: id,
        name: e['name'],
        image:
            "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png",
      ).toEntity();
    }).toList();
  }

  @override
  Future<PokemonDetailEntity> getPokemonDetail(int id) async {
    final detail = await remote.getPokemonDetail(id);

    final speciesUrl = detail.data['species']['url'];
    final species = await remote.getSpecies(speciesUrl);

    final description = (species.data['flavor_text_entries'] as List)
        .firstWhere(
          (e) => e['language']['name'] == 'en',
          orElse: () => {'flavor_text': 'No description available.'},
        )['flavor_text']
        .toString()
        .replaceAll(RegExp(r'[\n\f\r]'), ' ');

    final model = PokemonDetailModel.fromJson(detail.data, description);

    return model.toEntity();
  }

  @override
  Future<List<PokemonMovesEntity>> getPokemonMoves({
    required int id,
    String searchQuery = '',
  }) async {
    const query = '''
    query GetPokemonMoves(\$id: Int!, \$search: String!) {
      pokemon_v2_pokemon_by_pk(id: \$id) {
        pokemon_v2_pokemonmoves(
          where: {pokemon_v2_move: {name: {_ilike: \$search}}}
        ) {
          pokemon_v2_move {
            id
            name
            pokemon_v2_type {
              name
            }
          }
        }
      }
    }
    ''';

    final response = await remote.getPokemonMoves(
      query: query,
      variables: {"id": id, "search": "%$searchQuery%"},
    );

    final data = response.data["data"];

    final List movesRaw =
        data["pokemon_v2_pokemon_by_pk"]["pokemon_v2_pokemonmoves"];

    final moves =
        movesRaw.map((item) {
          final move = item["pokemon_v2_move"];

          return PokemonMovesModels(
            id: move["id"],
            movesName: move["name"],
            movesType: move["pokemon_v2_type"]?["name"] ?? "unknown",
          ).toEntity();
        }).toList();

    final uniqueMoves = {for (var m in moves) m.id: m}.values.toList();

    return uniqueMoves;
  }
}
