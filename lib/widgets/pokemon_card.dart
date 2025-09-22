import 'package:flutter/material.dart';
import '../models/pokemon.dart';

class PokemonCard extends StatelessWidget {
  final Pokemon pokemon;
  final Color Function(String) getTypeColor;

  const PokemonCard({
    super.key,
    required this.pokemon,
    required this.getTypeColor,
  });

  String capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
        ],
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          // Pokémon Image (keeps flexible space)
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              child: pokemon.imageUrl.isNotEmpty
                  ? Image.network(
                      pokemon.imageUrl,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildPlaceholder();
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                            color: Colors.blue[400],
                          ),
                        );
                      },
                    )
                  : _buildPlaceholder(),
            ),
          ),

          // Pokémon Info (auto-sizes, no overflow)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Column(
              mainAxisSize: MainAxisSize.min, // ✅ prevent forced overflow
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ID
                Text(
                  '#${pokemon.id.toString().padLeft(3, '0')}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                // Name
                Text(
                  capitalizeFirst(pokemon.name),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 4),

                // Types
                if (pokemon.types.isNotEmpty)
                  Wrap(
                    spacing: 4,
                    runSpacing: 2,
                    children: pokemon.types.take(2).map((type) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: getTypeColor(type).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: getTypeColor(type).withOpacity(0.5),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          capitalizeFirst(type),
                          style: TextStyle(
                            color: getTypeColor(type),
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                const SizedBox(height: 6),

                // Height & Weight
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Height: ${(pokemon.height / 10).toStringAsFixed(1)}m',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[600],
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'Weight: ${(pokemon.weight / 10).toStringAsFixed(1)}kg',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[600],
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(Icons.image_not_supported, color: Colors.grey[400], size: 40),
    );
  }
}
