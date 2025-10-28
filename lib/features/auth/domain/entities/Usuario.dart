import 'Persona.dart';

class Usuario extends Persona {

  List<Map<String, dynamic>> direcciones;
  List<dynamic> pedidos;

  Usuario({
    super.id,
    super.nombre,
    super.apellido,
    required super.email,
    required super.password,
    required super.telefono,
    required this.direcciones,
    required this.pedidos,
  });

  @override
  String toString() {
    return 'Usuario(id: $id, nombre: $nombre, apellido: $apellido, email: $email, telefono: $telefono)';
  }
  // Método para crear un Usuario desde un Map (como el que se obtiene de Firebase)
  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['id'] ?? '',
      nombre: map['nombre'] ?? '',
      apellido: map['apellido'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      telefono: map['telefono'] ?? '',
      direcciones: List<Map<String, dynamic>>.from(map['direcciones'] ?? []),
      pedidos: List<dynamic>.from(map['pedidos'] ?? []),
    );
  }
  
   Map<String, dynamic> toDocument() {
    return {
      'nombre': nombre,
      'apellido': apellido,
      'email': email,
      'password': password,
      'telefono': telefono,
      'direcciones': direcciones,
      'pedidos': pedidos,
    };
  }
}
