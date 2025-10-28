
abstract class Persona {
  String? id;
  String? nombre;
  String? apellido;
  String email;
  String password;
  String telefono;

  Persona({
    required this.id,
    this.nombre,
    this.apellido,
    required this.email,
    required this.password,
    required this.telefono,
  });

  @override
  String toString() {
    return 'Persona(id: $id, nombre: $nombre, apellido: $apellido, email: $email)';
  }
}
