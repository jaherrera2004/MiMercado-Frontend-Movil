import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CamposDatos extends StatelessWidget {
  final String dato;

  const CamposDatos({super.key, required this.dato});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(dato, style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
      onTap: () {},
    );
  }
}
