import 'package:mi_mercado/features/usuario/productos/domain/entities/Categoria.dart';
import 'package:mi_mercado/features/usuario/productos/domain/entities/Producto.dart';
import 'package:mi_mercado/features/usuario/productos/domain/entities/CarritoItem.dart';
import '../controllers/carrito_controller.dart';
import '../../domain/useCases/obtener_categorias.dart';
import '../../domain/useCases/obtener_productos.dart';
import 'package:mi_mercado/core/useCases/use_case.dart';
import 'package:get/get.dart';


class HomePageController extends GetxController {

  final ObtenerCategorias obtenerCategorias;
  final ObtenerProductos obtenerProductos;

  HomePageController({
    required this.obtenerCategorias,
    required this.obtenerProductos,
  }) {
    print('HomePageController: constructor');
  }

  @override
  void onInit() {
    print('HomePageController: onInit');
    super.onInit();
    cargarCategorias();
    cargarProductos();
  }

  Future<void> cargarCategorias() async {
    final result = await obtenerCategorias.call(NoParams());
    result.fold(
      (failure) {
        print('HomePageController: Error al cargar categorías: ${failure.toString()}');
      },
      (cats) {
        print('HomePageController: Categorías cargadas: ${cats.length}');
        categorias.assignAll(cats);
      },
    );
  }

  Future<void> cargarProductos() async {
    final result = await obtenerProductos.call(NoParams());
    result.fold(
      (failure) {
        print('HomePageController: Error al cargar productos: ${failure.toString()}');
      },
      (prods) {
        print('HomePageController: Productos cargados: ${prods.length}');
        productos.assignAll(prods);
        aplicarFiltro();
      },
    );
  }
  var categorias = <Categoria>[].obs;
  var productos = <Producto>[].obs;
  var productosFiltrados = <Producto>[].obs;
  var searchQuery = ''.obs;

  void aplicarFiltro() {
    final query = searchQuery.value.trim().toLowerCase();
    if (query.isEmpty) {
      productosFiltrados.assignAll(productos);
      return;
    }
    final filtrados = productos.where((p) => p.nombre.toLowerCase().contains(query)).toList();
    productosFiltrados.assignAll(filtrados);
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
    print('HomePageController: Producto añadido al carrito (${producto.nombre})');
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
    print('HomePageController: Producto añadido al carrito (${producto['nombre']})');
  }
}
