import 'package:mi_mercado/features/usuario/productos/domain/datasources/producto_datasource.dart';
import 'package:mi_mercado/features/usuario/productos/domain/entities/Producto.dart';
import 'package:mi_mercado/features/usuario/productos/domain/repositories/producto_repository.dart';

class ProductoRepositoryImpl implements ProductoRepository {
  final ProductoDataSource _productoDataSource;

  ProductoRepositoryImpl(this._productoDataSource);

  @override
  Future<List<Producto>> obtenerProductos() {
    print('producto_repository_impl.dart: obteniendo productos desde el datasource');
    return _productoDataSource.obtenerProductos();
  }

  @override
  Future<List<Producto>> obtenerProductosPorCategoria(String categoriaId) {
    print('producto_repository_impl.dart: obteniendo productos por categoria desde el datasource');
    return _productoDataSource.obtenerProductosPorCategoria(categoriaId);
  }

  @override
  Future<List<Producto>> obtenerProductosPorIds(List<String> productoIds) {
    print('producto_repository_impl.dart: obteniendo productos por IDs desde el datasource');
    return _productoDataSource.obtenerProductosPorIds(productoIds);
  }
}