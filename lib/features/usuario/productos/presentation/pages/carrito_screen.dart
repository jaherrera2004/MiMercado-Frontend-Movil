
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_mercado/core/widgets/navigation/BackButton.dart';
import 'package:mi_mercado/core/widgets/widgets.dart';
import 'widgets/widgets.dart';
import '../controllers/carrito_controller.dart';


class CarritoScreen extends StatelessWidget {
  const CarritoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CarritoController>();
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
        title: const PageTitle(
          title: "Carrito",
          fontSize: 22,
          color: Colors.black,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 16.0),
        child: Obx(() {
          final productosCarrito = controller.items.map((item) => {
            "id": item.idProducto,
            "nombre": item.nombre,
            "precio": "\$${item.precio.toStringAsFixed(0)}",
            "precioNumerico": item.precio,
            "img": item.imagenUrl ?? "lib/resources/temp/image.png",
            "cantidad": item.cantidad,
          }).toList();
          final subtotal = controller.subtotal.value;
          return productosCarrito.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        'Tu carrito está vacío',
                        style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Agrega productos para empezar',
                        style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: productosCarrito.length,
                        itemBuilder: (context, index) {
                          final producto = productosCarrito[index];
                          return CarritoItem(
                            producto: producto,
                            onDelete: () async {
                              await controller.eliminarProducto(producto['id'] as String);
                            },
                            onIncrement: () async {
                              await controller.incrementarCantidad(producto['id'] as String);
                            },
                            onDecrement: () async {
                              await controller.decrementarCantidad(producto['id'] as String);
                            },
                          );
                        },
                      ),
                    ),
                    CarritoSummary(subtotal: subtotal),
                    const SizedBox(height: 28),
                    CarritoBottomActions(
                      onContinuarPago: () {
                        Navigator.pushNamed(context, '/pago');
                      },
                    ),
                  ],
                );
        }),
      ),
    );
  }
}
