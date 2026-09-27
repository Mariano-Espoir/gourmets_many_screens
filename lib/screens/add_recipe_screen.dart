import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/recipe_exceptions.dart';
import '../data/recipe_manager.dart';

class AddRecipeScreen extends StatefulWidget {
  const AddRecipeScreen({super.key});

  @override
  State<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _durationController = TextEditingController();
  final _ingredientsController = TextEditingController();
  String _selectedCategory = 'Plat';
  String _selectedDifficulty = 'Facile';
  bool _isSaving = false;

  @override
  void dispose() {
    _titleController.dispose();
    _durationController.dispose();
    _ingredientsController.dispose();
    super.dispose();
  }

  Future<void> _submitData() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    final ingredients = _ingredientsController.text
        .split(RegExp(r'[,\n]'))
        .map((ingredient) => ingredient.trim())
        .where((ingredient) => ingredient.isNotEmpty)
        .toList();
    try {
      await RecipeManagerScope.of(context).addRecipe(
        title: _titleController.text,
        category: _selectedCategory,
        durationMinutes: int.parse(_durationController.text.trim()),
        difficulty: _selectedDifficulty,
        ingredients: ingredients,
      );
      if (mounted) context.pop();
    } on RecipeException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error.message)));
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajouter une Recette')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Champ 1 : Titre
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Nom de la recette',
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Veuillez entrer un nom'
                    : null,
              ),
              const SizedBox(height: 15),
              // Champ 2 : Temps de préparation
              TextFormField(
                controller: _durationController,
                decoration: const InputDecoration(
                  labelText: 'Temps de préparation (ex: 15 min)',
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Veuillez entrer une durée'
                    : int.tryParse(value.trim()) == null ||
                          int.parse(value.trim()) < 1
                    ? 'Entrez une durée en minutes supérieure à zéro'
                    : null,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 15),
              // Champ 3 : Menu déroulant (Catégorie)
              DropdownButtonFormField<String>(
                initialValue: _selectedCategory,
                decoration: const InputDecoration(labelText: 'Catégorie'),
                items: RecipeManager.categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedCategory = value);
                  }
                },
              ),
              const SizedBox(height: 15),
              DropdownButtonFormField<String>(
                initialValue: _selectedDifficulty,
                decoration: const InputDecoration(labelText: 'Difficulté'),
                items: RecipeManager.difficulties.map((difficulty) {
                  return DropdownMenuItem(
                    value: difficulty,
                    child: Text(difficulty),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedDifficulty = value);
                  }
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _ingredientsController,
                minLines: 3,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Ingrédients',
                  hintText:
                      'Séparez les ingrédients par une virgule ou un retour à la ligne',
                  alignLabelWithHint: true,
                ),
                validator: (value) {
                  final ingredients = value
                      ?.split(RegExp(r'[,\n]'))
                      .where((ingredient) => ingredient.trim().isNotEmpty)
                      .toList();
                  return ingredients == null || ingredients.isEmpty
                      ? 'Ajoutez au moins un ingrédient'
                      : null;
                },
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _isSaving ? null : _submitData,
                child: _isSaving
                    ? const CircularProgressIndicator()
                    : const Text('Sauvegarder'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
