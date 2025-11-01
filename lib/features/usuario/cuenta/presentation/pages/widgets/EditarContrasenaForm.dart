import 'package:flutter/material.dart';
import 'package:mi_mercado/core/widgets/forms/CustomTextField.dart';

/// Widget que contiene el formulario para cambiar contraseña
class EditarContrasenaForm extends StatelessWidget {
  final Color primaryColor;
  final TextEditingController? contrasenaActualController;
  final TextEditingController? nuevaContrasenaController;
  final TextEditingController? confirmarContrasenaController;

  const EditarContrasenaForm({
    super.key,
    this.primaryColor = const Color(0xFF58E181),
    this.contrasenaActualController,
    this.nuevaContrasenaController,
    this.confirmarContrasenaController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 40),
        
        // Campo Contraseña Actual
        CustomTextField(
          label: "Contraseña Actual",
          hint: "Ingresar contraseña",
          primaryColor: primaryColor,
          obscureText: true,
          controller: contrasenaActualController,
        ),
        
        const SizedBox(height: 20),
        
        // Campo Nueva Contraseña
        CustomTextField(
          label: "Nueva Contraseña",
          hint: "Ingresar nueva contraseña",
          primaryColor: primaryColor,
          obscureText: true,
          controller: nuevaContrasenaController,
        ),
        
        const SizedBox(height: 20),
        
        // Campo Confirmar Nueva Contraseña
        CustomTextField(
          label: "Confirmar Nueva Contraseña",
          hint: "Confirmar nueva contraseña",
          primaryColor: primaryColor,
          obscureText: true,
          controller: confirmarContrasenaController,
        ),
        
        const SizedBox(height: 20),
        const SizedBox(height: 40),
      ],
    );
  }
}