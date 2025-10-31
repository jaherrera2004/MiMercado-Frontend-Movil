import 'package:flutter/material.dart';

class CategoriaSearchBar extends StatelessWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onSubmitted;

  const CategoriaSearchBar({
    super.key,
    this.hintText = "Buscar...",
    this.onChanged,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      onSubmitted: (value) => onSubmitted?.call(),
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search),
        hintText: hintText,
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}