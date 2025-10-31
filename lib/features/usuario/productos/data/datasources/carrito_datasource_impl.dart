import 'package:get_storage/get_storage.dart';
import 'package:mi_mercado/features/usuario/productos/domain/datasources/carrito_datasource.dart';
import 'package:mi_mercado/features/usuario/productos/domain/entities/CarritoItem.dart';


class CarritoDataSourceImpl implements CarritoDataSource {
	final String _keyCarrito = 'carrito_items';
	final String _keyFechaActualizacion = 'carrito_fecha';
	final GetStorage _storage = GetStorage();

    @override
  Future<void> agregarProducto(CarritoItem item) async {
    print('carrito_datasoruce_impl.dart: Agregando producto al carrito: ${item.nombre}');
        final items = obtenerItems();
        final index = items.indexWhere((i) => i.idProducto == item.idProducto);
        if (index != -1) {
      print('carrito_datasoruce_impl.dart: Producto ya existe, incrementando cantidad');
          items[index].cantidad += item.cantidad;
        } else {
      print('carrito_datasoruce_impl.dart: Producto nuevo, agregando');
          items.add(item);
        }
        await _guardarItems(items);
    print('carrito_datasoruce_impl.dart: Carrito actualizado');
    }

    @override
		Future<void> incrementarCantidad(String idProducto) async {
			print('carrito_datasoruce_impl.dart: Incrementando cantidad de producto: $idProducto');
			final items = obtenerItems();
			final index = items.indexWhere((item) => item.idProducto == idProducto);
			if (index != -1) {
				items[index].cantidad++;
				await _guardarItems(items);
				print('carrito_datasoruce_impl.dart: Cantidad incrementada');
			} else {
				print('carrito_datasoruce_impl.dart: Producto no encontrado para incrementar');
			}
		}

    @override
		Future<void> decrementarCantidad(String idProducto) async {
			print('carrito_datasoruce_impl.dart: Decrementando cantidad de producto: $idProducto');
			final items = obtenerItems();
			final index = items.indexWhere((item) => item.idProducto == idProducto);
			if (index != -1) {
				if (items[index].cantidad > 1) {
					items[index].cantidad--;
					await _guardarItems(items);
				print('carrito_datasoruce_impl.dart: Cantidad decrementada');
				} else {
				print('carrito_datasoruce_impl.dart: Cantidad es 1, eliminando producto');
					await eliminarProducto(idProducto);
				}
			} else {
				print('carrito_datasoruce_impl.dart: Producto no encontrado para decrementar');
			}
		}

    @override
		Future<void> eliminarProducto(String idProducto) async {
			print('carrito_datasoruce_impl.dart: Eliminando producto del carrito: $idProducto');
			final items = obtenerItems();
			items.removeWhere((item) => item.idProducto == idProducto);
			await _guardarItems(items);
			print('carrito_datasoruce_impl.dart: Producto eliminado');
		}

    @override
		Future<void> vaciarCarrito() async {
			print('carrito_datasoruce_impl.dart: Vaciando carrito');
			await _storage.remove(_keyCarrito);
			await _storage.remove(_keyFechaActualizacion);
			print('carrito_datasoruce_impl.dart: Carrito vaciado');
		}

    @override
		List<CarritoItem> obtenerItems() {
			try {
				final itemsList = _storage.read<List>(_keyCarrito);
				if (itemsList != null) {
				print('carrito_datasoruce_impl.dart: Items obtenidos del storage: ${itemsList.length}');
					return itemsList
							.map((item) => CarritoItem.fromMap(Map<String, dynamic>.from(item)))
							.toList();
				}
				print('carrito_datasoruce_impl.dart: No hay items en el storage');
				return [];
			} catch (e) {
				print('carrito_datasoruce_impl.dart: Error obteniendo items: $e');
				return [];
			}
		}

		Future<void> _guardarItems(List<CarritoItem> items) async {
			print('carrito_datasoruce_impl.dart: Guardando items en storage: ${items.length}');
			final itemsMap = items.map((item) => item.toMap()).toList();
			await _storage.write(_keyCarrito, itemsMap);
			await _storage.write(_keyFechaActualizacion, DateTime.now().toIso8601String());
			print('carrito_datasoruce_impl.dart: Items guardados');
		}
    
    @override
		double get subtotal {
			final items = obtenerItems();
			final total = items.fold(0.0, (sum, item) => sum + item.subtotal);
			print('carrito_datasoruce_impl.dart: Subtotal calculado: $total');
			return total;
		}
}
