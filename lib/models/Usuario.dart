import 'package:cloud_firestore/cloud_firestore.dart';

class Usuario {
  String apellido;
  List<Map<String, dynamic>> direcciones;
  String email;
  String nombre;
  String password;
  List<dynamic> pedidos;
  String telefono;

  String firebaseCollection = 'usuarios';

  Usuario({
    required this.apellido,
    required this.direcciones,
    required this.email,
    required this.nombre,
    required this.password,
    required this.pedidos,
    required this.telefono,
  });

  // Método público para registrar usuario en Firebase.
  Future<void> registrarUsuario() async {
    try {
      final firebase = FirebaseFirestore.instance;
      await firebase.collection(firebaseCollection).doc().set({
        'nombre': nombre,
        'apellido': apellido,
        'telefono': telefono,
        'email': email,
        'password': password,
        'pedidos': pedidos,
        'direcciones': direcciones,
      });
    } catch (e) {
      print('Error al registrar usuario: ${e.toString()}');
      rethrow; // Re-lanza la excepción para que el llamador pueda manejarla
    }
  }
}
