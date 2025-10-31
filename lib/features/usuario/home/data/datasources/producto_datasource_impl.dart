import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mi_mercado/features/usuario/home/domain/datasources/producto_datasource.dart';
import 'package:mi_mercado/features/usuario/home/domain/entities/Producto.dart';

class ProductoDataSourceImpl implements ProductoDataSource {

  final FirebaseFirestore _firestore;

  final String _coleccionProductos = 'productos';

  ProductoDataSourceImpl(this._firestore);

  @override
  Future<List<Producto>> obtenerProductos() async {
    try {
      final snapshot = await _firestore.collection(_coleccionProductos).where('stock', isGreaterThan: 0).get();
      final productos = snapshot.docs
          .map((doc) => Producto.fromMap(doc.data()))
          .toList();
      print('producto_datasource_impl.dart: productos obtenidos (${productos.length})');
      return productos;
    } catch (e) {
      print('producto_datasource_impl.dart: error al obtener productos: $e');
      throw Exception('Error al obtener productos: $e');
    }
  }
}