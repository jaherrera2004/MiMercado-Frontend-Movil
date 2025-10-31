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
          .map((doc) => Categoria.fromMap(doc.data()))
          .toList();
      print('categoria_datasoruce_impl.dart: categorías obtenidas (${categorias.length})');
      return categorias;
    } catch (e) {
      print('categoria_datasoruce_impl.dart: error al obtener categorías: $e');
      throw Exception('Error al obtener categorías: $e');
    }
  }
}