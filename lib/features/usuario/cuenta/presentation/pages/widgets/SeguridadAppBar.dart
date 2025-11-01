import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mi_mercado/core/widgets/navigation/BackButton.dart';

/// AppBar personalizado para la pantalla de seguridad
class SeguridadAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SeguridadAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: const CustomBackButton(
          iconPath: 'lib/resources/go_back_icon.png',
        ),
      ),
      title: Text(
        "Seguridad",
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