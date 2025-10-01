import 'package:flutter/material.dart';
import '../../../shared/widgets/forms/CustomTextField.dart';
import '../../../shared/widgets/buttons/PrimaryButton.dart';
import '../../../shared/widgets/navigation/NavigationLink.dart';
import '../../../models/Usuario.dart';

/// Formulario de registro separado del widget principal
class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidoController.dispose();
    _telefonoController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleRegister() async {
    try {
      // Crear objeto Usuario con los datos del formulario
      Usuario nuevoUsuario = Usuario(
        id: '', // Aquí podrías generar un ID único si es necesario
        nombre: _nombreController.text,
        apellido: _apellidoController.text,
        telefono: _telefonoController.text,
        email: _emailController.text,
        password: _passwordController.text,
        pedidos: [],
        direcciones: [],
      );
      
      // Llamar al método registrarUsuario del modelo
      await nuevoUsuario.registrarUsuario();
      
      // Mensaje de éxito
      print('Usuario registrado exitosamente');
      
    } catch (e) {
      print('Error: ${e.toString()}');
    }
  }

  void _navigateToLogin() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Campos de texto
            CustomTextField(
              label: "Nombre",
              hint: "Ingresar Nombre",
              primaryColor: primaryColor,
              controller: _nombreController,
            ),
            const SizedBox(height: 15),
            
            CustomTextField(
              label: "Apellido",
              hint: "Ingresar Apellido",
              primaryColor: primaryColor,
              controller: _apellidoController,
            ),
            const SizedBox(height: 15),
            
            CustomTextField(
              label: "Teléfono",
              hint: "Ingresar Teléfono",
              primaryColor: primaryColor,
              keyboardType: TextInputType.phone,
              controller: _telefonoController,
            ),
            const SizedBox(height: 15),
            
            CustomTextField(
              label: "Email",
              hint: "Ingresar Email",
              primaryColor: primaryColor,
              keyboardType: TextInputType.emailAddress,
              controller: _emailController,
            ),
            const SizedBox(height: 15),
            
            CustomTextField(
              label: "Contraseña",
              hint: "Ingresar Contraseña",
              primaryColor: primaryColor,
              obscureText: true,
              controller: _passwordController,
            ),

            const SizedBox(height: 50),

            // Botón Registrarse
            PrimaryButton(
              text: "Registrarse",
              onPressed: _handleRegister,
              backgroundColor: primaryColor,
            ),

            const SizedBox(height: 20),

            // Enlace para iniciar sesión
            NavigationLink(
              text: "¿Ya tienes cuenta? Inicia Sesión ",
              linkText: "aquí",
              linkColor: primaryColor,
              onTap: _navigateToLogin,
            ),
          ],
        ),
      ),
    );
  }
}