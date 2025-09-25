import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Widget para los enlaces de navegación entre pantallas de autenticación
class AuthNavigationLink extends StatelessWidget {
  final String text;
  final String linkText;
  final VoidCallback onTap;
  final Color linkColor;

  const AuthNavigationLink({
    super.key,
    required this.text,
    required this.linkText,
    required this.onTap,
    required this.linkColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          text,
          style: GoogleFonts.inter(
            color: const Color(0xFF878383),
            fontSize: 14,
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            linkText,
            style: GoogleFonts.inter(
              color: linkColor,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}