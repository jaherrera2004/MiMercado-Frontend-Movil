class Direccion {
  final String id;
  final String idUsuario;
  final String nombre;
  final String direccion;
  final String referencia;
  final bool esPrincipal;

  Direccion({
    required this.id,
    required this.idUsuario,
    required this.nombre,
    required this.direccion,
    required this.referencia,
    required this.esPrincipal,
  });

  factory Direccion.fromMap(Map<String, dynamic> map) {
    return Direccion(
      id: map['id'] ?? '',
      idUsuario: map['id_usuario'] ?? '',
      nombre: map['nombre'] ?? '',
      direccion: map['direccion'] ?? '',
      referencia: map['referencias'] ?? '',
      esPrincipal: map['principal'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_usuario': idUsuario,
      'nombre': nombre,
      'direccion': direccion,
      'referencias': referencia,
      'principal': esPrincipal,
    };
  }

  Map<String, dynamic> toDocument() {
    return toMap();
  }
}
