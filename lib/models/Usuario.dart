import 'package:cloud_firestore/cloud_firestore.dart';
import 'Persona.dart';

class Usuario extends Persona {

  List<Map<String, dynamic>> direcciones;
  List<dynamic> pedidos;

  Usuario({
    required super.id,
    super.nombre,
    super.apellido,
    super.email,
    super.password,
    super.telefono,
    required this.direcciones,
    required this.pedidos,
  }) : super(firebaseCollection: 'usuarios');

  @override
  String toString() {
    return 'Usuario(id: $id, nombre: $nombre, apellido: $apellido, email: $email, telefono: $telefono)';
  }

  // Método público para registrar usuario en Firebase.
  Future<void> registrarUsuario() async {
    try {
      final firebase = FirebaseFirestore.instance;
      await firebase.collection(firebaseCollection).doc().set({
        'nombre': nombre ,
        'apellido': apellido,
        'telefono': telefono ,
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
