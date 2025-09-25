import 'package:flutter/material.dart';
import 'widgets/widgets.dart';

/// Pantalla de configuración de seguridad y contraseña
class PasswordScreen extends StatelessWidget {
  const PasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      
      // AppBar modular
      appBar: const SeguridadAppBar(),
      
      // Contenido principal
      body: const Column(
        children: [
          // Información de seguridad actual
          SeguridadInfo(),
          
          // Botón para cambiar contraseña
          CambiarContrasenaBoton(),
        ],
      ),
    );
  }
}
