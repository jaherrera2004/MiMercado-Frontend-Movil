class CarritoItem {
	String idProducto;
	int cantidad;
	double precio;
	String nombre;
	String? imagenUrl;

	CarritoItem({
		required this.idProducto,
		required this.cantidad,
		required this.precio,
		required this.nombre,
		this.imagenUrl,
	});

	factory CarritoItem.fromMap(Map<String, dynamic> map) {
		return CarritoItem(
			idProducto: map['id_producto'] ?? '',
			cantidad: map['cantidad'] ?? 0,
			precio: (map['precio'] ?? 0).toDouble(),
			nombre: map['nombre'] ?? '',
			imagenUrl: map['imagen_url'],
		);
	}

	Map<String, dynamic> toMap() {
		return {
			'id_producto': idProducto,
			'cantidad': cantidad,
			'precio': precio,
			'nombre': nombre,
			'imagen_url': imagenUrl,
		};
	}

	double get subtotal => precio * cantidad;
}