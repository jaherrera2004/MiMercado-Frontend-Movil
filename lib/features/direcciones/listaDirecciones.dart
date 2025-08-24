import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'widgets/direccion.dart';

class DireccionesScreen extends StatelessWidget {
  const DireccionesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          "Direcciones",
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Image.asset(
              'lib/resources/add_icon.png',
              width: 28,
              height: 28,
            ),
            onPressed: () {
              // 👉 acción al presionar el botón
            },
          ),
          const SizedBox(width: 12), // pequeño margen a la derecha
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: ListView(
          children: const [
            SizedBox(height: 30), // 👈 espacio debajo del AppBar
            direccion(nombre: "Nombre", ubicacion: "Direccion"),
            Divider(),
            direccion(nombre: "Nombre", ubicacion: "Direccion"),
            Divider(),
            direccion(nombre: "Nombre", ubicacion: "Direccion"),
            Divider(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        currentIndex: 1,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/home');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/direcciones');
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/pedidos');
              break;
            case 3:
              Navigator.pushReplacementNamed(context, '/cuenta');
              break;
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Image.asset('lib/resources/home.png', width: 25, height: 25),
            label: "Inicio",
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'lib/resources/location.png',
              width: 25,
              height: 25,
            ),
            label: "Direcciones",
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'lib/resources/orders.png',
              width: 25,
              height: 25,
            ),
            label: "Pedidos",
          ),
          BottomNavigationBarItem(
            icon: Image.asset('lib/resources/user.png', width: 25, height: 25),
            label: "Cuenta",
          ),
        ],
      ),
    );
  }
}
