import 'package:cloud_firestore/cloud_firestore.dart';

class Pedido {

  String id;
  double costoTotal;
  String direccion;
  String estado;
  DateTime fecha;
  String idRepartidor;
  String idUsuario;
  List<ProductoPedido> listaProductos;

  Pedido({
    required this.id,
    required this.costoTotal,
    required this.direccion,
    required this.estado,
    required this.fecha,
    required this.idRepartidor,
    required this.idUsuario,
    required this.listaProductos,
  });

  // Factory constructor para crear Pedido desde un Map (Firestore)
  factory Pedido.fromMap(Map<String, dynamic> map) {
    return Pedido(
      id: map['id'] ?? '',
      costoTotal: (map['costo_total'] ?? 0.0).toDouble(),
      direccion: map['direccion'] ?? '',
      estado: map['estado'] ?? '',
      fecha: _parseFecha(map['fecha']),
      idRepartidor: map['id_repartidor'] ?? '',
      idUsuario: map['id_usuario'] ?? '',
      listaProductos: (map['lista_productos'] as List<dynamic>?)
          ?.map((item) => ProductoPedido.fromMap(item as Map<String, dynamic>))
          .toList() ?? [],
    );
  }

  // Método auxiliar para parsear la fecha desde diferentes formatos
  static DateTime _parseFecha(dynamic fechaData) {
    if (fechaData is Timestamp) {
      return fechaData.toDate();
    } else if (fechaData is DateTime) {
      return fechaData;
    } else if (fechaData is String) {
      return DateTime.parse(fechaData);
    } else {
      return DateTime.now();
    }
  }
}



class ProductoPedido {
  String idProducto;
  int cantidad;

  static double valorDomicilio = 5000; // Valor por defecto
  static double valorServicio = 2000; // Valor del servicio

  ProductoPedido({
    required this.idProducto,
    required this.cantidad,
  });

  // Factory constructor para crear ProductoPedido desde un Map
  factory ProductoPedido.fromMap(Map<String, dynamic> map) {
    return ProductoPedido(
      idProducto: map['id_producto'] ?? '',
      cantidad: (map['cantidad'] ?? 0).toInt(),
    );
  }
}
