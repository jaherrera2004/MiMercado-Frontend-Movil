import 'package:flutter/material.dart';
import 'widgets/opcion.dart';

class CuentaScreen extends StatelessWidget {
  const CuentaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'lib/resources/go_back_icon.png',
              width: 30,
              height: 30,
            ),
          ),
        ),
        title: const Text(
          "Perfil",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 50),

          // Imagen circular y nombre
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('lib/resources/usuarioIMG.png'),
                  backgroundColor: Colors.grey.shade200,
                ),
                const SizedBox(height: 10),
                const Text(
                  "Nombre",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // Opciones
          const Opcion(
            nombre: "Información personal",
            iconPath: "lib/resources/cedula.png",
          ),
          const Opcion(
            nombre: "Seguridad",
            iconPath: "lib/resources/seguridad.png",
          ),
          const Opcion(
            nombre: "Cerrar sesión",
            iconPath: "lib/resources/logout.png",
          ),
        ],
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
