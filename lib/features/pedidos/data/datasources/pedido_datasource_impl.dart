import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/datasources/pedido_datasource.dart';
import '../../domain/entities/Pedido.dart';

class PedidoDataSourceImpl implements PedidoDataSource {
  final FirebaseFirestore _firestore;
  final String _coleccionPedidos = 'pedidos';

  PedidoDataSourceImpl(this._firestore);

  @override
  Future<String> agregarPedido(Pedido pedido) async {
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

      // Usar add() para que Firestore genere el ID automáticamente
      final docRef = await _firestore.collection(_coleccionPedidos).add(pedidoMap);
      print('pedido_datasource_impl.dart: pedido agregado con ID (${docRef.id})');
      return docRef.id;
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

  @override
  Future<Pedido?> obtenerPedidoActualRepartidor(String idRepartidor) async {
    try {
      print('pedido_datasource_impl.dart: buscando pedidos para repartidor $idRepartidor con estados ["En Proceso", "En Camino"]');
      
      final querySnapshot = await _firestore
          .collection(_coleccionPedidos)
          .where('id_repartidor', isEqualTo: idRepartidor)
          .where('estado', whereIn: ['En Proceso', 'En Camino'])
          .limit(1)
          .get();

      print('pedido_datasource_impl.dart: encontrados ${querySnapshot.docs.length} pedidos para repartidor $idRepartidor');

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        final data = doc.data();
        data['id'] = doc.id;
        final pedido = Pedido.fromMap(data);
        print('pedido_datasource_impl.dart: pedido encontrado - ID: ${pedido.id}, Estado: ${pedido.estado}, Repartidor: ${pedido.idRepartidor}');
        return pedido;
      } else {
        print('pedido_datasource_impl.dart: no hay pedido activo para el repartidor ($idRepartidor)');
        return null;
      }
    } catch (e) {
      print('pedido_datasource_impl.dart: error al obtener pedido actual del repartidor: $e');
      throw Exception('Error al obtener pedido actual del repartidor: $e');
    }
  }

  @override
  Future<List<Pedido>> obtenerPedidosDisponibles() async {
    try {
      print('pedido_datasource_impl.dart: obteniendo pedidos disponibles (estado: "En Proceso", sin repartidor asignado)');
      
      final querySnapshot = await _firestore
          .collection(_coleccionPedidos)
          .where('estado', isEqualTo: 'En Proceso')
          .where('id_repartidor', isEqualTo: '') // Pedidos sin repartidor asignado
          .get();

      final pedidos = querySnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return Pedido.fromMap(data);
      }).toList();

      // Ordenar por fecha en Dart (más antiguos primero - FIFO)
      pedidos.sort((a, b) => a.fecha.compareTo(b.fecha));

      print('pedido_datasource_impl.dart: encontrados ${pedidos.length} pedidos disponibles');
      return pedidos;
    } catch (e) {
      print('pedido_datasource_impl.dart: error al obtener pedidos disponibles: $e');
      throw Exception('Error al obtener pedidos disponibles: $e');
    }
  }
}