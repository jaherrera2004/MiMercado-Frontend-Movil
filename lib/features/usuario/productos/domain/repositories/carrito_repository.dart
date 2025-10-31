import '../entities/CarritoItem.dart';

abstract class CarritoRepository {
	Future<void> agregarProducto(CarritoItem item);

	Future<void> incrementarCantidad(String idProducto);

	Future<void> decrementarCantidad(String idProducto);

	Future<void> eliminarProducto(String idProducto);

	Future<void> vaciarCarrito();

	List<CarritoItem> obtenerItems();

	double get subtotal;
}
