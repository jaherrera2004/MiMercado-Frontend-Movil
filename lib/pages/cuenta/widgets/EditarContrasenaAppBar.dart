import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../shared/widgets/navigation/BackButton.dart';

/// AppBar personalizado para la pantalla de editar contraseña
class EditarContrasenaAppBar extends StatelessWidget implements PreferredSizeWidget {
  const EditarContrasenaAppBar({super.key});

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