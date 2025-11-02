import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/datasources/pedido_datasource.dart';
import '../../domain/entities/Pedido.dart';

class PedidoDataSourceImpl implements PedidoDataSource {
  final FirebaseFirestore _firestore;
  final String _coleccionPedidos = 'pedidos';

  PedidoDataSourceImpl(this._firestore);

  @override
  Future<void> agregarPedido(Pedido pedido) async {
    try {
      final pedidoMap = {
        'costo_total': pedido.costoTotal,
        'direccion': pedido.direccion,
        'estado': pedido.estado,
        'fecha': pedido.fecha.toIso8601String(),
        'id_repartidor': pedido.idRepartidor,
        'id_usuario': pedido.idUsuario,
        'lista_productos': pedido.listaProductos.map((producto) => {
          'id_producto': producto.idProducto,
          'cantidad': producto.cantidad,
        }).toList(),
      };

      await _firestore.collection(_coleccionPedidos).doc(pedido.id).set(pedidoMap);
      print('pedido_datasource_impl.dart: pedido agregado (${pedido.id})');
    } catch (e) {
      print('pedido_datasource_impl.dart: error al agregar pedido: $e');
      throw Exception('Error al agregar pedido: $e');
    }
  }

  @override
  Future<List<Pedido>> obtenerPedidos(String idUsuario) async {
    try {
      final querySnapshot = await _firestore
          .collection(_coleccionPedidos)
          .where('id_usuario', isEqualTo: idUsuario)
          .get();

      final pedidos = querySnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id; // Asegurar que el ID del documento esté incluido
        return Pedido.fromMap(data);
      }).toList();

      print('pedido_datasource_impl.dart: pedidos obtenidos (${pedidos.length})');
      return pedidos;
    } catch (e) {
      print('pedido_datasource_impl.dart: error al obtener pedidos: $e');
      throw Exception('Error al obtener pedidos: $e');
    }
  }

  @override
  Future<Pedido?> obtenerPedidoPorId(String id) async {
    try {
      final docSnapshot = await _firestore.collection(_coleccionPedidos).doc(id).get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data()!;
        data['id'] = docSnapshot.id; // Asegurar que el ID del documento esté incluido
        final pedido = Pedido.fromMap(data);
        print('pedido_datasource_impl.dart: pedido obtenido ($id)');
        return pedido;
      } else {
        print('pedido_datasource_impl.dart: pedido no encontrado ($id)');
        return null;
      }
    } catch (e) {
      print('pedido_datasource_impl.dart: error al obtener pedido por ID: $e');
      throw Exception('Error al obtener pedido por ID: $e');
    }
  }
}