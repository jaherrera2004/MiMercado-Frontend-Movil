import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
        leading: SizedBox(
          width: 48,
          height: 40,
          child: Padding(
            padding: EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0, right: 0.0),
            child: IconButton(
              icon: Image.asset(
                'lib/resources/go_back_icon.png',
                width: 40,
                height: 40,
              ),
              iconSize: 40,
              padding: EdgeInsets.zero,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ),
        title: Text(
          "Carrito",
          style: GoogleFonts.inter(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
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
                  return Container(
                    margin: EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.green[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 25,
                        child: ClipOval(
                          child: Image.asset(
                            producto["img"],
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      title: Text(
                        producto["nombre"],
                        style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        producto["precio"],
                        style: GoogleFonts.inter(fontSize: 14),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: SizedBox(
                        width: 120,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.delete_outline, color: Colors.red),
                              onPressed: () {
                                // Acción de eliminar
                              },
                              tooltip: 'Eliminar',
                            ),
                            Icon(Icons.remove_circle_outline, color: Colors.black),
                            SizedBox(width: 4),
                            Text("${producto["cantidad"]}", style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(width: 4),
                            Icon(Icons.add_circle_outline, color: Colors.black),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            // Subtotal
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Subtotal:",
                  style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Text(
                  "${subtotal.toStringAsFixed(0)} \$",
                  style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 28),
            // Botón continuar pago
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/pago');
                },
                child: Text(
                  "Continuar pago",
                  style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),

                ),
              ),
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
