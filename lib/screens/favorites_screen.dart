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
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Aucun favori pour le moment. Touchez le cœur d’une recette pour la retrouver ici.',
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
              return GridView.builder(
                padding: const EdgeInsets.all(12),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.85,
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
              );
            },
          );
        },
      ),
    );
  }
}
