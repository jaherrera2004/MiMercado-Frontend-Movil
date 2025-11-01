import 'package:flutter/material.dart';
import 'package:mi_mercado/core/widgets/forms/CustomTextField.dart';

/// Widget que contiene el formulario de edición de perfil
class EditarPerfilForm extends StatelessWidget {
  final Color primaryColor;
  final TextEditingController? nombreController;
  final TextEditingController? apellidoController;
  final TextEditingController? telefonoController;
  final TextEditingController? emailController;

  const EditarPerfilForm({
    super.key,
    this.primaryColor = const Color(0xFF58E181),
    this.nombreController,
    this.apellidoController,
    this.telefonoController,
    this.emailController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 40),
        
        // Campo Nombre
        CustomTextField(
          label: "Nombre",
          hint: "Ingresa tu nombre",
          primaryColor: primaryColor,
          controller: nombreController,
        ),
        
        const SizedBox(height: 20),
        
        // Campo Apellido
        CustomTextField(
          label: "Apellido",
          hint: "Ingresa tu apellido",
          primaryColor: primaryColor,
          controller: apellidoController,
        ),
        
        const SizedBox(height: 20),
        
        // Campo Teléfono
        CustomTextField(
          label: "Teléfono",
          hint: "Ingresa tu número",
          primaryColor: primaryColor,
          keyboardType: TextInputType.phone,
          controller: telefonoController,
        ),
        
        const SizedBox(height: 20),
        
        // Campo Email
        CustomTextField(
          label: "Email",
          hint: "Ingresa tu correo",
          primaryColor: primaryColor,
          keyboardType: TextInputType.emailAddress,
          controller: emailController,
        ),
        
        const SizedBox(height: 40),
      ],
    );
  }
}