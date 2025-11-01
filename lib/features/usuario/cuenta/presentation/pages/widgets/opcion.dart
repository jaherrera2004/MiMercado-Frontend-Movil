import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Opcion extends StatelessWidget {
  final String nombre;
  final String iconPath;
  final VoidCallback? onTap;

  const Opcion({
    super.key,
    required this.nombre,
    required this.iconPath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Material(
          elevation: 3, // controla la sombra
          borderRadius: BorderRadius.circular(20),
          color: Colors.grey.shade200,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Image.asset(
                  iconPath,
                  width: 28,
                  height: 28,
                ),
                const SizedBox(width: 16),
                Text(
                  nombre,
                  style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


