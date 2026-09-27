import 'package:flutter/material.dart';
import '../data/recipe_data.dart';
import '../widgets/responsive_layout.dart';
import '../widgets/recipe_image.dart';
import '../widgets/theme_toggle_button.dart';

class DetailScreen extends StatelessWidget {
  final String recipeId;
  const DetailScreen({super.key, required this.recipeId});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<Recipe>>(
      valueListenable: RecipeRepository.recipesNotifier,
      builder: (context, list, child) {
        final matches = list.where((recipe) => recipe.id == recipeId);
        if (matches.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: const Text('Recette introuvable')),
            body: const Center(child: Text('Cette recette n’existe plus.')),
          );
        }
        final recipe = matches.first;

        return Scaffold(
          appBar: AppBar(
            title: Text(recipe.title),
            actions: [
              IconButton(
                icon: Icon(
                  recipe.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: recipe.isFavorite ? Colors.red : null,
                ),
                onPressed: () => RecipeRepository.toggleFavorite(recipe.id),
              ),
              const ThemeToggleButton(),
            ],
          ),
          // Injection de la logique responsive
          body: ResponsiveLayout(
            mobileBody: _buildMobileLayout(context, recipe),
            tabletBody: _buildTabletLayout(context, recipe),
          ),
        );
      },
    );
  }

  // --- Affichage Classique pour Smartphones ---
  Widget _buildMobileLayout(BuildContext context, Recipe recipe) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RecipeImage(imageUrl: recipe.imageUrl, height: 250),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildDetailsContent(context, recipe),
          ),
        ],
      ),
    );
  }

  // --- Affichage Deux Colonnes pour Tablettes et Ordinateurs ---
  Widget _buildTabletLayout(BuildContext context, Recipe recipe) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: SizedBox(
            height: double.infinity,
            child: RecipeImage(imageUrl: recipe.imageUrl, fit: BoxFit.cover),
          ),
        ),
        Expanded(
          flex: 6,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: SingleChildScrollView(
              child: _buildDetailsContent(context, recipe),
            ),
          ),
        ),
      ],
    );
  }

  // Contenu textuel partagé (évite la duplication de code)
  Widget _buildDetailsContent(BuildContext context, Recipe recipe) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8,
          runSpacing: 4,
          children: [
            Chip(
              label: Text(recipe.category),
              backgroundColor: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.1),
            ),
            Chip(label: Text('Difficulté : ${recipe.difficulty}')),
            Text(
              recipe.duration,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        const SizedBox(height: 25),
        const Text(
          'Ingrédients requis',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const Divider(thickness: 2),
        const SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: recipe.ingredients.length,
          itemBuilder: (context, index) {
            return Card(
              color: Colors.transparent,
              elevation: 0,
              child: ListTile(
                leading: const Icon(
                  Icons.lens,
                  size: 10,
                  color: Colors.deepOrange,
                ),
                title: Text(
                  recipe.ingredients[index],
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
