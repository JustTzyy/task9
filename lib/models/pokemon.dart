class Pokemon {
  final int id;
  final String name;
  final int height;
  final int weight;
  final String imageUrl;
  final List<String> types;
  final bool isLegendary; 

  Pokemon({
    required this.id,
    required this.name,
    required this.height,
    required this.weight,
    required this.imageUrl,
    required this.types,
    required this.isLegendary,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json, {bool isLegendary = false}) {
    List<String> types = [];
    if (json['types'] != null) {
      for (var type in json['types']) {
        types.add(type['type']['name']);
      }
    }

    return Pokemon(
      id: json['id'],
      name: json['name'],
      height: json['height'],
      weight: json['weight'],
      imageUrl: json['sprites']['other']['official-artwork']['front_default'] ??
          json['sprites']['front_default'] ??
          '',
      types: types,
      isLegendary: isLegendary, 
    );
  }
}
