import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_mercado/core/widgets/navigation/BackButton.dart';
import 'package:mi_mercado/core/widgets/text/PageTitle.dart';
import 'package:mi_mercado/features/pedidos/presentation/controllers/pedido_detalle_controller.dart';
import 'widgets/widgets.dart';

class DatosPedidosScreen extends GetView<PedidoDetalleController> {
  const DatosPedidosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtener el ID del pedido de los argumentos
    final String? pedidoId = Get.arguments?['pedidoId'] as String?;
    
    // Cargar el pedido si tenemos el ID y es diferente al actual
    if (pedidoId != null && controller.pedido.value?.id != pedidoId) {
      controller.cargarPedidoPorId(pedidoId);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0),
              child: CustomBackButton(
                iconPath: 'lib/resources/go_back_icon.png',
                size: 40,
              ),
            ),
        title: PageTitle(title: "Pedido"),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final pedido = controller.pedido.value;
        if (pedido == null) {
          return const Center(child: Text('Pedido no encontrado'));
        }

        // Datos del pedido
        final String idPedido = pedido.id;
        final String direccion = pedido.direccion;
        final String estado = pedido.estado;
        final String fecha = '${pedido.fecha.day}/${pedido.fecha.month}/${pedido.fecha.year}';
        
        // Calcular costos
        final double total = pedido.costoTotal;
        final double domicilio = 5000.0; // Valor fijo por ahora
        final double servicio = 2000.0; // Valor fijo por ahora
        final double subtotal = total - domicilio - servicio;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Información del pedido
              PedidoInfo(
                numeroPedido: idPedido,
                direccion: direccion,
                fecha: fecha,
                estado: estado,
              ),
              
              const SizedBox(height: 24),
              
              // Resumen de costos
              PedidoResumen(
                subtotal: subtotal,
                domicilio: domicilio,
                servicio: servicio,
                total: total,
              ),
              
              const SizedBox(height: 24),
              
              // Lista de productos
              PedidoProductos(productos: controller.productosDetalle),
            ],
          ),
        );
      }),
    );
  }
}
