import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'widgets/opcion.dart';


class CuentaScreen extends StatelessWidget {
  const CuentaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, '/home');
        return false;
      },
      child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          "Perfil",
          style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.black),
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
                Text(
                  "Nombre",
                  style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // Opciones
          Opcion(
            nombre: "Información personal",
            iconPath: "lib/resources/cedula.png",
            onTap: () {
              Navigator.pushNamed(context, '/datos-perfil');
            },
          ),
          Opcion(
            nombre: "Seguridad",
            iconPath: "lib/resources/seguridad.png",
            onTap: () {
              Navigator.pushNamed(context, '/seguridad');
            },
          ),
          Opcion(
            nombre: "Cerrar sesión",
            iconPath: "lib/resources/logout.png",
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        currentIndex: 3,
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
      ),
    );
  }
}
