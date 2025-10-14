import 'package:flutter/material.dart';

/// Widget para botón de retroceso reutilizable
class CustomBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final double size;
  final String? iconPath;
  final Color? color;

  const CustomBackButton({
    super.key,
    this.onPressed,
    this.size = 40,
    this.iconPath,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed ?? () => Navigator.pop(context),
      child: iconPath != null
          ? Image.asset(
              iconPath!,
              width: size,
              height: size,
            )
          : Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: color ?? Colors.grey.shade100,
                borderRadius: BorderRadius.circular(size / 2),
              ),
              child: Icon(
                Icons.arrow_back_ios_new,
                color: color != null ? Colors.white : Colors.black87,
                size: size * 0.5,
              ),
            ),
    );
  }
}