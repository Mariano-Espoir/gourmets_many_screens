import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/recipe_data.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/recipe_card.dart';
import '../widgets/theme_toggle_button.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  String _searchQuery = '';
  String _selectedCategory = 'Tout';
  List<String> get _categories => ['Tout', ...RecipeRepository.categories];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explorateur Gourmet'),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Afficher les favoris',
            icon: const Icon(Icons.favorite),
            onPressed: () => context.pushNamed('favorites'),
          ),
          const ThemeToggleButton(),
        ],
      ),
      body: ValueListenableBuilder<List<Recipe>>(
        valueListenable: RecipeRepository.recipesNotifier,
        builder: (context, recipesList, child) {
          // Filtrage intelligent combinant la catégorie et la recherche textuelle
          final filteredRecipes = recipesList.where((recipe) {
            final matchesCategory =
                _selectedCategory == 'Tout' ||
                recipe.category == _selectedCategory;
            final query = _searchQuery.trim().toLowerCase();
            final matchesSearch =
                recipe.title.toLowerCase().contains(query) ||
                recipe.ingredients.any(
                  (ingredient) => ingredient.toLowerCase().contains(query),
                );
            return matchesCategory && matchesSearch;
          }).toList();

          return Column(
            children: [
              // 1. Barre de recherche
              SearchBarWidget(
                onChanged: (value) => setState(() => _searchQuery = value),
              ),

              // 2. Filtres par Catégorie (Défilant horizontalement)
              SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final category = _categories[index];
                    final isSelected = _selectedCategory == category;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: ChoiceChip(
                        label: Text(category),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() => _selectedCategory = category);
                          }
                        },
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),

              // 3. Grille adaptative basée sur LayoutBuilder (Résolution complète de la responsivité)
              Expanded(
                child: filteredRecipes.isEmpty
                    ? const Center(child: Text('Aucune recette trouvée.'))
                    : LayoutBuilder(
                        builder: (context, constraints) {
                          // Calcul dynamique des colonnes selon la largeur réelle de l'affichage
                          int crossAxisCount = 1;
                          if (constraints.maxWidth >= 1200) {
                            crossAxisCount =
                                4; // Écrans PC / Grandes tablettes paysage
                          } else if (constraints.maxWidth >= 800) {
                            crossAxisCount = 3; // Tablettes standard
                          } else if (constraints.maxWidth >= 500) {
                            crossAxisCount =
                                2; // Grands smartphones / Tablettes portrait
                          }

                          return GridView.builder(
                            padding: const EdgeInsets.all(12),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: crossAxisCount,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                  childAspectRatio: 0.85,
                                ),
                            itemCount: filteredRecipes.length,
                            itemBuilder: (context, index) {
                              final recipe = filteredRecipes[index];
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
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
