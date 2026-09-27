import 'package:flutter_test/flutter_test.dart';
import 'package:many_screens/data/recipe_exceptions.dart';
import 'package:many_screens/data/recipe_manager.dart';
import 'package:many_screens/data/sample_recipes.dart';
import 'package:many_screens/models/recipe.dart';

import 'support/in_memory_recipe_repository.dart';

void main() {
  late InMemoryRecipeRepository repository;
  late RecipeManager manager;

  setUp(() async {
    repository = InMemoryRecipeRepository();
    manager = RecipeManager(repository: repository);
    await manager.initialize(initialRecipes: sampleRecipes);
  });

  tearDown(() => manager.dispose());

  test(
    'initialization writes seed recipes once and then restores stored data',
    () async {
      expect(manager.recipesNotifier.value, hasLength(sampleRecipes.length));
      expect(repository.writes, 1);

      final restoredManager = RecipeManager(repository: repository);
      await restoredManager.initialize(initialRecipes: const []);
      expect(
        restoredManager.recipesNotifier.value,
        hasLength(sampleRecipes.length),
      );
      expect(repository.writes, 1);
      restoredManager.dispose();
    },
  );

  test('search filters by title and ingredients and sorts results', () {
    expect(
      manager.search(query: 'mousse').single.title,
      'Mousse au Chocolat Intense',
    );
    expect(
      manager.search(query: 'poivre').single.title,
      'Pâtes Carbonara Traditionnelles',
    );
    expect(manager.search(category: 'Entrée'), hasLength(2));
    expect(manager.search().first.title, 'Mousse au Chocolat Intense');
    expect(
      manager.search(sortOrder: RecipeSortOrder.duration).first.durationMinutes,
      10,
    );
  });

  test('adding a valid recipe persists it', () async {
    await manager.addRecipe(
      title: '  Soupe maison ',
      category: 'Entrée',
      durationMinutes: 35,
      difficulty: 'Facile',
      ingredients: [' Carottes ', '', 'Eau'],
    );

    final recipe = manager.search(query: 'soupe').single;
    expect(recipe.title, 'Soupe maison');
    expect(recipe.ingredients, ['Carottes', 'Eau']);
    expect(repository.writes, 2);
  });

  test('adding invalid recipes throws a domain exception', () async {
    await expectLater(
      manager.addRecipe(
        title: ' ',
        category: 'Plat',
        durationMinutes: 5,
        difficulty: 'Facile',
        ingredients: ['Eau'],
      ),
      throwsA(isA<InvalidRecipeException>()),
    );
    await expectLater(
      manager.addRecipe(
        title: 'Nouveau plat',
        category: 'Autre',
        durationMinutes: 5,
        difficulty: 'Facile',
        ingredients: ['Eau'],
      ),
      throwsA(isA<InvalidRecipeException>()),
    );
    await expectLater(
      manager.addRecipe(
        title: 'Nouveau plat',
        category: 'Plat',
        durationMinutes: 0,
        difficulty: 'Facile',
        ingredients: ['Eau'],
      ),
      throwsA(isA<InvalidRecipeException>()),
    );
    await expectLater(
      manager.addRecipe(
        title: 'Nouveau plat',
        category: 'Plat',
        durationMinutes: 5,
        difficulty: 'Facile',
        ingredients: [' '],
      ),
      throwsA(isA<InvalidRecipeException>()),
    );
  });

  test('duplicate recipe names are rejected case-insensitively', () async {
    await expectLater(
      manager.addRecipe(
        title: sampleRecipes.first.title.toUpperCase(),
        category: 'Plat',
        durationMinutes: 5,
        difficulty: 'Facile',
        ingredients: ['Eau'],
      ),
      throwsA(isA<InvalidRecipeException>()),
    );
  });

  test('favorite changes and deletion persist', () async {
    final id = sampleRecipes.first.id;
    await manager.toggleFavorite(id);
    expect(manager.recipesNotifier.value.first.isFavorite, isTrue);

    await manager.deleteRecipe(id);
    expect(
      manager.recipesNotifier.value.any((recipe) => recipe.id == id),
      isFalse,
    );
    expect(repository.writes, 3);
  });

  test('unknown recipe actions throw RecipeNotFoundException', () async {
    await expectLater(
      manager.toggleFavorite('unknown'),
      throwsA(isA<RecipeNotFoundException>()),
    );
    await expectLater(
      manager.deleteRecipe('unknown'),
      throwsA(isA<RecipeNotFoundException>()),
    );
  });

  test('recipe JSON round trip preserves all fields', () {
    final recipe = sampleRecipes.first.copyWith(isFavorite: true);
    expect(Recipe.fromJson(recipe.toJson()).toJson(), recipe.toJson());
  });

  test('invalid recipe JSON is rejected', () {
    expect(() => Recipe.fromJson({'id': 'broken'}), throwsFormatException);
  });
}
