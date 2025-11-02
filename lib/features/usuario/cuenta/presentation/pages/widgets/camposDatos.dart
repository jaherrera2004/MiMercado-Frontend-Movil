import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CamposDatos extends StatelessWidget {
  final String? dato;  // For backward compatibility
  final String? label;
  final String? value;

  const CamposDatos({
    super.key, 
    this.dato,
    this.label,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    // Use new label/value format if provided, otherwise fall back to old format
    final displayLabel = label ?? dato ?? '';
    final displayValue = value ?? '';
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      padding: const EdgeInsets.all(18.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _getIconColor(displayLabel).withOpacity(0.15),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icono según el tipo de dato
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  _getIconColor(displayLabel).withOpacity(0.15),
                  _getIconColor(displayLabel).withOpacity(0.08),
                ],
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              _getIcon(displayLabel),
              color: _getIconColor(displayLabel),
              size: 22,
            ),
          ),
          const SizedBox(width: 16),
          // Contenido
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayLabel,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[500],
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  displayValue.isNotEmpty ? displayValue : 'No especificado',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: displayValue.isNotEmpty ? Colors.black87 : Colors.grey[400],
                    letterSpacing: -0.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIcon(String label) {
    switch (label.toLowerCase()) {
      case 'nombre':
        return Icons.person_outline;
      case 'apellido':
        return Icons.badge_outlined;
      case 'teléfono':
      case 'telefono':
        return Icons.phone_outlined;
      case 'email':
        return Icons.email_outlined;
      default:
        return Icons.info_outline;
    }
  }

  Color _getIconColor(String label) {
    switch (label.toLowerCase()) {
      case 'nombre':
        return const Color(0xFF58E181);
      case 'apellido':
        return const Color(0xFF4CAF50);
      case 'teléfono':
      case 'telefono':
        return const Color(0xFF2196F3);
      case 'email':
        return const Color(0xFFFF9800);
      default:
        return Colors.grey;
    }
  }
}
