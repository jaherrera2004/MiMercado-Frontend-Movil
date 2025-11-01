import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Widget que contiene el botón para cambiar contraseña
class SeguridadBoton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String texto;
  final Color backgroundColor;
  final Color textColor;
  final EdgeInsets? padding;

  const SeguridadBoton({
    super.key,
    this.onPressed,
    this.texto = "Cambiar contraseña",
    this.backgroundColor = const Color(0xFF58E181),
    this.textColor = Colors.white,
    this.padding = const EdgeInsets.symmetric(horizontal: 30.0),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding!,
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onPressed ?? () {
            Navigator.pushNamed(context, '/editar-seguridad');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            foregroundColor: textColor,
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(
            texto,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

/// Widget predefinido para el botón de cambiar contraseña
class CambiarContrasenaBoton extends StatelessWidget {
  final VoidCallback? onPressed;

  const CambiarContrasenaBoton({
    super.key,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SeguridadBoton(
      onPressed: onPressed,
      texto: "Cambiar contraseña",
    );
  }
}