
import 'package:get/get.dart';
import 'package:mi_mercado/features/usuario/productos/domain/entities/CarritoItem.dart';
import '../controllers/carrito_controller.dart';
import 'package:mi_mercado/features/usuario/productos/domain/entities/Producto.dart';
import 'package:mi_mercado/features/usuario/productos/domain/useCases/obtener_productos_por_categoria.dart';
import 'package:mi_mercado/core/error/failure.dart';
import 'package:dartz/dartz.dart';

class ProductosFiltradosController extends GetxController {
	final ObtenerProductosPorCategoria obtenerProductosPorCategoria;

	ProductosFiltradosController({required this.obtenerProductosPorCategoria});

	var productos = <Producto>[].obs;
	var productosFiltrados = <Producto>[].obs;
	var isLoading = false.obs;
	var searchQuery = ''.obs;
	var categoriaId = ''.obs;
	var categoriaNombre = ''.obs;

	void cargarProductosPorCategoria(String categoriaId) async {
		isLoading.value = true;
		this.categoriaId.value = categoriaId;
		final Either<Failure, List<Producto>> result = await obtenerProductosPorCategoria(categoriaId);
		result.fold(
			(failure) {
				productos.clear();
				productosFiltrados.clear();
				print('Error al cargar productos por categoría: ${failure.toString()}');
			},
			(prods) {
				productos.assignAll(prods);
				aplicarFiltro();
			},
		);
		isLoading.value = false;
	}

	void aplicarFiltro() {
		final query = searchQuery.value.trim().toLowerCase();
		if (query.isEmpty) {
			productosFiltrados.assignAll(productos);
			return;
		}
		final filtrados = productos.where((p) => p.nombre.toLowerCase().contains(query)).toList();
		productosFiltrados.assignAll(filtrados);
	}

	void setCategoriaNombre(String nombre) {
		categoriaNombre.value = nombre;
	}

	void setSearchQuery(String query) {
		searchQuery.value = query;
		aplicarFiltro();
	}

    // Añadir producto al carrito
  Future<void> agregarProductoAlCarrito(Producto producto, {int cantidad = 1}) async {
    final carritoController = Get.find<CarritoController>();
    await carritoController.agregarProducto(
      CarritoItem(
        idProducto: producto.id,
        nombre: producto.nombre,
        precio: producto.precio,
        imagenUrl: producto.imagenUrl,
        cantidad: cantidad,
      ),
    );
    print('productosFiltradosController: Producto añadido al carrito (${producto.nombre})');
  }

  // Añadir producto al carrito desde un Map (por si usas maps en la UI)
  Future<void> agregarProductoMapAlCarrito(Map<String, dynamic> producto) async {
    final carritoController = Get.find<CarritoController>();
    await carritoController.agregarProducto(
      CarritoItem(
        idProducto: producto['id'],
        nombre: producto['nombre'],
        precio: producto['precioNumerico'],
        imagenUrl: producto['img'],
        cantidad: producto['cantidad'] ?? 1,
      ),
    );
    print('productosFiltradosController: Producto añadido al carrito (${producto['nombre']})');
  }
}
