// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:many_screens/data/recipe_data.dart';
import 'package:many_screens/main.dart';
import 'package:many_screens/routes/app_router.dart';
import 'package:many_screens/theme/app_theme.dart';

void main() {
  setUp(() {
    ThemeController.mode.value = ThemeMode.light;
    appRouter.go('/');
  });

  testWidgets('home navigates to recipe list and search filters recipes', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.text('Découvrir les recettes'));
    await tester.pumpAndSettle();

    expect(find.text('Explorateur Gourmet'), findsOneWidget);
    expect(find.text('Pâtes Carbonara Traditionnelles'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'mousse');
    await tester.pumpAndSettle();
    expect(find.text('Mousse au Chocolat Intense'), findsOneWidget);
    expect(find.text('Pâtes Carbonara Traditionnelles'), findsNothing);
  });

  testWidgets('recipe detail receives its route parameter', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.text('Découvrir les recettes'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Pâtes Carbonara Traditionnelles'));
    await tester.pumpAndSettle();

    expect(find.text('Pâtes Carbonara Traditionnelles'), findsOneWidget);
    expect(find.text('Ingrédients requis'), findsOneWidget);
    expect(find.text('Poivre noir'), findsOneWidget);
  });

  testWidgets('recipe form validates and adds a recipe', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.text('Ajouter une recette'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sauvegarder'));
    await tester.pumpAndSettle();
    expect(find.text('Veuillez entrer un nom'), findsOneWidget);
    expect(find.text('Ajoutez au moins un ingrédient'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).at(0), 'Soupe de test');
    await tester.enterText(find.byType(TextFormField).at(1), '25');
    await tester.enterText(find.byType(TextFormField).at(2), 'Carottes, eau');
    await tester.tap(find.text('Sauvegarder'));
    await tester.pumpAndSettle();

    expect(
      RecipeRepository.recipesNotifier.value.any(
        (recipe) => recipe.title == 'Soupe de test',
      ),
      isTrue,
    );
  });

  testWidgets('theme toggle switches between light and dark', (tester) async {
    await tester.pumpWidget(const MyApp());
    expect(ThemeController.mode.value, ThemeMode.light);
    await tester.tap(find.byTooltip('Activer le thème sombre'));
    await tester.pumpAndSettle();
    expect(ThemeController.mode.value, ThemeMode.dark);
    expect(find.byTooltip('Activer le thème clair'), findsOneWidget);
  });
}
