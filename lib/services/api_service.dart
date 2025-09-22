import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pokemon.dart';

class ApiService {
  static const String baseUrl = "https://pokeapi.co/api/v2";

  static const List<int> legendaryIds = [
    144, 145, 146,
    150, 151, 
    243, 244, 245,
    249, 250, 251, 
    377, 378, 379, 380, 381, 382, 383, 384, 385,
    386, 
    480, 481, 482, 483, 484, 485, 486, 487, 488,
    489, 490, 491, 492, 493,
    638, 639, 640, 641, 642, 643, 644, 645, 646,
    647, 648, 649,
    716, 717, 718, 719, 720, 721,
    785, 786, 787, 788, 789, 790, 791, 792, 793,
    794, 795, 796, 797, 798, 799, 800, 801, 802,
    803, 804, 805, 806, 807, 808, 809,
    888, 889, 890,
  ];

  static Future<List<Pokemon>> fetchAllLegendaryPokemon({int limit = 60}) async {
    final idsToFetch = legendaryIds.take(limit).toList();

    final responses = await Future.wait(
      idsToFetch.map((id) => http.get(Uri.parse("$baseUrl/pokemon/$id"))),
    );

    List<Pokemon> pokemonList = [];
    for (var res in responses) {
      if (res.statusCode == 200) {
        final pokemonData = json.decode(res.body);
        pokemonList.add(Pokemon.fromJson(pokemonData, isLegendary: true));
      }
    }

    return pokemonList;
  }
}
