import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/home_screen.dart';
import '../screens/list_screen.dart';
import '../screens/detail_screen.dart';
import '../screens/add_recipe_screen.dart';
import '../screens/favorites_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  errorBuilder: (context, state) => Scaffold(
    appBar: AppBar(title: const Text('Page introuvable')),
    body: const Center(child: Text('La page demandée est introuvable.')),
  ),
  routes: [
    GoRoute(
      name: 'home',
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      name: 'recipes',
      path: '/recipes',
      builder: (context, state) => const ListScreen(),
    ),
    GoRoute(
      name: 'favorites',
      path: '/recipes/favorites',
      builder: (context, state) => const FavoritesScreen(),
    ),
    GoRoute(
      name: 'recipe-details',
      path: '/details/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return DetailScreen(recipeId: id);
      },
    ),
    GoRoute(
      name: 'add-recipe',
      path: '/add',
      builder: (context, state) => const AddRecipeScreen(),
    ),
  ],
);
