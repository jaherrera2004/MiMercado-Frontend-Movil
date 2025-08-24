import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class pedido extends StatelessWidget {
  final String direccion;
  final String fecha;
  final VoidCallback? onTap; // 👈 acción al presionar

  const pedido({
    super.key,
    required this.direccion,
    required this.fecha,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.asset('lib/resources/order.png', width: 30, height: 30),
      title: Text(
        direccion,
        style: GoogleFonts.inter(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(fecha, style: GoogleFonts.inter()),
      trailing: Image.asset(
        'lib/resources/arrow_right.png',
        width: 20,
        height: 20,
      ),
      onTap: onTap, // 👈 ejecuta lo que reciba
    );
  }
}
