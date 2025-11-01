import 'package:flutter/material.dart';
import 'camposDatos.dart';

/// Widget que muestra la información de seguridad actual
class SeguridadInfo extends StatelessWidget {
  final String? passwordDisplay;
  final EdgeInsets? padding;

  const SeguridadInfo({
    super.key,
    this.passwordDisplay = "Contraseña",
    this.padding = const EdgeInsets.symmetric(horizontal: 30.0),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding!,
      child: Column(
        children: [
          const SizedBox(height: 50), // Espacio debajo del AppBar
          
          // Campo de contraseña (mostrado como asteriscos o puntos)
          CamposDatos(dato: passwordDisplay!),
          
          const Divider(),
          
          const SizedBox(height: 30), // Separación antes del botón
        ],
      ),
    );
  }
}