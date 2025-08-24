import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class PagoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Image.asset(
            'lib/resources/go_back_icon.png',
            width: 35,
            height: 35,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          "Pago",
          style: GoogleFonts.inter(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 26),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dirección de envío
            Text("Dirección de envío",
                style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text("Dirección",
                    style: GoogleFonts.inter(color: Colors.white, fontSize: 16)),
              ),
            ),
            Divider(height: 40),

            // Detalles del pedido
            Text("Detalles del pedido",
                style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  filaDetalle("Productos", "24.000 \$"),
                  SizedBox(height: 6),
                  filaDetalle("Domicilio", "2.000 \$"),
                  SizedBox(height: 6),
                  filaDetalle("Servicio", "2.000 \$"),
                ],
              ),
            ),
            Divider(height: 40),

            // Total
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Total",
                      style: GoogleFonts.inter(color: Colors.white, fontSize: 16)),
                  Text("28.000 \$",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Botón realizar pedido
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                  side: BorderSide(color: primaryColor, width: 2),
                  backgroundColor: Colors.white,
                ),
                onPressed: () {},
                child: Text(
                  "Realizar pedido",
                  style: GoogleFonts.inter(color: primaryColor, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget filaDetalle(String titulo, String valor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(titulo, style: TextStyle(fontSize: 15)),
        Text(valor,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
