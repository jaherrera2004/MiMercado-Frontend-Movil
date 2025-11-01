import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// AppBar personalizado para la pantalla de cuenta
class CuentaAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CuentaAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Text(
        "Perfil",
        style: GoogleFonts.inter(
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}