import 'package:mi_mercado/features/usuario/home/domain/entities/Categoria.dart';
import 'package:mi_mercado/features/usuario/home/domain/entities/Producto.dart';
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

  // Métodos para cargar categorías y productos pueden ir aquí
}
