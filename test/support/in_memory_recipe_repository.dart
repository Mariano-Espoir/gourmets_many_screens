import 'package:many_screens/data/recipe_repository.dart';
import 'package:many_screens/models/recipe.dart';

class InMemoryRecipeRepository implements RecipeRepository {
  List<Recipe>? values;
  int writes = 0;

  InMemoryRecipeRepository({List<Recipe>? initialValues})
    : values = initialValues;

  @override
  Future<List<Recipe>?> readAll() async => values;

  @override
  Future<void> writeAll(List<Recipe> recipes) async {
    writes++;
    values = List.unmodifiable(recipes);
  }
}
