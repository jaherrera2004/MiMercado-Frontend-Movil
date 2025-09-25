import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../shared/widgets/navigation/BackButton.dart';

/// AppBar personalizado para la pantalla de datos de perfil
class DatosAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onEditPressed;

  const DatosAppBar({
    super.key,
    this.onEditPressed,
  });

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
        "Datos",
        style: GoogleFonts.inter(
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Image.asset(
            'lib/resources/editData.png',
            width: 30,
            height: 30,
          ),
          onPressed: onEditPressed ?? () {
            Navigator.pushNamed(context, '/editar-perfil');
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}