import 'package:flutter/material.dart';

class CategoryItem extends StatelessWidget {
  final Map<String, dynamic> categoria;
  final VoidCallback? onTap;

  const CategoryItem({
    super.key,
    required this.categoria,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey[200],
              radius: 30,
              backgroundImage: AssetImage(categoria["img"]),
            ),
            const SizedBox(height: 5),
            Text(categoria["label"]),
          ],
        ),
      ),
    );
  }
}