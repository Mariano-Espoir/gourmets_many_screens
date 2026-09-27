import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/recipe_manager.dart';
import '../models/recipe.dart';
import '../widgets/recipe_card.dart';
import '../widgets/theme_toggle_button.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes favoris'),
        actions: const [ThemeToggleButton()],
      ),
      body: ValueListenableBuilder<List<Recipe>>(
        valueListenable: RecipeManagerScope.of(context).recipesNotifier,
        builder: (context, recipes, child) {
          final favorites = RecipeManagerScope.of(
            context,
          ).search().where((recipe) => recipe.isFavorite).toList();
          if (favorites.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.favorite_border,
                      size: 56,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Aucun favori pour le moment.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Touchez le cœur d’une recette pour la retrouver ici.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }
          return LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth >= 1100
                  ? 4
                  : constraints.maxWidth >= 700
                  ? 3
                  : constraints.maxWidth >= 480
                  ? 2
                  : 1;
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '${favorites.length} favori${favorites.length > 1 ? 's' : ''}',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.all(12),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: columns,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        mainAxisExtent: 220,
                      ),
                      itemCount: favorites.length,
                      itemBuilder: (context, index) {
                        final recipe = favorites[index];
                        return RecipeCard(
                          recipe: recipe,
                          onTap: () => context.pushNamed(
                            'recipe-details',
                            pathParameters: {'id': recipe.id},
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
