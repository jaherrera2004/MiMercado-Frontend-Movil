import 'package:get/get.dart';
import '../../controllers/login_controller.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/widgets/common/SnackBarMessage.dart';
import '../../../../../core/widgets/forms/CustomTextField.dart';
import '../../../../../core/widgets/buttons/PrimaryButton.dart';
import '../../../../../core/widgets/navigation/NavigationLink.dart';
import '../../../../../core/widgets/text/PageTitle.dart';
import '../../../../../core/error/failure.dart';
import 'UserTypeSelector.dart';

/// Formulario de inicio de sesión separado del widget principal
class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  late final LoginController _loginController;
  bool _obscurePassword = true;
  UserType _selectedUserType = UserType.usuario;

  // Validación de email
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'El email es requerido';
    }
    
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value.trim())) {
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
  void initState() {
    super.initState();
    _loginController = Get.put(LoginController());
  }

  @override
  void dispose() {
    // No disponer los controllers aquí porque pertenecen al controller global
    // y pueden ser reutilizados
    super.dispose();
  }

  void _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() {}); // Para refrescar el botón si usas Obx
    _loginController.isLoading.value = true;
    try {
      final rol = _selectedUserType == UserType.usuario ? 'usuario' : 'repartidor';
      await _loginController.login(rol: rol);
      if (!mounted) return;
      SnackBarMessage.showSuccess(context, '¡Inicio de sesión exitoso!');
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      if (mounted) {
        String errorMessage;
        if (e is Failure) {
          errorMessage = e.message;
        } else {
          errorMessage = e.toString().replaceAll('Exception:', '').trim();
        }
        SnackBarMessage.showError(context, errorMessage);
      }
    } finally {
      if (mounted) {
        _loginController.isLoading.value = false;
        setState(() {});
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
              prefixIcon: const Icon(Icons.email),
              controller: _loginController.emailController,
              validator: _validateEmail,
            ),
            
            const SizedBox(height: 20),
            
            // Campo de contraseña
            CustomTextField(
              label: "Contraseña",
              hint: "Ingresar Contraseña",
              primaryColor: primaryColor,
              obscureText: _obscurePassword,
              controller: _loginController.passwordController,
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
            
            const SizedBox(height: 30),
            
            // Botón de iniciar sesión
            PrimaryButton(
              text: "Iniciar sesión",
              onPressed: _handleLogin,
              backgroundColor: primaryColor,
              isLoading: _loginController.isLoading.value,
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