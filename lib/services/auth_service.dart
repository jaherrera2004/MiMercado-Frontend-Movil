import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Servicio de autenticación con Firebase
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
      // Validaciones básicas
      _validateRegistrationData(
        nombre: nombre,
        apellido: apellido,
        email: email,
        password: password,
      );

      // Crear usuario en Firebase Auth
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Crear documento del usuario en Firestore
      await FirebaseFirestore.instance.collection('usuarios').doc(userCredential.user!.uid).set({
        'nombre': nombre,
        'apellido': apellido,
        'telefono': telefono,
        'correo': email,
        'contrasena': password, // Nota: En producción, no guardar contraseñas en texto plano
        'direcciones': [],
        'historial_pedidos': [],
        'createdAt': FieldValue.serverTimestamp(),
      });

      print('Usuario registrado exitosamente: $nombre $apellido - $email');
      return UserRegistrationResult.success(
        userId: userCredential.user!.uid,
        email: email,
      );

    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException en registro: ${e.code} - ${e.message}');
      String errorMessage;
      switch (e.code) {
        case 'weak-password':
          errorMessage = 'La contraseña es muy débil';
          break;
        case 'email-already-in-use':
          errorMessage = 'Ya existe una cuenta con este email';
          break;
        case 'invalid-email':
          errorMessage = 'El email no es válido';
          break;
        case 'network-request-failed':
          errorMessage = 'Error de conexión. Verifica tu internet';
          break;
        case 'too-many-requests':
          errorMessage = 'Demasiados intentos. Intenta más tarde';
          break;
        default:
          errorMessage = 'Error de autenticación: ${e.message ?? e.code}';
      }
      return UserRegistrationResult.failure(errorMessage);
    } catch (e) {
      print('Error general en registro: $e');
      return UserRegistrationResult.failure('Error inesperado: ${e.toString()}');
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
      // Iniciar sesión con Firebase Auth
      final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      print('Login exitoso: $email');
      return UserLoginResult.success(
        userId: userCredential.user!.uid,
        email: email,
      );

    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException en login: ${e.code} - ${e.message}');
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No existe una cuenta con este email';
          break;
        case 'wrong-password':
          errorMessage = 'Contraseña incorrecta';
          break;
        case 'invalid-email':
          errorMessage = 'El email no es válido';
          break;
        case 'user-disabled':
          errorMessage = 'Esta cuenta ha sido deshabilitada';
          break;
        case 'network-request-failed':
          errorMessage = 'Error de conexión. Verifica tu internet';
          break;
        case 'too-many-requests':
          errorMessage = 'Demasiados intentos. Intenta más tarde';
          break;
        default:
          errorMessage = 'Error de autenticación: ${e.message ?? e.code}';
      }
      return UserLoginResult.failure(errorMessage);
    } catch (e) {
      print('Error general en login: $e');
      return UserLoginResult.failure('Error inesperado: ${e.toString()}');
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