import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/custom_button.dart';
import '../widgets/theme_toggle_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: const [ThemeToggleButton()],
      ),
      body: Stack(
        // Widget 1: Stack
        children: [
          Positioned.fill(
            child: Image.network(
              'https://images.unsplash.com/photo-1498837167922-ddd27525d352?auto=format&fit=crop&w=1600&q=80',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const ColoredBox(color: Color(0xFF493522)),
            ),
          ),
          Positioned.fill(
            child: Container(color: Colors.black.withValues(alpha: 0.5)),
          ),
          Center(
            child: Column(
              // Widget 2: Column
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Gourmet App',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                CustomButton(
                  text: 'Découvrir les recettes',
                  onPressed: () => context.pushNamed('recipes'),
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: () => context.pushNamed('add-recipe'),
                  icon: const Icon(Icons.add),
                  label: const Text('Ajouter une recette'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
