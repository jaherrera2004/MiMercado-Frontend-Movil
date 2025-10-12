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
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icono según el tipo de dato
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: _getIconColor(displayLabel).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getIcon(displayLabel),
              color: _getIconColor(displayLabel),
              size: 20,
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
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  displayValue.isNotEmpty ? displayValue : 'No especificado',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: displayValue.isNotEmpty ? Colors.grey[800] : Colors.grey[400],
                  ),
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
