import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onCartPressed;

  const HomeAppBar({
    super.key,
    this.onCartPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      backgroundColor: Colors.white,
      title: Row(
        children: [
          Image.asset(
            'lib/resources/address_icon.png',
            height: 40,
            width: 40,
          ),
          const SizedBox(width: 10),
          Text(
            "Dirección",
            style: GoogleFonts.inter(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
        ],
      ),
      actions: [
        IconButton(
          icon: Image.asset(
            'lib/resources/carrito_icon.png',
            height: 40,
            width: 40,
          ),
          onPressed: onCartPressed ?? () {
            Navigator.pushNamed(context, '/carrito');
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}