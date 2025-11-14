import 'package:flutter/material.dart';
import 'package:mi_mercado/core/widgets/text/PageTitle.dart';

class PedidosAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onRefresh;
  
  const PedidosAppBar({super.key, this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: const PageTitle(title: "Pedidos"),
      centerTitle: true,
      actions: onRefresh != null ? [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: onRefresh,
          tooltip: 'Actualizar pedidos',
        ),
      ] : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}