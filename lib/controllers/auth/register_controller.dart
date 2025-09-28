import 'package:flutter/material.dart';
import '../../../services/auth_service.dart';
import '../../../models/user_model.dart';

/// Controlador para manejar la lógica del registro
class RegisterController extends ChangeNotifier {
  final AuthService _authService = AuthService();
  
  bool _isLoading = false;
  String? _errorMessage;
  UserModel? _registeredUser;

  /// Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  UserModel? get registeredUser => _registeredUser;

  /// Registra un nuevo usuario
  Future<bool> registerUser({
    required String nombre,
    required String apellido,
    required String telefono,
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final result = await _authService.registerUser(
        nombre: nombre,
        apellido: apellido,
        telefono: telefono,
        email: email,
        password: password,
      );

      if (result.isSuccess) {
        // Crear el modelo de usuario registrado
        _registeredUser = UserModel(
          id: result.userId!,
          nombre: nombre,
          apellido: apellido,
          telefono: telefono,
          correo: email,
          createdAt: DateTime.now(),
        );

        _showSuccessMessage(context);
        return true;
      } else {
        _setError(result.errorMessage ?? 'Error desconocido');
        _showErrorMessage(context, result.errorMessage ?? 'Error desconocido');
        return false;
      }
    } catch (e) {
      _setError(e.toString());
      _showErrorMessage(context, e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Navega al home después del registro exitoso
  void navigateToHome(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/home');
  }

  /// Navega al login
  void navigateToLogin(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/iniciar-sesion');
  }

  /// Muestra mensaje de éxito
  void _showSuccessMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Usuario registrado exitosamente'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      ),
    );
  }

  /// Muestra mensaje de error
  void _showErrorMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error: $message'),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  /// Establece el estado de carga
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Establece un mensaje de error
  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  /// Limpia el mensaje de error
  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Limpia todos los datos
  void clear() {
    _isLoading = false;
    _errorMessage = null;
    _registeredUser = null;
    notifyListeners();
  }

  @override
  void dispose() {
    clear();
    super.dispose();
  }
}