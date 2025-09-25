import 'package:flutter/material.dart';
import '../homepage/widgets/HomeBottomNavigation.dart';
import 'widgets/widgets.dart';

class PedidosScreen extends StatelessWidget {
  const PedidosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Datos de ejemplo - en una app real, estos vendrían del estado o servicio
    final List<Map<String, dynamic>> pedidosEjemplo = [
      {
        'numero': 1,
        'direccion': 'Carrera 15 #123-45, Chapinero',
        'fecha': '2024-03-15',
        'estado': 'Entregado',
        'total': 45000,
      },
      {
        'numero': 2,
        'direccion': 'Calle 100 #67-89, Zona Rosa',
        'fecha': '2024-03-20',
        'estado': 'En camino',
        'total': 32500,
      },
      {
        'numero': 3,
        'direccion': 'Carrera 7 #45-23, Centro',
        'fecha': '2024-03-25',
        'estado': 'Pendiente',
        'total': 67800,
      },
    ];

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: const PedidosAppBar(),
        body: PedidosList(
          pedidos: pedidosEjemplo,
          onTapPedido: (pedido) {
            Navigator.pushNamed(
              context, 
              '/detalle-pedido',
              arguments: pedido,
            );
          },
        ),
        bottomNavigationBar: const HomeBottomNavigation(currentIndex: 2),
      ),
    );
  }
}
