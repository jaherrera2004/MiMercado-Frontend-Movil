import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Widget que muestra la imagen de perfil y nombre del usuario
class PerfilHeader extends StatelessWidget {
  final String? nombre;
  final String? imagenPath;

  const PerfilHeader({
    super.key,
    this.nombre = "Nombre",
    this.imagenPath = 'lib/resources/usuarioIMG.png',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 50),
        
        // Imagen circular y nombre
        Center(
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage(imagenPath!),
                backgroundColor: Colors.grey.shade200,
              ),
              const SizedBox(height: 10),
              Text(
                nombre!,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 30),
      ],
    );
  }
}