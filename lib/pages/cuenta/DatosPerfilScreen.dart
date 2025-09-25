import 'package:flutter/material.dart';
import 'widgets/widgets.dart';

/// Pantalla de datos de perfil del usuario
class DatosScreen extends StatelessWidget {
  const DatosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      
      // AppBar modular con botón de editar
      appBar: const DatosAppBar(),
      
      // Lista de datos del perfil
      body: const DatosPerfilLista(),
    );
  }
}
