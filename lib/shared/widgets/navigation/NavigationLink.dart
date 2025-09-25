import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Widget para enlaces de navegación reutilizable
class NavigationLink extends StatelessWidget {
  final String text;
  final String linkText;
  final VoidCallback onTap;
  final Color linkColor;
  final double fontSize;
  final FontWeight linkFontWeight;
  final MainAxisAlignment alignment;

  const NavigationLink({
    super.key,
    required this.text,
    required this.linkText,
    required this.onTap,
    required this.linkColor,
    this.fontSize = 14,
    this.linkFontWeight = FontWeight.w600,
    this.alignment = MainAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: alignment,
      children: [
        Text(
          text,
          style: GoogleFonts.inter(
            color: const Color(0xFF878383),
            fontSize: fontSize,
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            linkText,
            style: GoogleFonts.inter(
              color: linkColor,
              fontWeight: linkFontWeight,
              fontSize: fontSize,
            ),
          ),
        ),
      ],
    );
  }
}