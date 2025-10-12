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
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidoController.dispose();
    _telefonoController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Validador para campos requeridos
  String? _validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName es requerido';
    }
    return null;
  }

  // Validador para email
  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El email es requerido';
    }
    
    // Expresión regular para validar formato de email
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Ingresa un email válido';
    }
    
    return null;
  }

  // Validador para contraseña
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'La contraseña es requerida';
    }
    
    if (value.length < 6) {
      return 'La contraseña debe tener al menos 6 caracteres';
    }
    return null;
  }

  // Validador para teléfono
  String? _validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El teléfono es requerido';
    }
    
    // Validar que solo contenga números y tenga entre 8 y 15 dígitos
    final phoneRegex = RegExp(r'^[0-9]{8,15}$');
    
    if (!phoneRegex.hasMatch(value.trim())) {
      return 'Ingresa un teléfono válido (8-15 dígitos)';
    }
    
    return null;
  }

  void _handleRegister() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

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
      
      // Mostrar mensaje de éxito
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Usuario registrado exitosamente!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
      
      // Esperar un momento para que el usuario vea el mensaje
      await Future.delayed(const Duration(seconds: 2));
      
      // Navegar al login
      if (!mounted) return;
      Navigator.of(context).pop();
      
    } catch (e) {
      // Mostrar mensaje de error
      if (!mounted) return;
      // Limpiar el mensaje de excepción para no mostrar el prefijo "Exception:" u otras envolturas
      String raw = e.toString();
      // Eliminar prefijos comunes
      String cleaned = raw.replaceFirst(RegExp(r'^Exception:\s*'), '');
      cleaned = cleaned.replaceFirst(RegExp(r'^Exception\s*'), '');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al registrar usuario: $cleaned'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
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
              prefixIcon: const Icon(Icons.person),
              validator: (value) => _validateRequired(value, 'El nombre'),
            ),
            const SizedBox(height: 15),
            
            CustomTextField(
              label: "Apellido",
              hint: "Ingresar Apellido",
              primaryColor: primaryColor,
              controller: _apellidoController,
              prefixIcon: const Icon(Icons.person_outline),
              validator: (value) => _validateRequired(value, 'El apellido'),
            ),
            const SizedBox(height: 15),
            
            CustomTextField(
              label: "Teléfono",
              hint: "Ingresar Teléfono",
              primaryColor: primaryColor,
              keyboardType: TextInputType.phone,
              controller: _telefonoController,
              prefixIcon: const Icon(Icons.phone),
              validator: _validatePhone,
            ),
            const SizedBox(height: 15),
            
            CustomTextField(
              label: "Email",
              hint: "Ingresar Email",
              primaryColor: primaryColor,
              keyboardType: TextInputType.emailAddress,
              controller: _emailController,
              prefixIcon: const Icon(Icons.email),
              validator: _validateEmail,
            ),
            const SizedBox(height: 15),
            
            CustomTextField(
              label: "Contraseña",
              hint: "Ingresar Contraseña",
              primaryColor: primaryColor,
              obscureText: _obscurePassword,
              controller: _passwordController,
              prefixIcon: const Icon(Icons.lock),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
              validator: _validatePassword,
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