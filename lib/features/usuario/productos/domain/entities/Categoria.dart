class Categoria {

  
  String id;
  String imagenUrl;
  String nombre;

  String firebaseCollection = 'categorias';

  Categoria({
    required this.id,
    required this.imagenUrl,
    required this.nombre,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imagenUrl': imagenUrl,
      'nombre': nombre,
    };
  }
  factory Categoria.fromMap(Map<String, dynamic> map) {
    return Categoria(
      id: map['id'] ?? '',
      imagenUrl: map['imagen_url'] ?? '',
      nombre: map['nombre'] ?? '',
    );
  }
}