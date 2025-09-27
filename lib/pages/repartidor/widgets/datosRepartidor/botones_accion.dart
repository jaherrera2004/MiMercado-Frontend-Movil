import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BotonesAccion extends StatelessWidget {
  final VoidCallback onEditarInformacion;
  final VoidCallback onCambiarFoto;

  const BotonesAccion({
    super.key,
    required this.onEditarInformacion,
    required this.onCambiarFoto,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Botón editar información
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: onEditarInformacion,
            icon: const Icon(Icons.edit, color: Colors.white),
            label: Text(
              'Editar Información',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF58E181),
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 12),
        
        // Botón cambiar foto
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: onCambiarFoto,
            icon: const Icon(Icons.camera_alt, color: Color(0xFF58E181)),
            label: Text(
              'Cambiar Foto de Perfil',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                color: const Color(0xFF58E181),
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFF58E181)),
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }
}