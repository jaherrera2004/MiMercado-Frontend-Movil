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
    // Determinar color según el tipo de opción
    final bool isLogout = nombre.toLowerCase().contains('cerrar');
    final Color primaryColor = isLogout 
        ? Colors.red.shade400 
        : const Color(0xFF58E181);
    final Color backgroundColor = isLogout
        ? Colors.red.shade50
        : Colors.white;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      child: Material(
        elevation: 2,
        shadowColor: primaryColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        color: backgroundColor,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: primaryColor.withOpacity(0.15),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                // Contenedor del icono con fondo circular
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Image.asset(
                    iconPath,
                    width: 24,
                    height: 24,
                    color: primaryColor,
                    errorBuilder: (context, error, stackTrace) {
                      // Fallback icon si la imagen no carga
                      return Icon(
                        Icons.settings,
                        size: 24,
                        color: primaryColor,
                      );
                    },
                  ),
                ),
                
                const SizedBox(width: 16),
                
                // Texto de la opción
                Expanded(
                  child: Text(
                    nombre,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: isLogout ? Colors.red.shade700 : Colors.black87,
                      letterSpacing: -0.3,
                    ),
                  ),
                ),
                
                // Flecha indicadora
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: primaryColor.withOpacity(0.6),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


