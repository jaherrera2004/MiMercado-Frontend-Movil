import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'widgets/pedido.dart';

class PedidosScreen extends StatelessWidget {
  const PedidosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          "Pedidos",
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: ListView(
          children: [
            const SizedBox(height: 30),

            pedido(
              direccion: "Dirección 1",
              fecha: "Fecha 1",
              onTap: () {
                Navigator.pushNamed(context, '/detalle-pedido');
              },
            ),
            const Divider(),

            pedido(
              direccion: "Dirección 2",
              fecha: "Fecha 2",
              onTap: () {
                Navigator.pushNamed(context, '/detalle-pedido');
              },
            ),
            const Divider(),

            pedido(
              direccion: "Dirección 3",
              fecha: "Fecha 3",
              onTap: () {
                Navigator.pushNamed(context, '/detalle-pedido');
              },
            ),
            const Divider(),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        currentIndex: 2,
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
