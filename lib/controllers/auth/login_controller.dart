import 'package:flutter/material.dart';
import '../../../services/auth_service.dart';
import '../../../models/user_model.dart';

/// Controlador para manejar la lógica del login
class LoginController extends ChangeNotifier {
  final AuthService _authService = AuthService();
  
  bool _isLoading = false;
  String? _errorMessage;
  UserModel? _loggedInUser;

  /// Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  UserModel? get loggedInUser => _loggedInUser;

  /// Inicia sesión de usuario
  Future<bool> loginUser({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final result = await _authService.loginUser(
        email: email,
        password: password,
      );

      if (result.isSuccess) {
        // TODO: Obtener datos completos del usuario desde la base de datos
        _loggedInUser = UserModel(
          id: result.userId!,
          nombre: 'Usuario', // Placeholder
          apellido: 'Simulado', // Placeholder
          telefono: '', // Placeholder
          email: email,
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

  /// Navega al home después del login exitoso
  void navigateToHome(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/home');
  }

  /// Navega al registro
  void navigateToRegister(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/registro');
  }

  /// Muestra mensaje de éxito
  void _showSuccessMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sesión iniciada correctamente'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
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
    _loggedInUser = null;
    notifyListeners();
  }

  @override
  void dispose() {
    clear();
    super.dispose();
  }
}