class RecipeException implements Exception {
  final String message;
  const RecipeException(this.message);

  @override
  String toString() => message;
}

class InvalidRecipeException extends RecipeException {
  const InvalidRecipeException(super.message);
}

class RecipeNotFoundException extends RecipeException {
  const RecipeNotFoundException(super.message);
}

class RecipeStorageException extends RecipeException {
  const RecipeStorageException(super.message);
}
