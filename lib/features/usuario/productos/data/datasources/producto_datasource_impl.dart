import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mi_mercado/features/usuario/productos/domain/datasources/producto_datasource.dart';
import 'package:mi_mercado/features/usuario/productos/domain/entities/Producto.dart';

class ProductoDataSourceImpl implements ProductoDataSource {
  final FirebaseFirestore _firestore;
  final String _coleccionProductos = 'productos';

  ProductoDataSourceImpl(this._firestore);

  @override
  Future<List<Producto>> obtenerProductos() async {
    try {
      final snapshot = await _firestore.collection(_coleccionProductos).where('stock', isGreaterThan: 0).get();
      final productos = snapshot.docs
          .map((doc) => Producto.fromMap({...doc.data(), 'id': doc.id}))
          .toList();
      print('producto_datasource_impl.dart: productos obtenidos (${productos.length})');
      return productos;
    } catch (e) {
      print('producto_datasource_impl.dart: error al obtener productos: $e');
      throw Exception('Error al obtener productos: $e');
    }
  }

  @override
  Future<List<Producto>> obtenerProductosPorCategoria(String categoriaId) async {
    try {
      final snapshot = await _firestore.collection(_coleccionProductos)
        .where('id_categoria', isEqualTo: categoriaId)
        .get();

      final productos = snapshot.docs
          .map((doc) => Producto.fromMap({...doc.data(), 'id': doc.id}))
          .toList();

      print('producto_datasource_impl.dart: productos por categoria obtenidos (${productos.length})');

      return productos;
    } catch (e) {
      print('producto_datasource_impl.dart: error al obtener productos por categoria: $e');
      throw Exception('Error al obtener productos por categoria: $e');
    }
  }

  @override
  Future<List<Producto>> obtenerProductosPorIds(List<String> productoIds) async {
    try {
      if (productoIds.isEmpty) {
        return [];
      }

      // Firestore tiene un límite de 10 elementos en whereIn, así que dividimos en chunks si es necesario
      const int chunkSize = 10;
      List<Producto> allProductos = [];

      for (int i = 0; i < productoIds.length; i += chunkSize) {
        final end = (i + chunkSize < productoIds.length) ? i + chunkSize : productoIds.length;
        final chunk = productoIds.sublist(i, end);

        final snapshot = await _firestore.collection(_coleccionProductos)
          .where(FieldPath.documentId, whereIn: chunk)
          .get();

        final productos = snapshot.docs
            .map((doc) => Producto.fromMap({...doc.data(), 'id': doc.id}))
            .toList();

        allProductos.addAll(productos);
      }

      print('producto_datasource_impl.dart: productos por IDs obtenidos (${allProductos.length})');
      return allProductos;
    } catch (e) {
      print('producto_datasource_impl.dart: error al obtener productos por IDs: $e');
      throw Exception('Error al obtener productos por IDs: $e');
    }
  }
}