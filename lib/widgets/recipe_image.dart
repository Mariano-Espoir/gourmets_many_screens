import 'package:flutter/material.dart';

class RecipeImage extends StatelessWidget {
  final String imageUrl;
  final double? height;
  final BoxFit fit;

  const RecipeImage({
    super.key,
    required this.imageUrl,
    this.height,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) {
      return _placeholder(context);
    }

    return Image.network(
      imageUrl,
      height: height,
      width: double.infinity,
      fit: fit,
      errorBuilder: (context, error, stackTrace) => _placeholder(context),
    );
  }

  Widget _placeholder(BuildContext context) => SizedBox(
    height: height,
    width: double.infinity,
    child: ColoredBox(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Icon(
        Icons.restaurant,
        size: 44,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    ),
  );
}
