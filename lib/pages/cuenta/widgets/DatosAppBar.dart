import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'EditarUsuarioModal.dart';

/// AppBar personalizado para la pantalla de datos de perfil
class DatosAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onEditPressed;
  final VoidCallback? onUsuarioEditado;

  const DatosAppBar({
    super.key,
    this.onEditPressed,
    this.onUsuarioEditado,
  });

  void _mostrarModalEditar(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => EditarUsuarioModal(
        onUsuarioEditado: onUsuarioEditado,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              Colors.grey[50]!,
            ],
          ),
        ),
      ),
      leading: Container(
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 0,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.grey,
            size: 20,
          ),
        ),
      ),
      title: Text(
        "Datos del Perfil",
        style: GoogleFonts.inter(
          fontWeight: FontWeight.w600,
          fontSize: 18,
          color: Colors.grey[800],
        ),
      ),
      centerTitle: true,
      actions: [
        Container(
          margin: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: const Color(0xFF58E181),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF58E181).withOpacity(0.3),
                spreadRadius: 0,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(
              Icons.edit_outlined,
              color: Colors.white,
              size: 20,
            ),
            onPressed: onEditPressed ?? () {
              _mostrarModalEditar(context);
            },
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}