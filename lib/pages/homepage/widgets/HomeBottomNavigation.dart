import 'package:flutter/material.dart';

class HomeBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int)? onTap;

  const HomeBottomNavigation({
    super.key,
    this.currentIndex = 0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.black,
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      onTap: onTap ?? (index) {
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
    );
  }
}