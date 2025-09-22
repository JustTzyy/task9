import 'package:flutter/material.dart';
import '../models/pokemon.dart';
import '../services/api_service.dart';
import '../widgets/pokemon_card.dart';

class PokemonListScreen extends StatefulWidget {
  const PokemonListScreen({super.key});

  @override
  State<PokemonListScreen> createState() => _PokemonListScreenState();
}

class _PokemonListScreenState extends State<PokemonListScreen> {
  List<Pokemon> pokemonList = [];
  bool isLoading = true;
  int currentPage = 0;
  final int pokemonPerPage = 20;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchPokemon();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        fetchMorePokemon();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> fetchPokemon() async {
  try {
final newPokemon = await ApiService.fetchAllLegendaryPokemon(limit: 60);

    setState(() {
      if (currentPage == 0) {
        pokemonList = newPokemon;
      } else {
        pokemonList.addAll(newPokemon);
      }
      isLoading = false;
    });
  } catch (e) {
    setState(() => isLoading = false);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Error fetching Pokémon: $e')));
  }
}

  Future<void> fetchMorePokemon() async {
    currentPage++;
    await fetchPokemon();
  }
  Color getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'fire':
        return Colors.red;
      case 'water':
        return Colors.blue;
      case 'grass':
        return Colors.green;
      case 'electric':
        return Colors.yellow;
      case 'psychic':
        return Colors.purple;
      case 'ice':
        return Colors.cyan;
      case 'dragon':
        return Colors.indigo;
      case 'dark':
        return Colors.black54;
      case 'fairy':
        return Colors.pink;
      case 'fighting':
        return Colors.brown;
      case 'poison':
        return Colors.deepPurple;
      case 'ground':
        return Colors.orange;
      case 'flying':
        return Colors.lightBlue;
      case 'bug':
        return Colors.lightGreen;
      case 'rock':
        return Colors.grey;
      case 'ghost':
        return Colors.deepPurple;
      case 'steel':
        return Colors.blueGrey;
      case 'normal':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue[100]!, Colors.white],
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(
                top: 50,
                left: 20,
                right: 20,
                bottom: 20,
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.yellow[600],
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Pokédex',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            'GEN I',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: isLoading && pokemonList.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(color: Colors.blue[600]),
                          const SizedBox(height: 16),
                          Text(
                            'Loading Pokémon...',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    )
                  : GridView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200, 
                            childAspectRatio: 0.8, 
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),

                      itemCount: pokemonList.length + (isLoading ? 2 : 0),
                      itemBuilder: (context, index) {
                        if (index >= pokemonList.length) {
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Colors.blue[600],
                              ),
                            ),
                          );
                        }

                        final pokemon = pokemonList[index];
                        return PokemonCard(
                          pokemon: pokemon,
                          getTypeColor: getTypeColor,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
