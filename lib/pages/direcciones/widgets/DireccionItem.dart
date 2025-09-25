import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DireccionItem extends StatelessWidget {
  final String nombre;
  final String ubicacion;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;

  const DireccionItem({
    super.key,
    required this.nombre,
    required this.ubicacion,
    this.onEdit,
    this.onDelete,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.asset('lib/resources/pin.png', width: 30, height: 30),
      title: Text(
        nombre,
        style: GoogleFonts.inter(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        ubicacion,
        style: GoogleFonts.inter(),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Image.asset(
              'lib/resources/edit.png',
              width: 30,
              height: 30,
            ),
            onPressed: onEdit,
          ),
          IconButton(
            icon: Image.asset(
              'lib/resources/trashcan.png',
              width: 30,
              height: 30,
            ),
            onPressed: onDelete,
          ),
        ],
      ),
      onTap: onTap,
    );
  }
}
