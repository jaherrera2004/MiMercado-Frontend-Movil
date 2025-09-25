import 'package:flutter/material.dart';
import '../../../shared/widgets/widgets.dart';

class PagoAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PagoAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: CustomBackButton(
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: const PageTitle(title: "Pago"),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}