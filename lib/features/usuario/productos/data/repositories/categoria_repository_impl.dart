import 'package:mi_mercado/features/usuario/productos/domain/datasources/categoria_datasource.dart';
import 'package:mi_mercado/features/usuario/productos/domain/entities/Categoria.dart';
import 'package:mi_mercado/features/usuario/productos/domain/repositories/categoria_repository.dart';

class CategoriaRepositoryImpl implements CategoriaRepository {

  final CategoriaDataSource _categoriaDataSource;

  CategoriaRepositoryImpl(this._categoriaDataSource);

  @override
  Future<List<Categoria>> obtenerCategorias() {
  print('categoria_repository_impl.dart: obteniendo categorías desde el datasource');
  return _categoriaDataSource.obtenerCategorias();
  }
}