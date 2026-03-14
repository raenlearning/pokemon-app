import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class PokemonRemoteDataSource {
  final Dio dio;

  PokemonRemoteDataSource(this.dio);

  static const String restBaseUrl = "https://pokeapi.co/api/v2";
  static const String graphQlUrl = "https://beta.pokeapi.co/graphql/v1beta";

  Future<Response> getPokemonList({
    required int offset,
    required int limit,
    required String query,
    required Map<String, dynamic> variables,
  }) {
    return dio.post(
      graphQlUrl,
      data: {
        "query": query,
        "variables": variables,
      },
    );
  }

  Future<Response> getPokemonDetail(int id) {
    return dio.get("$restBaseUrl/pokemon/$id");
  }

  Future<Response> getSpecies(String url) {
    return dio.get(url);
  }

  Future<Response> getPokemonMoves({
    required String query,
    required Map<String, dynamic> variables,
  }) {
    return dio.post(
      graphQlUrl,
      data: {
        "query": query,
        "variables": variables,
      },
    );
  }
}