import 'package:mi_mercado/features/usuario/home/domain/datasources/producto_datasource.dart';
import 'package:mi_mercado/features/usuario/home/domain/entities/Producto.dart';
import 'package:mi_mercado/features/usuario/home/domain/repositories/producto_repository.dart';

class ProductoRepositoryImpl implements ProductoRepository {

  final ProductoDataSource _productoDataSource;

  ProductoRepositoryImpl(this._productoDataSource);

  @override
  Future<List<Producto>> obtenerProductos() {
  print('producto_repository_impl.dart: obteniendo productos desde el datasource');
  return _productoDataSource.obtenerProductos();
  }
}