import 'package:flutter/material.dart';
import 'CategoryItem.dart';

class CategoriesCarousel extends StatelessWidget {
  final List<Map<String, dynamic>> categorias;
  final Function(Map<String, dynamic>)? onCategoryTap;

  const CategoriesCarousel({
    super.key,
    required this.categorias,
    this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categorias
            .map((cat) => CategoryItem(
                  categoria: cat,
                  onTap: () => onCategoryTap?.call(cat),
                ))
            .toList(),
      ),
    );
  }
}