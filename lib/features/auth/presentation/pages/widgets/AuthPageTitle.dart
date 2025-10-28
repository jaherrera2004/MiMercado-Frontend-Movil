import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Widget para títulos de páginas de autenticación
class AuthPageTitle extends StatelessWidget {
  final String title;
  final double fontSize;
  final FontWeight fontWeight;
  final Color? color;
  final TextAlign textAlign;

  const AuthPageTitle({
    super.key,
    required this.title,
    this.fontSize = 32,
    this.fontWeight = FontWeight.bold,
    this.color,
    this.textAlign = TextAlign.center,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: textAlign,
      style: GoogleFonts.inter(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color ?? Colors.black,
      ),
    );
  }
}