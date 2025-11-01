import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Widget que contiene los botones de acción para cambiar contraseña
class EditarContrasenaBotones extends StatelessWidget {
  final VoidCallback? onCambiar;
  final VoidCallback? onCancelar;
  final bool isLoading;

  const EditarContrasenaBotones({
    super.key,
    this.onCambiar,
    this.onCancelar,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Botón Cambiar contraseña
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isLoading ? null : (onCambiar ?? () {
              // Lógica por defecto para cambiar contraseña
            }),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF58E181), // verde
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              disabledBackgroundColor: Colors.grey.shade300,
            ),
            child: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    "Cambiar contraseña",
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
        
        const SizedBox(height: 15),
        
        // Botón Cancelar
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isLoading ? null : (onCancelar ?? () {
              Navigator.pop(context);
            }),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEE6565), // rojo
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              disabledBackgroundColor: Colors.grey.shade300,
            ),
            child: Text(
              "Cancelar",
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 30),
      ],
    );
  }
}