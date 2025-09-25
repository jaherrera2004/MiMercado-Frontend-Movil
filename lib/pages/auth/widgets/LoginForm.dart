import 'package:flutter/material.dart';
import '../../../shared/widgets/forms/CustomTextField.dart';
import '../../../shared/widgets/buttons/PrimaryButton.dart';
import '../../../shared/widgets/navigation/NavigationLink.dart';
import '../../../shared/widgets/text/PageTitle.dart';
import 'UserTypeSelector.dart';

/// Formulario de inicio de sesión separado del widget principal
class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  bool _isLoading = false;
  UserType _selectedUserType = UserType.usuario;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // TODO: Implementar lógica de inicio de sesión con Firebase
      // Incluir el tipo de usuario seleccionado en la autenticación
      print('Iniciando sesión como: ${_selectedUserType == UserType.usuario ? 'Usuario' : 'Repartidor'}');
      print('Email: ${_emailController.text}');
      
      await Future.delayed(const Duration(seconds: 2)); // Simulación

      setState(() {
        _isLoading = false;
      });

      // Navegar a home o dashboard del repartidor según el tipo seleccionado
      if (mounted) {
        if (_selectedUserType == UserType.usuario) {
          Navigator.pushNamed(context, '/home');
        } else {
          // TODO: Crear ruta para dashboard del repartidor
          Navigator.pushNamed(context, '/home'); // Por ahora va a home, después se puede cambiar
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mensaje de bienvenida
            const PageTitle(
              title: "Bienvenido a MiMercado!",
              fontSize: 32,
              color: Colors.grey,
              textAlign: TextAlign.start,
            ),
            
            const SizedBox(height: 30),
            
            // Selector de tipo de usuario
            UserTypeSelector(
              selectedType: _selectedUserType,
              onChanged: (UserType type) {
                setState(() {
                  _selectedUserType = type;
                });
              },
              primaryColor: primaryColor,
            ),
            
            const SizedBox(height: 30),
            
            // Campo de email
            CustomTextField(
              label: "Email",
              hint: "Ingresar Email",
              primaryColor: primaryColor,
              keyboardType: TextInputType.emailAddress,
              controller: _emailController,
            ),
            
            const SizedBox(height: 20),
            
            // Campo de contraseña
            CustomTextField(
              label: "Contraseña",
              hint: "Ingresar Contraseña",
              primaryColor: primaryColor,
              obscureText: true,
              controller: _passwordController,
            ),
            
            const SizedBox(height: 30),
            
            // Botón de iniciar sesión
            PrimaryButton(
              text: "Iniciar sesión",
              onPressed: _handleLogin,
              backgroundColor: primaryColor,
              isLoading: _isLoading,
            ),
            
            const SizedBox(height: 20),
            
            // Enlace para registro
            NavigationLink(
              text: "¿No tienes cuenta? Regístrate ",
              linkText: "aquí",
              linkColor: primaryColor,
              onTap: () {
                Navigator.pushReplacementNamed(context, '/registro');
              },
            ),
          ],
        ),
      ),
    );
  }
}