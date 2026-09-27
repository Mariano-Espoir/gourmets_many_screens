import 'package:flutter/material.dart';

class Recipe {
  final String id;
  final String title;
  final String category;
  final String duration;
  final String difficulty;
  final String imageUrl;
  final List<String> ingredients;
  bool isFavorite;

  Recipe({
    required this.id,
    required this.title,
    required this.category,
    required this.duration,
    required this.difficulty,
    required this.imageUrl,
    required this.ingredients,
    this.isFavorite = false,
  });
}

// Utilisation d'un ValueNotifier pour notifier toute l'application en cas de changement de favori
class RecipeRepository {
  static const List<String> categories = ['Entrée', 'Plat', 'Dessert'];
  static const List<String> difficulties = ['Facile', 'Moyen', 'Difficile'];

  static final ValueNotifier<List<Recipe>> recipesNotifier = ValueNotifier([
    Recipe(
      id: '1',
      title: 'Pâtes Carbonara Traditionnelles',
      category: 'Plat',
      duration: '20 min',
      difficulty: 'Facile',
      imageUrl:
          'https://images.unsplash.com/photo-1473093295043-cdd812d0e601?auto=format&fit=crop&w=900&q=80',
      ingredients: [
        'Guanciale ou Lardons (200g)',
        'Pâtes Rigatoni (400g)',
        'Pecorino Romano (Spécifique)',
        ' Jaunes d\'œufs (4)',
        'Poivre noir',
      ],
    ),
    Recipe(
      id: '2',
      title: 'Mousse au Chocolat Intense',
      category: 'Dessert',
      duration: '15 min',
      difficulty: 'Facile',
      imageUrl:
          'https://images.unsplash.com/photo-1511715112108-9acc6c3ff49f?auto=format&fit=crop&w=900&q=80',
      ingredients: [
        'Chocolat noir 70% (200g)',
        'Œufs frais (6)',
        'Pincée de sel',
      ],
    ),
    Recipe(
      id: '3',
      title: 'Salade César Croustillante',
      category: 'Entrée',
      duration: '15 min',
      difficulty: 'Moyen',
      imageUrl:
          'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=900&q=80',
      ingredients: [
        'Romaine',
        'Blancs de poulet grillés',
        'Croûtons dorés à l\'ail',
        'Sauce César maison',
        'Copeaux de Parmesan',
      ],
    ),
    Recipe(
      id: '4',
      title: 'Tartare de Saumon à l\'Avocat',
      category: 'Entrée',
      duration: '10 min',
      difficulty: 'Moyen',
      imageUrl:
          'https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?auto=format&fit=crop&w=900&q=80',
      ingredients: [
        'Saumon frais (300g)',
        'Avocats mûrs (2)',
        'Citron vert',
        'Aneth fraîche',
        'Huile d\'olive',
      ],
    ),
  ]);

  static void addRecipe({
    required String title,
    required String category,
    required String duration,
    required String difficulty,
    required List<String> ingredients,
  }) {
    final recipe = Recipe(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title,
      category: category,
      duration: duration,
      difficulty: difficulty,
      imageUrl: '',
      ingredients: List.unmodifiable(ingredients),
    );
    recipesNotifier.value = [...recipesNotifier.value, recipe];
  }

  static void toggleFavorite(String id) {
    final updatedList = List<Recipe>.from(recipesNotifier.value);
    final index = updatedList.indexWhere((r) => r.id == id);
    if (index != -1) {
      updatedList[index].isFavorite = !updatedList[index].isFavorite;
      recipesNotifier.value =
          updatedList; // Déclenche la reconstruction des widgets écoutant
    }
  }
}
