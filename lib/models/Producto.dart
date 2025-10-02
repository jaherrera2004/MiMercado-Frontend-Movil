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
}
