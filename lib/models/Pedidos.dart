import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mi_mercado/models/SharedPreferences.dart';
import 'Repartidor.dart';

/// Clase que representa un producto dentro de un pedido
class ProductoPedido {
  String idProducto;
  int cantidad;

  static double valorDomicilio = 5000; // Valor por defecto
  static double valorServicio = 2000; // Valor del servicio

  ProductoPedido({
    required this.idProducto,
    required this.cantidad,
  });

  /// Constructor desde Map (Firebase/JSON)
  factory ProductoPedido.fromMap(Map<String, dynamic> map) {
    return ProductoPedido(
      idProducto: map['id_producto'] ?? '',
      cantidad: map['cantidad'] ?? 0,
    );
  }

  /// Convierte a Map para guardar en Firebase
  Map<String, dynamic> toMap() {
    return {
      'id_producto': idProducto,
      'cantidad': cantidad,
    };
  }

  @override
  String toString() {
    return 'ProductoPedido(idProducto: $idProducto, cantidad: $cantidad)';
  }
}

/// Clase principal que representa un Pedido
class Pedido {
  String id;
  double costoTotal;
  String direccion;
  String estado;
  DateTime fecha;
  String idRepartidor;
  String idUsuario;
  List<ProductoPedido> listaProductos;

  String firebaseCollection = 'pedidos';

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

  /// Constructor para crear un Pedido desde un Map (Firebase/JSON)
  factory Pedido.fromMap(Map<String, dynamic> map, String documentId) {
    // Parsear la fecha desde Timestamp de Firebase
    DateTime fechaPedido;
    if (map['fecha'] is Timestamp) {
      fechaPedido = (map['fecha'] as Timestamp).toDate();
    } else if (map['fecha'] is String) {
      fechaPedido = DateTime.parse(map['fecha']);
    } else {
      fechaPedido = DateTime.now();
    }

    // Parsear la lista de productos
    List<ProductoPedido> productos = [];
    if (map['lista_productos'] != null && map['lista_productos'] is List) {
      productos = (map['lista_productos'] as List)
          .map((item) => ProductoPedido.fromMap(item as Map<String, dynamic>))
          .toList();
    }

    return Pedido(
      id: documentId,
      costoTotal: (map['costo_total'] ?? 0).toDouble(),
      direccion: map['direccion'] ?? '',
      estado: map['estado'] ?? 'Pendiente',
      fecha: fechaPedido,
      idRepartidor: map['id_repartidor'] ?? '',
      idUsuario: map['id_usuario'] ?? '',
      listaProductos: productos,
    );
  }

  /// Convierte el Pedido a un Map para guardar en Firebase
  Map<String, dynamic> toMap() {
    return {
      'costo_total': costoTotal,
      'direccion': direccion,
      'estado': estado,
      'fecha': Timestamp.fromDate(fecha),
      'id_repartidor': idRepartidor,
      'id_usuario': idUsuario,
      'lista_productos': listaProductos.map((p) => p.toMap()).toList(),
    };
  }

  /// Estados posibles del pedido
  static const String estadoEnProceso = 'En Proceso';
  static const String estadoEnCamino = 'En Camino';
  static const String estadoEntregado = 'Entregado';
  static const String estadoCancelado = 'Cancelado';

  /// Obtiene el total de productos en el pedido
  int get totalProductos => listaProductos.fold(0, (sum, item) => sum + item.cantidad);

  /// Método estático para obtener pedidos por usuario
  static Future<List<Pedido>> obtenerPedidosPorUsuario() async {
    try {
      final String? userId = await SharedPreferencesService.getCurrentUserId();
      if (userId == null) {
        throw Exception('No se pudo obtener el ID del usuario');
      }

      print('📦 Obteniendo pedidos del usuario: $userId');

      final firebase = FirebaseFirestore.instance;
      
      // Obtener pedidos filtrados por usuario (sin orderBy para evitar índice compuesto)
      final QuerySnapshot querySnapshot = await firebase
          .collection('pedidos')
          .where('id_usuario', isEqualTo: userId)
          .get();

      print('📊 Pedidos encontrados para el usuario: ${querySnapshot.docs.length}');

      // Convertir cada documento a un objeto Pedido
      final List<Pedido> pedidos = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Pedido.fromMap(data, doc.id);
      }).toList();

      // Ordenar localmente por fecha descendente (más reciente primero)
      pedidos.sort((a, b) => b.fecha.compareTo(a.fecha));

