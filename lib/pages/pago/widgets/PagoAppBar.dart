import 'package:flutter/material.dart';
import '../../shared/widgets/widgets.dart';

class PagoAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PagoAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0),
            child: CustomBackButton(
              iconPath: 'lib/resources/go_back_icon.png',
              size: 40,
            ),
          ),
      title: const PageTitle(title: "Pago"),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}