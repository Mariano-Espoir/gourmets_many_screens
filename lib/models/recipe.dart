class Recipe {
  final String id;
  final String title;
  final String category;
  final int durationMinutes;
  final String difficulty;
  final String imageUrl;
  final List<String> ingredients;
  final bool isFavorite;

  Recipe({
    required this.id,
    required this.title,
    required this.category,
    required this.durationMinutes,
    required this.difficulty,
    required this.imageUrl,
    required List<String> ingredients,
    this.isFavorite = false,
  }) : ingredients = List.unmodifiable(ingredients);

  String get duration => '$durationMinutes min';

  Recipe copyWith({bool? isFavorite}) => Recipe(
    id: id,
    title: title,
    category: category,
    durationMinutes: durationMinutes,
    difficulty: difficulty,
    imageUrl: imageUrl,
    ingredients: ingredients,
    isFavorite: isFavorite ?? this.isFavorite,
  );

  Map<String, Object?> toJson() => {
    'id': id,
    'title': title,
    'category': category,
    'durationMinutes': durationMinutes,
    'difficulty': difficulty,
    'imageUrl': imageUrl,
    'ingredients': ingredients,
    'isFavorite': isFavorite,
  };

  factory Recipe.fromJson(Map<String, Object?> json) {
    try {
      final ingredientsValue = json['ingredients'];
      if (ingredientsValue is! List ||
          ingredientsValue.any((ingredient) => ingredient is! String)) {
        throw const FormatException('La liste des ingrédients est invalide.');
      }

      final recipe = Recipe(
        id: _readString(json, 'id'),
        title: _readString(json, 'title'),
        category: _readString(json, 'category'),
        durationMinutes: _readInt(json, 'durationMinutes'),
        difficulty: _readString(json, 'difficulty'),
        imageUrl: _readString(json, 'imageUrl'),
        ingredients: ingredientsValue.cast<String>(),
        isFavorite: json['isFavorite'] as bool? ?? false,
      );
      if (recipe.id.isEmpty ||
          recipe.title.trim().isEmpty ||
          recipe.durationMinutes < 1) {
        throw const FormatException(
          'Les données de la recette sont invalides.',
        );
      }
      return recipe;
    } on TypeError catch (error) {
      throw FormatException('Format de recette incorrect : $error');
    }
  }

  static String _readString(Map<String, Object?> json, String key) {
    final value = json[key];
    if (value is! String) {
      throw FormatException('Le champ "$key" est invalide.');
    }
    return value;
  }

  static int _readInt(Map<String, Object?> json, String key) {
    final value = json[key];
    if (value is! int) {
      throw FormatException('Le champ "$key" est invalide.');
    }
    return value;
  }
}
