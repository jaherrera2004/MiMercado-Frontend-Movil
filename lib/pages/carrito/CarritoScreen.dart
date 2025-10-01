import 'package:flutter/material.dart';
import '../../shared/widgets/navigation/BackButton.dart';
import '../../shared/widgets/text/PageTitle.dart';
import '../../models/CarritoService.dart' as carrito_service;
import 'widgets/widgets.dart';

class CarritoScreen extends StatefulWidget {
  const CarritoScreen({super.key});

  @override
  State<CarritoScreen> createState() => _CarritoScreenState();
}

class _CarritoScreenState extends State<CarritoScreen> {
  final carrito_service.CarritoService _carritoService = carrito_service.CarritoService();

  @override
  Widget build(BuildContext context) {
    // Obtener items del carrito
    final itemsCarrito = _carritoService.obtenerItems();
    
    // Convertir a formato que espera CarritoItem widget
    final productosCarrito = itemsCarrito.map((item) => {
      "id": item.idProducto,
      "nombre": item.nombre,
      "precio": "\$${item.precio.toStringAsFixed(0)}",
      "precioNumerico": item.precio,
      "img": item.imagenUrl ?? "lib/resources/temp/image.png",
      "cantidad": item.cantidad,
    }).toList();
    
    final double subtotal = _carritoService.subtotal;

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
        child: productosCarrito.isEmpty
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
                          // Eliminar producto del carrito
                          await _carritoService.eliminarProducto(producto['id'] as String);
                          setState(() {}); // Refrescar la UI
                        },
                        onIncrement: () async {
                          // Incrementar cantidad
                          await _carritoService.incrementarCantidad(producto['id'] as String);
                          setState(() {}); // Refrescar la UI
                        },
                        onDecrement: () async {
                          // Decrementar cantidad
                          await _carritoService.decrementarCantidad(producto['id'] as String);
                          setState(() {}); // Refrescar la UI
                        },
                      );
                    },
                  ),
                ),
                // Subtotal
                CarritoSummary(subtotal: subtotal),
                const SizedBox(height: 28),
                // Botón continuar pago
                CarritoBottomActions(
                  onContinuarPago: () {
                    Navigator.pushNamed(context, '/pago');
                  },
                ),
              ],
            ),
      ),
    );
  }
}
