import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/recipe_manager.dart';
import 'data/recipe_repository.dart';
import 'data/sample_recipes.dart';
import 'models/recipe.dart';
import 'routes/app_router.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final preferences = await SharedPreferences.getInstance();
  final repository = JsonRecipeRepository(
    preferences: preferences,
    storageKey: 'gourmet_app_recipes_v1',
    encode: (recipe) => recipe.toJson(),
    decode: Recipe.fromJson,
  );
  final recipeManager = RecipeManager(repository: repository);
  await recipeManager.initialize(initialRecipes: sampleRecipes);
  runApp(MyApp(recipeManager: recipeManager));
}

class MyApp extends StatelessWidget {
  final RecipeManager recipeManager;

  const MyApp({super.key, required this.recipeManager});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.mode,
      builder: (context, themeMode, child) => MaterialApp.router(
        title: 'Gourmet App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeMode,
        routerConfig: appRouter,
        builder: (context, child) => RecipeManagerScope(
          manager: recipeManager,
          child: child ?? const SizedBox.shrink(),
        ),
      ),
    );
  }
}
