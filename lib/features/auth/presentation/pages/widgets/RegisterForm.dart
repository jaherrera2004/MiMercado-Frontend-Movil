import '../../../../../../core/widgets/common/SnackBarMessage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/registrar_usuario_controller.dart';
import 'package:mi_mercado/core/error/failure.dart';
import '../../../../../core/widgets/forms/CustomTextField.dart';
import '../../../../../core/widgets/buttons/PrimaryButton.dart';
import '../../../../../core/widgets/navigation/NavigationLink.dart';

/// Formulario de registro separado del widget principal
class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  late final RegistrarUsuarioController _regController;
  bool _obscurePassword = true;
  String? _phoneError;
  String? _emailError;
  String? _passwordError;
  @override
  void initState() {
    super.initState();
    // Use GetX controller for form fields and registration logic
    _regController = Get.find<RegistrarUsuarioController>();
  }

  void _handleRegister() async {
    setState(() {
      _phoneError = null;
      _emailError = null;
      _passwordError = null;
    });
    if (!_formKey.currentState!.validate()) {
      return;
    }
    try {
      await _regController.register();
      if (!mounted) return;
      SnackBarMessage.showSuccess(context, '¡Registro completado correctamente!');
      Navigator.of(context).pop();
    } catch (e) {
      String? alertMessage;
      if (e is InvalidPhoneFailure) {
        setState(() {
          _phoneError = 'Ingresa un teléfono válido (8-15 dígitos)';
        });
        alertMessage = _phoneError;
      } else if (e is InvalidEmailFailure) {
        setState(() {
          _emailError = 'Ingresa un email válido';
        });
        alertMessage = _emailError;
      } else if (e is InvalidPasswordFailure) {
        setState(() {
          _passwordError = 'La contraseña debe tener al menos 6 caracteres';
        });
        alertMessage = _passwordError;
      } else {
        alertMessage = e is Failure ? e.message : e.toString();
      }
      if (alertMessage != null && mounted) {
        final cleaned = alertMessage.replaceAll('Exception:', '').trim();
        SnackBarMessage.showError(context, 'Error al registrar usuario: $cleaned');
      }
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
              controller: _regController.nombreController,
              prefixIcon: const Icon(Icons.person),
              validator: (value) => (value == null || value.trim().isEmpty) ? 'El nombre es requerido' : null,
            ),
            const SizedBox(height: 15),
            CustomTextField(
              label: "Apellido",
              hint: "Ingresar Apellido",
              primaryColor: primaryColor,
              controller: _regController.apellidoController,
              prefixIcon: const Icon(Icons.person_outline),
              validator: (value) => (value == null || value.trim().isEmpty) ? 'El apellido es requerido' : null,
            ),
            const SizedBox(height: 15),
            CustomTextField(
              label: "Teléfono",
              hint: "Ingresar Teléfono",
              primaryColor: primaryColor,
              keyboardType: TextInputType.phone,
              controller: _regController.telefonoController,
              prefixIcon: const Icon(Icons.phone),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'El teléfono es requerido';
                }
                if (_phoneError != null) {
                  return _phoneError;
                }
                return null;
              },
            ),
            const SizedBox(height: 15),
            CustomTextField(
              label: "Email",
              hint: "Ingresar Email",
              primaryColor: primaryColor,
              keyboardType: TextInputType.emailAddress,
              controller: _regController.emailController,
              prefixIcon: const Icon(Icons.email),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'El email es requerido';
                }
                if (_emailError != null) {
                  return _emailError;
                }
                return null;
              },
            ),
            const SizedBox(height: 15),
            CustomTextField(
              label: "Contraseña",
              hint: "Ingresar Contraseña",
              primaryColor: primaryColor,
              obscureText: _obscurePassword,
              controller: _regController.passwordController,
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
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'La contraseña es requerida';
                }
                if (_passwordError != null) {
                  return _passwordError;
                }
                return null;
              },
            ),
            const SizedBox(height: 50),
            Obx(() {
              return PrimaryButton(
                text: _regController.isLoading.value ? 'Registrando...' : 'Registrarse',
                onPressed: () {
                  if (_regController.isLoading.value) return;
                  _handleRegister();
                },
                backgroundColor: primaryColor,
              );
            }),
            const SizedBox(height: 20),
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