      print('✅ Pedidos del usuario cargados exitosamente');
      return pedidos;
      
    } catch (e) {
      print('❌ Error obteniendo pedidos del usuario: $e');
      throw Exception('Error al obtener pedidos del usuario: ${e.toString()}');
    }
  }

  /// Método estático para obtener pedidos que están "En Proceso"
  static Future<List<Pedido>> obtenerPedidosEnProceso() async {
    try {
      print('🔄 Obteniendo pedidos en proceso...');
      
      final firebase = FirebaseFirestore.instance;
      
      // Obtener pedidos filtrados por estado "En Proceso" (sin orderBy para evitar índice compuesto)
      final QuerySnapshot querySnapshot = await firebase
          .collection('pedidos')
          .where('estado', isEqualTo: estadoEnProceso)
          .get();

      print('📊 Pedidos en proceso encontrados: ${querySnapshot.docs.length}');

      // Convertir cada documento a un objeto Pedido
      final List<Pedido> pedidos = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Pedido.fromMap(data, doc.id);
      }).toList();

      // Ordenar localmente por fecha ascendente (FIFO - los más antiguos primero)
      pedidos.sort((a, b) => a.fecha.compareTo(b.fecha));

      print('✅ Pedidos en proceso cargados exitosamente');
      return pedidos;
      
    } catch (e) {
      print('❌ Error obteniendo pedidos en proceso: $e');
      throw Exception('Error al obtener pedidos en proceso: ${e.toString()}');
    }
  }

 
  /// Método para crear un nuevo pedido en Firebase
  static Future<String> crearPedido(Pedido pedido) async {
    try {
      print('📝 Creando nuevo pedido...');
      
      final firebase = FirebaseFirestore.instance;
      
      // Agregar el pedido a Firebase
      final docRef = await firebase.collection('pedidos').add(pedido.toMap());
      
      print('✅ Pedido creado con ID: ${docRef.id}');
      return docRef.id;
      
    } catch (e) {
      print('❌ Error creando pedido: $e');
      throw Exception('Error al crear pedido: ${e.toString()}');
    }
  }

  /// Método para actualizar el estado del pedido
  Future<void> actualizarEstado(String nuevoEstado) async {
    try {
      print('🔄 Actualizando estado del pedido $id a: $nuevoEstado');
      
      final firebase = FirebaseFirestore.instance;
      
      await firebase.collection('pedidos').doc(id).update({
        'estado': nuevoEstado,
      });
      
      // Si el pedido se completa (entregado) o se cancela, liberar del repartidor
      if (nuevoEstado == estadoEntregado || nuevoEstado == estadoCancelado) {
        final bool repartidorLiberado = await Repartidor.liberarPedidoActual();
        if (!repartidorLiberado) {
          print('⚠️ Advertencia: No se pudo liberar el pedido del repartidor');
        } else {
          print('✅ Pedido liberado del repartidor exitosamente');
        }
      }
      
      // Actualizar el estado local
      estado = nuevoEstado;
      
      print('✅ Estado actualizado exitosamente');
      
    } catch (e) {
      print('❌ Error actualizando estado del pedido: $e');
      throw Exception('Error al actualizar estado del pedido: ${e.toString()}');
    }
  }

  /// Método estático para que un repartidor tome un pedido
  /// Asigna el repartidor al pedido y cambia el estado a "En Camino"
  static Future<bool> tomarPedido(String pedidoId) async {
    try {
      // Obtener el ID del repartidor desde SharedPreferences
      final String? repartidorId = await SharedPreferencesService.getCurrentUserId();
      if (repartidorId == null || repartidorId.isEmpty) {
        print('❌ Error: No se encontró el ID del repartidor');
        throw Exception('No se pudo obtener el ID del repartidor');
      }

      print('🚚 Repartidor $repartidorId tomando pedido $pedidoId...');
      
      final firebase = FirebaseFirestore.instance;
      final DocumentReference pedidoRef = firebase.collection('pedidos').doc(pedidoId);
      
      // Verificar que el pedido existe y está en estado "En Proceso"
      final DocumentSnapshot pedidoDoc = await pedidoRef.get();
      if (!pedidoDoc.exists) {
        throw Exception('El pedido no existe');
      }
      
      final Map<String, dynamic> pedidoData = pedidoDoc.data() as Map<String, dynamic>;
      final String estadoActual = pedidoData['estado'] ?? '';
      
      if (estadoActual != estadoEnProceso) {
        throw Exception('El pedido ya no está disponible (Estado: $estadoActual)');
      }
      
      // Actualizar el pedido con el repartidor asignado y nuevo estado
      await pedidoRef.update({
        'id_repartidor': repartidorId,
        'estado': estadoEnCamino,
      });
      
      // Actualizar el pedido actual en la colección del repartidor
      final bool repartidorActualizado = await Repartidor.asignarPedido(pedidoId);
      if (!repartidorActualizado) {
        print('⚠️ Advertencia: No se pudo actualizar el pedido actual del repartidor');
        // Nota: No lanzamos excepción aquí porque el pedido ya fue asignado exitosamente
      }
      
      print('✅ Pedido tomado exitosamente por repartidor $repartidorId');
      return true;
      
    } catch (e) {
      print('❌ Error tomando pedido: $e');
      throw Exception('Error al tomar el pedido: ${e.toString()}');
    }
  }

  /// Método de instancia para que el pedido actual sea tomado por un repartidor
  Future<bool> serTomadoPorRepartidor() async {
    try {
      final bool exito = await Pedido.tomarPedido(id);
      if (exito) {
        // Actualizar el estado local
        final String? repartidorId = await SharedPreferencesService.getCurrentUserId();
        if (repartidorId != null) {
          idRepartidor = repartidorId;
          estado = estadoEnCamino;
        }
      }
      return exito;
    } catch (e) {
      throw Exception('Error al ser tomado por repartidor: ${e.toString()}');
    }
  }

  /// Método para obtener un pedido por ID
  static Future<Pedido?> obtenerPedidoPorId(String id) async {
    try {
      print('🔍 Buscando pedido con ID: $id');
      
      final firebase = FirebaseFirestore.instance;
      
      final DocumentSnapshot doc = await firebase.collection('pedidos').doc(id).get();
      
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        print('✅ Pedido encontrado');
        return Pedido.fromMap(data, doc.id);
      } else {
        print('⚠️ Pedido no encontrado');
        return null;
      }
      
    } catch (e) {
      print('❌ Error obteniendo pedido por ID: $e');
      throw Exception('Error al obtener pedido por ID: ${e.toString()}');
    }
  }

  @override
  String toString() {
    return 'Pedido(id: $id, usuario: $idUsuario, estado: $estado, total: \$${costoTotal.toStringAsFixed(2)}, productos: ${listaProductos.length})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Pedido && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
