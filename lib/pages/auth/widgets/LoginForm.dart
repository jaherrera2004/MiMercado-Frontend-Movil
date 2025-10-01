import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
      // Determinar la colección según el tipo de usuario seleccionado
      final String collection = _selectedUserType == UserType.usuario ? 'usuarios' : 'repartidores';
      
      // Buscar en la colección correspondiente por email
      final QuerySnapshot userQuery = await firebase
          .collection(collection)
          .where('email', isEqualTo: _emailController.text.trim().toLowerCase())
          .limit(1)
          .get();

      if (userQuery.docs.isEmpty) {
        // Usuario no encontrado en la colección correspondiente
        final String userTypeName = _selectedUserType == UserType.usuario ? 'usuario' : 'repartidor';
        _showErrorMessage('$userTypeName no encontrado');
        return;
      }

  final doc = userQuery.docs.first;
  final userData = doc.data() as Map<String, dynamic>;
      final storedPassword = userData['password'] as String;

      // Verificar contraseña (en producción deberías usar hash)
      if (storedPassword != _passwordController.text) {
        _showErrorMessage('Contraseña incorrecta');
        return;
      }

      // Login exitoso
      _showSuccessMessage('Inicio de sesión exitoso');

      // Guardar datos en SharedPreferences (id, nombre, email, direccion principal)
      await _saveSessionData(
        userId: doc.id,
        email: (userData['email'] ?? '').toString(),
        nombre: (userData['nombre'] ?? '').toString(),
        direcciones: userData['direcciones'],
      );
      
      // Limpiar formulario
      _emailController.clear();
      _passwordController.clear();

      // Navegar según el tipo de usuario
      if (mounted) {
        if (_selectedUserType == UserType.usuario) {
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          Navigator.pushReplacementNamed(context, '/repartidor');
        }
      }

    } catch (e) {
      print('Error en login: $e');
      _showErrorMessage('Error al iniciar sesión: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _saveSessionData({
    required String userId,
    required String email,
    required String nombre,
    dynamic direcciones,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Determinar direccion principal
      String mainAddress = '';
      if (direcciones is List) {
        // Cada elemento se espera sea un Map con 'principal': bool y 'direccion'
        for (final d in direcciones) {
          if (d is Map<String, dynamic>) {
            final isPrincipal = d['principal'] == true;
            if (isPrincipal) {
              mainAddress = (d['direccion'] ?? '').toString();
              break;
            }
          }
        }
        // Si no se encontró principal, tomar la primera direccion (si existe)
        if (mainAddress.isEmpty && direcciones.isNotEmpty) {
          final first = direcciones.first;
          if (first is Map<String, dynamic>) {
            mainAddress = (first['direccion'] ?? '').toString();
          }
        }
      }

      await prefs.setString('id', userId);
      await prefs.setString('email', email);
      await prefs.setString('nombre', nombre);
      await prefs.setString('direccionPrincipal', mainAddress);
      await prefs.setString('rol', _selectedUserType == UserType.usuario ? 'usuario' : 'repartidor');
    } catch (e) {
      // No bloqueamos el login si falla el guardado; solo log
      debugPrint('Error guardando SharedPreferences: $e');
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