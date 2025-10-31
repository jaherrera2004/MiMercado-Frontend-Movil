import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mi_mercado/features/usuario/home/domain/datasources/categoria_datasource.dart';
import 'package:mi_mercado/features/usuario/home/domain/entities/Categoria.dart';

class CategoriaDataSourceImpl implements CategoriaDataSource {

  final FirebaseFirestore _firestore;

  final String _coleccionCategorias = 'categorias';

  CategoriaDataSourceImpl(this._firestore);

  @override
  Future<List<Categoria>> obtenerCategorias() async {
    try {
      final snapshot = await _firestore.collection(_coleccionCategorias).get();
      final categorias = snapshot.docs
          .map((doc) {
            final map = doc.data();
            return Categoria(
              id: doc.id,
              imagenUrl: map['imagen_url'] ?? '',
              nombre: map['nombre'] ?? '',
            );
          })
          .toList();
      print('categoria_datasource_impl.dart: categorías obtenidas (${categorias.length})');
      return categorias;
    } catch (e) {
      print('categoria_datasource_impl.dart: error al obtener categorías: $e');
      throw Exception('Error al obtener categorías: $e');
    }
  }
}