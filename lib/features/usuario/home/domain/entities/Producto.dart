class Producto {

  final String id;
  final String nombre;
  final String descripcion;
  final double precio;
  final String imagenUrl;
  final String categoriaId;

  Producto({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.imagenUrl,
    required this.categoriaId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'precio': precio,
      'imagenUrl': imagenUrl,
      'categoriaId': categoriaId,
    };
  }
  
  factory Producto.fromMap(Map<String, dynamic> map) {
    return Producto(
      id: map['id'] ?? '',
      nombre: map['nombre'] ?? '',
      descripcion: map['descripcion'] ?? '',
      precio: (map['precio'] is num) ? (map['precio'] as num).toDouble() : 0.0,
      imagenUrl: map['imagen_url'] ?? '',
      categoriaId: map['categoria_id'] ?? '',
    );
  }
}

