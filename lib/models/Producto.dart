import 'package:cloud_firestore/cloud_firestore.dart';

class Producto {

  String id;
  String idCategoria;
  String imagenUrl;
  String nombre;
  double precio;
  int stock;

  String firebaseCollection = 'productos';

  Producto({
    required this.id,
    required this.idCategoria,
    required this.imagenUrl,
    required this.nombre,
    required this.precio,
    required this.stock,
  });

  /// Constructor para crear un Producto desde un Map (Firebase/JSON)
  factory Producto.fromMap(Map<String, dynamic> map, String documentId) {
    return Producto(
      id: documentId,
      idCategoria: map['id_categoria'] ?? '',
      imagenUrl: map['imagen_url'] ?? '',
      nombre: map['nombre'] ?? '',
      precio: (map['precio'] ?? 0).toDouble(),
      stock: map['stock'] ?? 0,
    );
  }

  /// Convierte el Producto a un Map para guardar en Firebase
  Map<String, dynamic> toMap() {
    return {
      'id_categoria': idCategoria,
      'imagen_url': imagenUrl,
      'nombre': nombre,
      'precio': precio,
      'stock': stock,
    };
  }

  /// Verifica si el producto está disponible (tiene stock)
  bool get disponible => stock > 0;

  /// Método estático para obtener todos los productos desde Firebase
  static Future<List<Producto>> obtenerProductos() async {
    try {
      print('📦 Obteniendo productos desde Firebase...');
      
      final firebase = FirebaseFirestore.instance;
      
      // Obtener todos los documentos de la colección productos
      final QuerySnapshot querySnapshot = await firebase
          .collection('productos')
          .get();

      print('📊 Total de productos encontrados: ${querySnapshot.docs.length}');

      // Convertir cada documento a un objeto Producto
      final List<Producto> productos = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Producto.fromMap(data, doc.id);
      }).toList();

      print('✅ Productos cargados exitosamente');
      return productos;
      
    } catch (e) {
      print('❌ Error obteniendo productos: $e');
      throw Exception('Error al obtener productos: ${e.toString()}');
    }
  }

  /// Método estático para obtener productos por categoría
  static Future<List<Producto>> obtenerProductosPorCategoria(String idCategoria) async {
    try {
      print('📦 Obteniendo productos de la categoría: $idCategoria');
      
      final firebase = FirebaseFirestore.instance;
      
      // Obtener productos filtrados por categoría
      final QuerySnapshot querySnapshot = await firebase
          .collection('productos')
          .where('id_categoria', isEqualTo: idCategoria)
          .get();

      print('📊 Productos encontrados en la categoría: ${querySnapshot.docs.length}');

      // Convertir cada documento a un objeto Producto
      final List<Producto> productos = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Producto.fromMap(data, doc.id);
      }).toList();

      print('✅ Productos de categoría cargados exitosamente');
      return productos;
      
    } catch (e) {
      print('❌ Error obteniendo productos por categoría: $e');
      throw Exception('Error al obtener productos por categoría: ${e.toString()}');
    }
  }

  /// Método estático para obtener un producto por ID
  static Future<Producto?> obtenerProductoPorId(String id) async {
    try {
      print('🔍 Buscando producto con ID: $id');
      
      final firebase = FirebaseFirestore.instance;
      
      final DocumentSnapshot doc = await firebase.collection('productos').doc(id).get();
      
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        print('✅ Producto encontrado: ${data['nombre']}');
        return Producto.fromMap(data, doc.id);
      } else {
        print('⚠️ Producto no encontrado con ID: $id');
        return null;
      }
      
    } catch (e) {
      print('❌ Error obteniendo producto por ID: $e');
      return null;
    }
  }

  /// Método estático para obtener los productos de un pedido dado su ID
  /// Lee la colección 'pedidos', extrae 'lista_productos' y consulta los
  /// documentos de 'productos' correspondientes (en lotes de hasta 10 IDs por consulta).
  static Future<List<Producto>> obtenerProductosPorIdPedido(String pedidoId) async {
    try {
      if (pedidoId.isEmpty) {
        throw Exception('El ID del pedido no puede estar vacío');
      }

      print('📦 Obteniendo productos del pedido: $pedidoId');

      final firebase = FirebaseFirestore.instance;

      // Obtener el documento del pedido para extraer la lista de IDs de productos
      final DocumentSnapshot pedidoDoc = await firebase.collection('pedidos').doc(pedidoId).get();
      if (!pedidoDoc.exists) {
        print('⚠️ Pedido no encontrado: $pedidoId');
        return [];
      }

      final Map<String, dynamic> data = pedidoDoc.data() as Map<String, dynamic>;
      final List<dynamic> lista = (data['lista_productos'] as List<dynamic>?) ?? [];

      // Extraer los IDs de producto preservando el orden del pedido
      final List<String> productoIds = lista
          .map((e) => (e as Map<String, dynamic>)['id_producto']?.toString() ?? '')
          .where((id) => id.isNotEmpty)
          .toList();

      if (productoIds.isEmpty) {
        print('ℹ️ El pedido no contiene productos');
        return [];
      }

      // Consultar productos en lotes de 10 (límite de whereIn)
      final List<Producto> resultados = [];
      final Map<String, Producto> mapaPorId = {};

      for (int i = 0; i < productoIds.length; i += 10) {
        final List<String> chunk = productoIds.sublist(
          i,
          i + 10 > productoIds.length ? productoIds.length : i + 10,
        );

        final QuerySnapshot query = await firebase
            .collection('productos')
            .where(FieldPath.documentId, whereIn: chunk)
            .get();

        for (final doc in query.docs) {
          final datos = doc.data() as Map<String, dynamic>;
          final prod = Producto.fromMap(datos, doc.id);
          mapaPorId[doc.id] = prod;
        }
      }

      // Reordenar según el orden del pedido
      for (final id in productoIds) {
        final prod = mapaPorId[id];
        if (prod != null) resultados.add(prod);
      }

      print('✅ Productos del pedido cargados: ${resultados.length}');
      return resultados;
    } catch (e) {
      print('❌ Error obteniendo productos por ID de pedido: $e');
      throw Exception('Error al obtener productos por ID de pedido: ${e.toString()}');
    }
  }
}
