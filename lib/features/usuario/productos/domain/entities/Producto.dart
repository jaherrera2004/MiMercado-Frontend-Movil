class Producto {
  final String id;
  final String nombre;
  final String descripcion;
  final double precio;
  final String imagenUrl;
  final String categoriaId;
  final int stock;

  Producto({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.imagenUrl,
    required this.categoriaId,
    required this.stock,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'precio': precio,
      'imagenUrl': imagenUrl,
      'categoriaId': categoriaId,
      'stock': stock,
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
      stock: (map['stock'] is int) ? map['stock'] as int : (map['stock'] is num) ? (map['stock'] as num).toInt() : 0,
    );
  }
}

