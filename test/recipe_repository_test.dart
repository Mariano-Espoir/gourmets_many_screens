import 'package:flutter_test/flutter_test.dart';
import 'package:many_screens/data/recipe_exceptions.dart';
import 'package:many_screens/data/recipe_repository.dart';
import 'package:many_screens/data/sample_recipes.dart';
import 'package:many_screens/models/recipe.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late JsonRecipeRepository repository;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    repository = JsonRecipeRepository(
      preferences: await SharedPreferences.getInstance(),
      storageKey: 'recipes-test',
      encode: (recipe) => recipe.toJson(),
      decode: Recipe.fromJson,
    );
  });

  test('writes and restores recipes as JSON', () async {
    await repository.writeAll(sampleRecipes);
    final restored = await repository.readAll();

    expect(
      restored?.map((recipe) => recipe.toJson()).toList(),
      sampleRecipes.map((recipe) => recipe.toJson()).toList(),
    );
  });

  test('reports malformed persisted JSON as a storage exception', () async {
    SharedPreferences.setMockInitialValues({'recipes-test': '{invalid'});
    repository = JsonRecipeRepository(
      preferences: await SharedPreferences.getInstance(),
      storageKey: 'recipes-test',
      encode: (recipe) => recipe.toJson(),
      decode: Recipe.fromJson,
    );

    await expectLater(
      repository.readAll(),
      throwsA(isA<RecipeStorageException>()),
    );
  });
}
