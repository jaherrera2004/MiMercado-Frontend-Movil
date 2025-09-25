import 'package:flutter/material.dart';
import '../../../shared/widgets/widgets.dart';
import 'PedidoItem.dart';

class PedidosList extends StatelessWidget {
  final List<Map<String, dynamic>> pedidos;
  final Function(Map<String, dynamic>)? onTapPedido;

  const PedidosList({
    super.key,
    required this.pedidos,
    this.onTapPedido,
  });

  @override
  Widget build(BuildContext context) {
    if (pedidos.isEmpty) {
      return const EmptyState(
        title: "No tienes pedidos aún",
        subtitle: "Realiza tu primera compra y aparecerá aquí",
        icon: Icons.shopping_bag_outlined,
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: ListView.builder(
        itemCount: pedidos.length,
        itemBuilder: (context, index) {
          final pedido = pedidos[index];
          return PedidoItem(
            numeroPedido: pedido['numero']?.toString(),
            direccion: pedido['direccion'] ?? 'Dirección no disponible',
            fecha: pedido['fecha'] ?? 'Fecha no disponible',
            estado: pedido['estado'],
            total: pedido['total']?.toDouble(),
            onTap: () => onTapPedido?.call(pedido),
          );
        },
      ),
    );
  }
}