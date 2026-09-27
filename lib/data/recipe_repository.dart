import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/recipe.dart';
import 'recipe_exceptions.dart';

abstract interface class Repository<T> {
  Future<List<T>?> readAll();
  Future<void> writeAll(List<T> values);
}

abstract interface class RecipeRepository implements Repository<Recipe> {}

class SharedPreferencesJsonRepository<T> implements Repository<T> {
  final SharedPreferences preferences;
  final String storageKey;
  final Map<String, Object?> Function(T value) encode;
  final T Function(Map<String, Object?> json) decode;

  const SharedPreferencesJsonRepository({
    required this.preferences,
    required this.storageKey,
    required this.encode,
    required this.decode,
  });

  @override
  Future<List<T>?> readAll() async {
    final rawJson = preferences.getString(storageKey);
    if (rawJson == null) return null;

    try {
      final decoded = jsonDecode(rawJson);
      if (decoded is! List) {
        throw const FormatException('La racine JSON doit être une liste.');
      }
      return decoded.map((item) {
        if (item is! Map<String, dynamic>) {
          throw const FormatException('Une entrée JSON est invalide.');
        }
        return decode(item);
      }).toList();
    } on FormatException catch (error) {
      throw RecipeStorageException('Impossible de lire les recettes : $error');
    } on TypeError catch (error) {
      throw RecipeStorageException(
        'Format JSON des recettes invalide : $error',
      );
    }
  }

  @override
  Future<void> writeAll(List<T> values) async {
    try {
      final rawJson = jsonEncode(values.map(encode).toList());
      final saved = await preferences.setString(storageKey, rawJson);
      if (!saved) {
        throw const RecipeStorageException('Échec de sauvegarde des recettes.');
      }
    } on RecipeStorageException {
      rethrow;
    } on Object catch (error) {
      throw RecipeStorageException(
        'Impossible de sauvegarder les recettes : $error',
      );
    }
  }
}

class JsonRecipeRepository extends SharedPreferencesJsonRepository<Recipe>
    implements RecipeRepository {
  const JsonRecipeRepository({
    required super.preferences,
    required super.storageKey,
    required super.encode,
    required super.decode,
  });
}
