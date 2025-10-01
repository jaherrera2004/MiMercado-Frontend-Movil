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
    
    return ListTile(
      title: Text(
        displayLabel, 
        style: GoogleFonts.inter(fontWeight: FontWeight.bold),
      ),
      subtitle: value != null ? Text(
        displayValue,
        style: GoogleFonts.inter(
          fontSize: 14,
          color: Colors.grey[600],
        ),
      ) : null,
      onTap: () {},
    );
  }
}
