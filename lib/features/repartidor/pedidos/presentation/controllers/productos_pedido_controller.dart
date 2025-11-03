import 'package:get/get.dart';
import 'package:mi_mercado/features/usuario/productos/domain/entities/Producto.dart';
import 'package:mi_mercado/features/usuario/productos/domain/useCases/obtener_productos_pedido.dart';

class ProductosPedidoController extends GetxController {
  final ObtenerProductosPedido obtenerProductosPedido;

  // Estados observables
  final productos = <Producto>[].obs;
  final isLoading = false.obs;
  final errorMessage = Rx<String?>(null);

  ProductosPedidoController({
    required this.obtenerProductosPedido,
  });

  /// Carga los productos de un pedido dado los IDs
  Future<void> cargarProductosPedido(List<String> productoIds) async {
    try {
      isLoading.value = true;
      errorMessage.value = null;

      final result = await obtenerProductosPedido.call(productoIds);

      result.fold(
        (failure) {
          print('ProductosPedidoController: Error obteniendo productos: ${failure.message}');
          errorMessage.value = failure.message;
          productos.clear();
        },
        (productosList) {
          productos.value = productosList;
          print('ProductosPedidoController: ${productosList.length} productos cargados');
        },
      );
    } catch (e) {
      print('ProductosPedidoController: Error inesperado: $e');
      errorMessage.value = 'Error inesperado al cargar productos';
      productos.clear();
    } finally {
      isLoading.value = false;
    }
  }

  /// Limpia los datos del controller
  void limpiarDatos() {
    productos.clear();
    errorMessage.value = null;
    isLoading.value = false;
  }
}