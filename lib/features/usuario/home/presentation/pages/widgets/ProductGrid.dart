import 'package:flutter/material.dart';
import 'ProductCard.dart';

class ProductGrid extends StatelessWidget {
  final List<Map<String, dynamic>> productos;
  final Function(Map<String, dynamic>)? onAddToCart;

  const ProductGrid({
    super.key,
    required this.productos,
    this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: productos.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (context, index) {
        final producto = productos[index];
        return ProductCard(
          producto: producto,
          onAddToCart: () => onAddToCart?.call(producto),
        );
      },
    );
  }
}