import '../../domain/entities/pokemon.dart';

class PokemonListModel {
  final int id;
  final String name;
  final String image;

  const PokemonListModel({
    required this.id,
    required this.name,
    required this.image,
  });

  factory PokemonListModel.fromDetailJson(
    Map<String, dynamic> json,
    // Parameter generation bisa tetap ada jika nanti dibutuhkan logika khusus
    String generation, 
  ) {
    final image =
        json['sprites']?['other']?['official-artwork']?['front_default'] ??
        json['sprites']?['front_default'] ??
        "";

    return PokemonListModel(
      id: json['id'], 
      name: json['name'], 
      image: image,
    );
  }

  PokemonListEntity toEntity() {
    return PokemonListEntity(
      id: id,
      name: name,
      imageUrl: image, 
    );
  }
}