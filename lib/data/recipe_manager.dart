import 'package:flutter/widgets.dart';

import '../models/recipe.dart';
import 'recipe_exceptions.dart';
import 'recipe_repository.dart';

enum RecipeSortOrder { title, duration }

class RecipeManager extends ChangeNotifier {
  static const categories = ['Entrée', 'Plat', 'Dessert'];
  static const difficulties = ['Facile', 'Moyen', 'Difficile'];

  final RecipeRepository _repository;
  final ValueNotifier<List<Recipe>> recipesNotifier = ValueNotifier([]);
  bool _initialized = false;

  RecipeManager({required this._repository});

  Future<void> initialize({required List<Recipe> initialRecipes}) async {
    if (_initialized) return;
    final storedRecipes = await _repository.readAll();
    final recipes = storedRecipes ?? List<Recipe>.unmodifiable(initialRecipes);
    if (storedRecipes == null) {
      await _repository.writeAll(recipes);
    }
    recipesNotifier.value = List.unmodifiable(recipes);
    _initialized = true;
  }

  List<Recipe> search({
    String query = '',
    String category = 'Tout',
    RecipeSortOrder sortOrder = RecipeSortOrder.title,
  }) {
    final normalizedQuery = query.trim().toLowerCase();
    final results = recipesNotifier.value.where((recipe) {
      final matchesCategory = category == 'Tout' || recipe.category == category;
      final matchesQuery =
          normalizedQuery.isEmpty ||
          recipe.title.toLowerCase().contains(normalizedQuery) ||
          recipe.ingredients.any(
            (ingredient) => ingredient.toLowerCase().contains(normalizedQuery),
          );
      return matchesCategory && matchesQuery;
    }).toList();
    results.sort(
      (a, b) => switch (sortOrder) {
        RecipeSortOrder.title => a.title.toLowerCase().compareTo(
          b.title.toLowerCase(),
        ),
        RecipeSortOrder.duration => a.durationMinutes.compareTo(
          b.durationMinutes,
        ),
      },
    );
    return results;
  }

  Future<void> addRecipe({
    required String title,
    required String category,
    required int durationMinutes,
    required String difficulty,
    required List<String> ingredients,
  }) async {
    final normalizedTitle = title.trim();
    final normalizedIngredients = ingredients
        .map((ingredient) => ingredient.trim())
        .where((ingredient) => ingredient.isNotEmpty)
        .toList();
    if (normalizedTitle.isEmpty) {
      throw const InvalidRecipeException(
        'Le nom de la recette est obligatoire.',
      );
    }
    if (!categories.contains(category)) {
      throw const InvalidRecipeException('Choisis une catégorie valide.');
    }
    if (durationMinutes < 1) {
      throw const InvalidRecipeException(
        'La durée doit être supérieure à zéro.',
      );
    }
    if (!difficulties.contains(difficulty)) {
      throw const InvalidRecipeException('Choisis une difficulté valide.');
    }
    if (normalizedIngredients.isEmpty) {
      throw const InvalidRecipeException('Ajoute au moins un ingrédient.');
    }
    if (recipesNotifier.value.any(
      (recipe) => recipe.title.toLowerCase() == normalizedTitle.toLowerCase(),
    )) {
      throw const InvalidRecipeException('Une recette porte déjà ce nom.');
    }

    final newRecipe = Recipe(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: normalizedTitle,
      category: category,
      durationMinutes: durationMinutes,
      difficulty: difficulty,
      imageUrl: '',
      ingredients: normalizedIngredients,
    );
    await _persist([...recipesNotifier.value, newRecipe]);
  }

  Future<void> toggleFavorite(String id) async {
    final recipeIndex = recipesNotifier.value.indexWhere(
      (recipe) => recipe.id == id,
    );
    if (recipeIndex < 0) {
      throw RecipeNotFoundException('Recette introuvable : $id');
    }
    final updatedRecipes = List<Recipe>.of(recipesNotifier.value);
    final recipe = updatedRecipes[recipeIndex];
    updatedRecipes[recipeIndex] = recipe.copyWith(
      isFavorite: !recipe.isFavorite,
    );
    await _persist(updatedRecipes);
  }

  Future<void> deleteRecipe(String id) async {
    final updatedRecipes = recipesNotifier.value
        .where((recipe) => recipe.id != id)
        .toList();
    if (updatedRecipes.length == recipesNotifier.value.length) {
      throw RecipeNotFoundException('Recette introuvable : $id');
    }
    await _persist(updatedRecipes);
  }

  Future<void> _persist(List<Recipe> recipes) async {
    await _repository.writeAll(recipes);
    recipesNotifier.value = List.unmodifiable(recipes);
    notifyListeners();
  }

  @override
  void dispose() {
    recipesNotifier.dispose();
    super.dispose();
  }
}

class RecipeManagerScope extends InheritedWidget {
  final RecipeManager manager;

  const RecipeManagerScope({
    super.key,
    required this.manager,
    required super.child,
  });

  static RecipeManager of(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<RecipeManagerScope>();
    assert(scope != null, 'RecipeManagerScope introuvable dans l’arbre.');
    return scope!.manager;
  }

  @override
  bool updateShouldNotify(RecipeManagerScope oldWidget) =>
      manager != oldWidget.manager;
}
