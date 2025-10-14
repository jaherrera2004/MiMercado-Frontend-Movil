import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mi_mercado/models/SharedPreferences.dart';
import 'Usuario.dart';
import 'package:bcrypt/bcrypt.dart';
import 'Repartidor.dart';

abstract class Persona {
  String id;
  String? nombre;
  String? apellido;
  String? email;
  String? password;
  String? telefono;
  String firebaseCollection;

  Persona({
    required this.id,
    this.nombre,
    this.apellido,
    this.email,
    this.password,
    this.telefono,
    required this.firebaseCollection,
  });

  @override
  String toString() {
    return 'Persona(id: $id, nombre: $nombre, apellido: $apellido, email: $email)';
  }

  // Método estático para login que retorna la persona específica
  static Future<Persona?> login(String email, String password, String tipoUsuario) async {
    try {
      final firebase = FirebaseFirestore.instance;
      String collection = tipoUsuario == 'usuario' ? 'usuarios' : 'repartidores';
      
      // Buscar en Firebase solo por email
      QuerySnapshot querySnapshot = await firebase
          .collection(collection)
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var userData = querySnapshot.docs.first.data() as Map<String, dynamic>;
        var docId = querySnapshot.docs.first.id;
        String? passwordHash = userData['password'];

        // Verificar la contraseña usando bcrypt
        if (passwordHash != null && BCrypt.checkpw(password, passwordHash)) {
          if (tipoUsuario == 'usuario') {
            var usuario = Usuario(
              id: docId,
              nombre: userData['nombre'],
              apellido: userData['apellido'],
              email: userData['email'],
              password: userData['password'],
              telefono: userData['telefono'],
              direcciones: List<Map<String, dynamic>>.from(userData['direcciones'] ?? []),
              pedidos: userData['pedidos'] ?? [],
            );
            return usuario;
          } else {
            return Repartidor(
              id: docId,
              nombre: userData['nombre'],
              apellido: userData['apellido'],
              email: userData['email'],
              password: userData['password'],
              telefono: userData['telefono'],
              cedula: userData['cedula'] ?? '',
              estadoActual: userData['estado_actual'] ?? '',
              historialPedidos: userData['historial_pedidos'] ?? [],
              pedidoActual: userData['pedido_actual'] ?? '',
            );
          }
        }
      }
      // Si no se encuentra o la contraseña no coincide, retornar null
      return null;
      
    } catch (e) {
      print('Error en login: ${e.toString()}');
      return null;
    }
  }
  /// Método estático para cerrar sesión del usuario actual
  static Future<void> cerrarSesion() async {
    try {
  // Limpiar todos los datos de sesión en SharedPreferences
  await SharedPreferencesService.clearSessionData();
      
    } catch (e) {
      // Mantener print de error para depuración en caso de fallo al cerrar sesión
      print('❌ Error cerrando sesión: $e');
      throw Exception('Error al cerrar sesión: ${e.toString()}');
    }
  }
}

