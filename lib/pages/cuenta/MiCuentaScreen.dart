import 'package:flutter/material.dart';
import 'widgets/widgets.dart';
import '../homepage/widgets/HomeBottomNavigation.dart';

/// Pantalla principal de cuenta de usuario
class CuentaScreen extends StatelessWidget {
  const CuentaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        
        // AppBar modular
        appBar: const CuentaAppBar(),
        
        // Contenido principal
        body: ListView(
          children: const [
            // Header con imagen de perfil
            PerfilHeader(),
            
            // Opciones del menú
            CuentaOpciones(),
          ],
        ),
        
        // Bottom navigation bar reutilizable
        bottomNavigationBar: const HomeBottomNavigation(
          currentIndex: 3,
        ),
      ),
    );
  }
}
