import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/recipe_manager.dart';
import '../models/recipe.dart';
import '../widgets/recipe_image.dart';
import '../widgets/theme_toggle_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final manager = RecipeManagerScope.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gourmet App'),
        actions: [
          ValueListenableBuilder<List<Recipe>>(
            valueListenable: manager.recipesNotifier,
            builder: (context, recipes, child) {
              final favoriteCount = recipes
                  .where((recipe) => recipe.isFavorite)
                  .length;
              return IconButton(
                tooltip: 'Afficher les favoris',
                onPressed: () => context.pushNamed('favorites'),
                icon: Badge(
                  isLabelVisible: favoriteCount > 0,
                  label: Text('$favoriteCount'),
                  child: const Icon(Icons.favorite_border),
                ),
              );
            },
          ),
          const ThemeToggleButton(),
        ],
      ),
      body: ValueListenableBuilder<List<Recipe>>(
        valueListenable: manager.recipesNotifier,
        builder: (context, recipes, child) {
          final featuredRecipes = manager.search().take(3).toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: SizedBox(
                    height: 250,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          'https://images.unsplash.com/photo-1498837167922-ddd27525e352?auto=format&fit=crop&w=1600&q=80',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const ColoredBox(color: Color(0xFF493522)),
                        ),
                        const ColoredBox(color: Color(0x77000000)),
                        Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'LE PLAISIR DU FAIT MAISON',
                                style: Theme.of(context).textTheme.labelLarge
                                    ?.copyWith(
                                      color: Colors.white,
                                      letterSpacing: 1.2,
                                    ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Une bonne idée\npour aujourd’hui.',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: 16),
                              FilledButton.icon(
                                onPressed: () => context.pushNamed('recipes'),
                                icon: const Icon(Icons.restaurant_menu),
                                label: const Text('Découvrir les recettes'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'À découvrir',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () => context.pushNamed('recipes'),
                      icon: const Icon(Icons.arrow_forward, size: 18),
                      label: const Text('Tout voir'),
                    ),
                  ],
                ),
                if (featuredRecipes.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Text('Aucune recette pour le moment.'),
                  )
                else
                  for (final recipe in featuredRecipes)
                    _RecipePreview(
                      recipe: recipe,
                      onTap: () => context.pushNamed(
                        'recipe-details',
                        pathParameters: {'id': recipe.id},
                      ),
                    ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () => context.pushNamed('add-recipe'),
                  icon: const Icon(Icons.add),
                  label: const Text('Ajouter une recette'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _RecipePreview extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback onTap;

  const _RecipePreview({required this.recipe, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 72,
                  height: 72,
                  child: RecipeImage(imageUrl: recipe.imageUrl, height: 72),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text('${recipe.category} · ${recipe.duration}'),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
