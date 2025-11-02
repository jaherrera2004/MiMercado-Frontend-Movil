import 'package:flutter/material.dart';
import 'package:mi_mercado/core/widgets/text/PageTitle.dart';

class PedidosAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PedidosAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: const PageTitle(title: "Pedidos"),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}