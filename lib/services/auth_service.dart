import 'dart:async';

/// Servicio de autenticación (simulado por ahora)
class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  /// Registra un nuevo usuario
  Future<UserRegistrationResult> registerUser({
    required String nombre,
    required String apellido,
    required String telefono,
    required String email,
    required String password,
  }) async {
    try {
      // Simulación de delay de red
      await Future.delayed(const Duration(seconds: 2));
      
      // Validaciones básicas
      _validateRegistrationData(
        nombre: nombre,
        apellido: apellido,
        email: email,
        password: password,
      );

      // TODO: Aquí iría la implementación real con Firebase
      /*
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        'nombre': nombre,
        'apellido': apellido,
        'telefono': telefono,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return UserRegistrationResult.success(
        userId: userCredential.user!.uid,
        email: email,
      );
      */

      // Simulación de registro exitoso
      print('Usuario registrado exitosamente: $nombre $apellido - $email');
      return UserRegistrationResult.success(
        userId: 'simulated_user_id_${DateTime.now().millisecondsSinceEpoch}',
        email: email,
      );

    } catch (e) {
      return UserRegistrationResult.failure(e.toString());
    }
  }

  /// Valida los datos de registro
  void _validateRegistrationData({
    required String nombre,
    required String apellido,
    required String email,
    required String password,
  }) {
    if (nombre.trim().isEmpty) {
      throw AuthException('El nombre es requerido');
    }

    if (apellido.trim().isEmpty) {
      throw AuthException('El apellido es requerido');
    }

    if (email.trim().isEmpty || !_isValidEmail(email)) {
      throw AuthException('Email inválido');
    }

    if (password.length < 6) {
      throw AuthException('La contraseña debe tener al menos 6 caracteres');
    }
  }

  /// Valida formato de email
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  /// Inicia sesión de usuario
  Future<UserLoginResult> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      await Future.delayed(const Duration(seconds: 2));
      
      // TODO: Implementar lógica real de login
      print('Login simulado: $email');
      
      return UserLoginResult.success(
        userId: 'simulated_user_id',
        email: email,
      );
    } catch (e) {
      return UserLoginResult.failure(e.toString());
    }
  }
}

/// Resultado del registro de usuario
class UserRegistrationResult {
  final bool isSuccess;
  final String? userId;
  final String? email;
  final String? errorMessage;

  UserRegistrationResult._({
    required this.isSuccess,
    this.userId,
    this.email,
    this.errorMessage,
  });

  factory UserRegistrationResult.success({
    required String userId,
    required String email,
  }) {
    return UserRegistrationResult._(
      isSuccess: true,
      userId: userId,
      email: email,
    );
  }

  factory UserRegistrationResult.failure(String errorMessage) {
    return UserRegistrationResult._(
      isSuccess: false,
      errorMessage: errorMessage,
    );
  }
}

/// Resultado del login de usuario
class UserLoginResult {
  final bool isSuccess;
  final String? userId;
  final String? email;
  final String? errorMessage;

  UserLoginResult._({
    required this.isSuccess,
    this.userId,
    this.email,
    this.errorMessage,
  });

  factory UserLoginResult.success({
    required String userId,
    required String email,
  }) {
    return UserLoginResult._(
      isSuccess: true,
      userId: userId,
      email: email,
    );
  }

  factory UserLoginResult.failure(String errorMessage) {
    return UserLoginResult._(
      isSuccess: false,
      errorMessage: errorMessage,
    );
  }
}

/// Excepción personalizada para autenticación
class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => message;
}