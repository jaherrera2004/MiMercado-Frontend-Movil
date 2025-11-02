import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_mercado/features/pedidos/presentation/controllers/pedidos_controller.dart';
import 'package:mi_mercado/features/usuario/productos/presentation/pages/widgets/HomeBottomNavigation.dart';
import 'widgets/widgets.dart';

class PedidosScreen extends GetView<PedidosController> {
  const PedidosScreen({super.key});

  Future<void> _cargarPedidos() async {
    await controller.cargarPedidosUsuario();
  }

  @override
  Widget build(BuildContext context) {
    // Cargar pedidos cuando se abra la pantalla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.pedidos.isEmpty && !controller.isLoading.value) {
        controller.cargarPedidosUsuario();
      }
    });

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
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          } else if (controller.pedidos.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.receipt_long_outlined, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    'No tienes pedidos aún',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Tus pedidos aparecerán aquí',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _cargarPedidos,
                    child: const Text('Actualizar'),
                  ),
                ],
              ),
            );
          } else {
            return RefreshIndicator(
              onRefresh: _cargarPedidos,
              child: PedidosList(
                pedidos: controller.pedidos.map((pedido) => {
                  'numero': pedido.id,
                  'direccion': pedido.direccion,
                  'fecha': pedido.fecha.toString().split(' ')[0], // Solo la fecha sin hora
                  'estado': pedido.estado,
                  'total': pedido.costoTotal,
                  'idRepartidor': pedido.idRepartidor,
                  'idUsuario': pedido.idUsuario,
                  'listaProductos': pedido.listaProductos.map((producto) => {
                    'idProducto': producto.idProducto,
                    'cantidad': producto.cantidad,
                  }).toList(),
                }).toList(),
                onTapPedido: (pedido) {
                  Get.toNamed(
                    '/detalle-pedido',
                    arguments: {'pedidoId': pedido['numero']},
                  );
                },
              ),
            );
          }
        }),
        bottomNavigationBar: const HomeBottomNavigation(currentIndex: 2),
      ),
    );
  }
}
