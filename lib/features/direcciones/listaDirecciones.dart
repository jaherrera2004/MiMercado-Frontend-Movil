import 'package:flutter/material.dart';
import 'widgets/direccion.dart';

class DireccionesScreen extends StatelessWidget {
  const DireccionesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Image.asset(
          'lib/resources/go_back_icon.png',
          width: 40,
          height: 40,
        ),
        title: const Text(
          "Direcciones",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
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
