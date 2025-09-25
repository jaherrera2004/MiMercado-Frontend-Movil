import 'package:flutter/material.dart';

/// Widget para el botón de retroceso personalizado
class AuthBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final double size;

  const AuthBackButton({
    super.key,
    this.onPressed,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed ?? () => Navigator.pop(context),
      child: Image.asset(
        'lib/resources/go_back_icon.png',
        width: size,
        height: size,
      ),
    );
  }
}