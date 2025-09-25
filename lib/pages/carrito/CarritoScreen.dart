import 'package:flutter/material.dart';
import '../../shared/widgets/navigation/BackButton.dart';
import '../../shared/widgets/text/PageTitle.dart';
import 'widgets/widgets.dart';

class CarritoScreen extends StatelessWidget {
  final List<Map<String, dynamic>> productosCarrito = [
    {
      "nombre": "Bimbo Pan Blanco",
      "precio": "6.000 \$",
      "img": "lib/resources/temp/panbimbo.png",
      "cantidad": 1,
    },
    {
      "nombre": "Corona 6 pack",
      "precio": "18.000 \$",
      "img": "lib/resources/temp/coronitasixpack.png",
      "cantidad": 2,
    },
  ];

  @override
  Widget build(BuildContext context) {
    double subtotal = productosCarrito.fold(0, (sum, item) {
      final precio = double.tryParse(
        item["precio"].replaceAll(RegExp(r'[^0-9]'), '')
      ) ?? 0;
      return sum + precio * (item["cantidad"] ?? 1);
    });

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
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: productosCarrito.length,
                itemBuilder: (context, index) {
                  final producto = productosCarrito[index];
                  return CarritoItem(
                    producto: producto,
                    onDelete: () {
                      // Acción de eliminar
                    },
                    onIncrement: () {
                      // Acción de incrementar cantidad
                    },
                    onDecrement: () {
                      // Acción de decrementar cantidad
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
