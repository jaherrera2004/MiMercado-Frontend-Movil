import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../shared/widgets/forms/CustomTextField.dart';
import '../../../shared/widgets/buttons/PrimaryButton.dart';
import '../../../shared/widgets/navigation/NavigationLink.dart';
import '../../../shared/widgets/text/PageTitle.dart';
import 'UserTypeSelector.dart';
import '../../../models/Persona.dart';
import '../../../models/Usuario.dart';
import '../../../models/Repartidor.dart';
import '../../../models/SharedPreferences.dart';

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
  final firebase = FirebaseFirestore.instance;
  
  bool _isLoading = false;
  UserType _selectedUserType = UserType.usuario;

  // Validación de email
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'El email es requerido';
    }
    
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Ingresa un email válido';
    }
    
    return null;
  }

  // Validación de contraseña
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'La contraseña es requerida';
    }
    
    if (value.length < 6) {
      return 'La contraseña debe tener al menos 6 caracteres';
    }
    
    return null;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    // Validar formulario
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Determinar el tipo de usuario
      final String tipoUsuario = _selectedUserType == UserType.usuario ? 'usuario' : 'repartidor';
      
      // Llamar al método de login de Persona
      final Persona? persona = await Persona.login(
        _emailController.text.trim().toLowerCase(),
        _passwordController.text,
        tipoUsuario,
      );

      if (persona == null) {
        // Login fallido
        _showErrorMessage('Email o contraseña incorrectos');
        return;
      }
      print(persona.nombre);
      // Login exitoso
      _showSuccessMessage('Inicio de sesión exitoso');

 

      // Validar datos antes de guardar con null safety
      final String userId = persona.id;
      final String userName = persona.nombre ?? 'Usuario';
      final String userRole = persona is Usuario ? 'usuario' : 'repartidor';
      
      
      // Validar que no sean nulos o vacíos
      if (userId.isEmpty) {
        throw Exception('ID del usuario está vacío');
      }
      if (userName.isEmpty) {
        throw Exception('Nombre del usuario está vacío o es nulo');
      }

      // Guardar datos en SharedPreferences usando el servicio apropiado
      if (persona is Repartidor) {
        await SharedPreferencesService.saveRepartidorSessionData(
          id: userId,
          nombre: userName,
          rol: userRole,
          pedidoActual: persona.pedidoActual,
          estadoActual: persona.estadoActual,
        );
      } else {
        await SharedPreferencesService.saveSessionData(
          id: userId,
          nombre: userName,
          rol: userRole,
        );
      }
      
      // Limpiar formulario
      _emailController.clear();
      _passwordController.clear();

      // Navegar según el tipo de usuario
      if (mounted) {
        if (persona is Usuario) {
          Navigator.pushReplacementNamed(context, '/home');
        } else if (persona is Repartidor) {
          Navigator.pushReplacementNamed(context, '/repartidor');
        }
      }

    } catch (e) {
      _showErrorMessage('Error al iniciar sesión: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
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
              validator: _validateEmail,
            ),
            
            const SizedBox(height: 20),
            
            // Campo de contraseña
            CustomTextField(
              label: "Contraseña",
              hint: "Ingresar Contraseña",
              primaryColor: primaryColor,
              obscureText: true,
              controller: _passwordController,
              validator: _validatePassword,
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