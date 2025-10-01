import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mi_mercado/models/SharedPreferences.dart';
import 'Usuario.dart';
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
      
      // Buscar en Firebase por email y password
      QuerySnapshot querySnapshot = await firebase
          .collection(collection)
          .where('email', isEqualTo: email)
          .where('password', isEqualTo: password)
          .get();
      
      if (querySnapshot.docs.isNotEmpty) {
        // Si se encuentra el usuario, crear la instancia correspondiente
        var userData = querySnapshot.docs.first.data() as Map<String, dynamic>;
        var docId = querySnapshot.docs.first.id;
        
        
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
      
      // Si no se encuentra, retornar null
      return null;
      
    } catch (e) {
      print('Error en login: ${e.toString()}');
      return null;
    }
  }
  /// Método estático para cerrar sesión del usuario actual
  static Future<void> cerrarSesion() async {
    try {
      print('🚪 Cerrando sesión del usuario...');
      
      // Obtener el ID del usuario actual para logging
      final String? currentUserId = await SharedPreferencesService.getCurrentUserId();
      
      if (currentUserId != null && currentUserId.isNotEmpty) {
        print('👤 Cerrando sesión del usuario ID: $currentUserId');
      }
      
      // Limpiar todos los datos de sesión en SharedPreferences
      await SharedPreferencesService.clearSessionData();
      
      print('✅ Sesión cerrada exitosamente');
      print('🧹 Datos de sesión eliminados de SharedPreferences');
      
    } catch (e) {
      print('❌ Error cerrando sesión: $e');
      throw Exception('Error al cerrar sesión: ${e.toString()}');
    }
  }
}

