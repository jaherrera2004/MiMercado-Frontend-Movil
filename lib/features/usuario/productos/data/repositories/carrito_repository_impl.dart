import '../../domain/entities/CarritoItem.dart';
import '../../domain/datasources/carrito_datasource.dart';
import '../../domain/repositories/carrito_repository.dart';

class CarritoRepositoryImpl implements CarritoRepository {
  final CarritoDataSource dataSource;

  CarritoRepositoryImpl(this.dataSource);

  @override
    Future<void> agregarProducto(CarritoItem item) {
        print('carrito_repository_impl.dart: agregarProducto (${item.nombre})');
        return dataSource.agregarProducto(item);
    }

  @override
    Future<void> incrementarCantidad(String idProducto) {
        print('carrito_repository_impl.dart: incrementarCantidad ($idProducto)');
        return dataSource.incrementarCantidad(idProducto);
    }

  @override
    Future<void> decrementarCantidad(String idProducto) {
        print('carrito_repository_impl.dart: decrementarCantidad ($idProducto)');
        return dataSource.decrementarCantidad(idProducto);
    }

  @override
    Future<void> eliminarProducto(String idProducto) {
        print('carrito_repository_impl.dart: eliminarProducto ($idProducto)');
        return dataSource.eliminarProducto(idProducto);
    }

  @override
    Future<void> vaciarCarrito() {
        print('carrito_repository_impl.dart: vaciarCarrito');
        return dataSource.vaciarCarrito();
    }

  @override
    List<CarritoItem> obtenerItems() {
        print('carrito_repository_impl.dart: obtenerItems');
        return dataSource.obtenerItems();
    }

  @override
    double get subtotal {
        print('carrito_repository_impl.dart: subtotal');
        return dataSource.subtotal;
    }
}
