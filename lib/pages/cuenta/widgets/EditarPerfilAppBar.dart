import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../shared/widgets/navigation/BackButton.dart';

/// AppBar personalizado para la pantalla de editar perfil
class EditarPerfilAppBar extends StatelessWidget implements PreferredSizeWidget {
  const EditarPerfilAppBar({super.key});

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
        "Editar Perfil",
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