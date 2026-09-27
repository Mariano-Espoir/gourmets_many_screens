import '../models/recipe.dart';

final List<Recipe> sampleRecipes = [
  Recipe(
    id: '1',
    title: 'Pâtes Carbonara Traditionnelles',
    category: 'Plat',
    durationMinutes: 20,
    difficulty: 'Facile',
    imageUrl:
        'https://images.unsplash.com/photo-1473093295043-cdd812d0e601?auto=format&fit=crop&w=900&q=80',
    ingredients: [
      'Guanciale ou lardons (200 g)',
      'Pâtes rigatoni (400 g)',
      'Pecorino Romano',
      'Jaunes d’œufs (4)',
      'Poivre noir',
    ],
  ),
  Recipe(
    id: '2',
    title: 'Mousse au Chocolat Intense',
    category: 'Dessert',
    durationMinutes: 15,
    difficulty: 'Facile',
    imageUrl:
        'https://images.unsplash.com/photo-1511715112108-9acc6c3ff49f?auto=format&fit=crop&w=900&q=80',
    ingredients: [
      'Chocolat noir 70 % (200 g)',
      'Œufs frais (6)',
      'Pincée de sel',
    ],
  ),
  Recipe(
    id: '3',
    title: 'Salade César Croustillante',
    category: 'Entrée',
    durationMinutes: 15,
    difficulty: 'Moyen',
    imageUrl:
        'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=900&q=80',
    ingredients: [
      'Romaine',
      'Blancs de poulet grillés',
      'Croûtons dorés à l’ail',
      'Sauce César maison',
      'Copeaux de parmesan',
    ],
  ),
  Recipe(
    id: '4',
    title: 'Tartare de Saumon à l’Avocat',
    category: 'Entrée',
    durationMinutes: 10,
    difficulty: 'Moyen',
    imageUrl:
        'https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?auto=format&fit=crop&w=900&q=80',
    ingredients: [
      'Saumon frais (300 g)',
      'Avocats mûrs (2)',
      'Citron vert',
      'Aneth fraîche',
      'Huile d’olive',
    ],
  ),
];
