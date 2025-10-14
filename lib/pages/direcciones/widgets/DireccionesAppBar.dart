import 'package:flutter/material.dart';
import '../../shared/widgets/text/PageTitle.dart';

class DireccionesAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onAddPressed;

  const DireccionesAppBar({
    super.key,
    this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: const PageTitle(
        title: "Direcciones",
        fontSize: 18,
        color: Colors.black,
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Image.asset(
            'lib/resources/add_icon.png',
            width: 28,
            height: 28,
          ),
          onPressed: onAddPressed ?? () {
            // Acción por defecto para agregar dirección
          },
        ),
        const SizedBox(width: 12),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}