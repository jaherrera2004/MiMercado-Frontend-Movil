import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CarritoSummary extends StatelessWidget {
  final double subtotal;

  const CarritoSummary({
    Key? key,
    required this.subtotal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Subtotal:",
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          "${subtotal.toStringAsFixed(0)} \$",
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}