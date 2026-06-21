import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokedex_application/application/pokedex_provider.dart';
import 'package:pokedex_application/application/pokedex_state.dart';
import 'package:pokedex_application/domain/entities/pokemon_entity.dart';

class GetPage extends ConsumerWidget {
  const GetPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listen to the state from our Riverpod provider
    final state = ref.watch(pokedexNotifierProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Pokédex',
          style: TextStyle(fontWeight: FontWeight.w600, letterSpacing: 1.2),
        ),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                ref.read(pokedexNotifierProvider.notifier).fetchPokedex(),
          ),
        ],
      ),
      body: _buildBody(context, state, ref),
    );
  }

  Widget _buildBody(BuildContext context, PokedexState state, WidgetRef ref) {
    // 1. Initial State: Trigger the first fetch
    if (state is PokedexInitial) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(pokedexNotifierProvider.notifier).fetchPokedex();
      });
      return const Center(
        child: CircularProgressIndicator(color: Colors.redAccent),
      );
    }

    // 2. Loading State
    if (state is PokedexLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.redAccent),
      );
    }

    // 3. Error State: Using your beautiful error UI
    if (state is PokedexError) {
      return _buildErrorState(state.message, ref);
    }

    // 4. Loaded State: Using your beautiful GridView
    if (state is PokedexLoaded) {
      if (state.pokemons.isEmpty) {
        return const Center(child: Text('No Pokémon found in the wild.'));
      }

      return RefreshIndicator(
        color: Colors.redAccent,
        onRefresh: () =>
            ref.read(pokedexNotifierProvider.notifier).fetchPokedex(),
        child: GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.7,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: state.pokemons.length,
          itemBuilder: (context, index) {
            return _buildPokemonCard(state.pokemons[index]);
          },
        ),
      );
    }

    return const SizedBox();
  }

  Widget _buildPokemonImage(String imageSource) {
    // Check if the image source is a URL
    bool isUrl =
        imageSource.startsWith('http') || imageSource.startsWith('https');

    if (isUrl) {
      return Image.network(
        imageSource,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                  : null,
              color: Colors.redAccent.withValues(alpha: 0.3),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) => const Text(
          '👾', // Fallback emoji if the URL fails to load
          style: TextStyle(fontSize: 40),
        ),
      );
    } else {
      // If it's not a URL, treat it as an Emoji string
      return Text(
        imageSource.isEmpty ? '🥚' : imageSource,
        style: const TextStyle(fontSize: 50),
      );
    }
  }

  // Your beautiful Card design
  Widget _buildPokemonCard(PokemonEntity pokemon) {
    return GestureDetector(
      onTap: () => debugPrint('Tapped ${pokemon.name}'),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: .15),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              // Background Pokeball Pattern Decor
              Positioned(
                bottom: -20,
                right: -20,
                child: Icon(
                  Icons.catching_pokemon,
                  size: 100,
                  color: Colors.grey[100],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ID Badge
                    Align(
                      alignment: Alignment.topRight,
                      child: Text(
                        '#${pokemon.id.toString().padLeft(3, '0')}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[400],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(child: _buildPokemonImage(pokemon.image)),
                    ),
                    const Spacer(),
                    Text(
                      pokemon.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.redAccent.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        pokemon.type,
                        style: const TextStyle(
                          color: Colors.redAccent,
                          fontSize: 11,
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
      ),
    );
  }

  // Your beautiful Error UI
  Widget _buildErrorState(String error, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 60, color: Colors.redAccent),
          const SizedBox(height: 16),
          Text(
            'Search failed: $error',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () =>
                ref.read(pokedexNotifierProvider.notifier).fetchPokedex(),
            child: const Text(
              'Try Again',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
