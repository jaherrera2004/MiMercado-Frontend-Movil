import 'package:get/get.dart';
import 'package:mi_mercado/features/pedidos/domain/entities/Pedido.dart';
import '../../domain/useCases/obtener_pedido_por_id.dart';
import 'package:mi_mercado/features/usuario/productos/domain/useCases/obtener_productos_pedido.dart';

class PedidoDetalleController extends GetxController {
  final ObtenerPedidoPorIdUseCase obtenerPedidoPorIdUseCase;
  final ObtenerProductosPedido obtenerProductosPedido;

  var pedido = Rxn<Pedido>();
  var isLoading = false.obs;
  var productosDetalle = <Map<String, dynamic>>[].obs;

  PedidoDetalleController({
    required this.obtenerPedidoPorIdUseCase,
    required this.obtenerProductosPedido,
  }) {
    print('PedidoDetalleController: Constructor llamado');
  }

  @override
  void onInit() {
    super.onInit();
    print('PedidoDetalleController: onInit llamado');
  }

  Future<void> cargarPedidoPorId(String pedidoId) async {
    print('PedidoDetalleController: cargarPedidoPorId llamado con ID: $pedidoId');
    
    // Si ya tenemos el mismo pedido cargado, no hacer nada
    if (pedido.value?.id == pedidoId) {
      print('PedidoDetalleController: Pedido ya cargado, omitiendo recarga');
      return;
    }
    
    // Limpiar datos anteriores antes de cargar el nuevo pedido
    pedido.value = null;
    productosDetalle.clear();
    
    isLoading.value = true;

    try {
      final result = await obtenerPedidoPorIdUseCase.call(pedidoId);
      await result.fold(
        (failure) async {
          print('PedidoDetalleController: Error al cargar pedido: $failure');
          isLoading.value = false;
        },
        (pedidoData) async {
          if (pedidoData != null) {
            pedido.value = pedidoData;
            await _cargarProductosDetalle(pedidoData);
            print('PedidoDetalleController: Pedido y productos cargados exitosamente: ${pedidoData.id}');
          } else {
            print('PedidoDetalleController: Pedido no encontrado');
          }
          isLoading.value = false;
        },
      );
    } catch (e) {
      print('PedidoDetalleController: Error en cargarPedidoPorId: $e');
      isLoading.value = false;
    }
  }

  Future<void> _cargarProductosDetalle(Pedido pedidoData) async {
    print('PedidoDetalleController: _cargarProductosDetalle llamado');

    // Obtener los IDs de productos del pedido
    final productoIds = pedidoData.listaProductos.map((producto) => producto.idProducto).toList();

    if (productoIds.isEmpty) {
      productosDetalle.value = [];
      return;
    }

    try {
      // Obtener los productos reales desde la base de datos
      final result = await obtenerProductosPedido.call(productoIds);
      result.fold(
        (failure) {
          print('PedidoDetalleController: Error al cargar productos: $failure');
          // Fallback: usar datos básicos del pedido
          productosDetalle.value = pedidoData.listaProductos.map((producto) => {
            'idProducto': producto.idProducto,
            'cantidad': producto.cantidad,
            'nombre': 'Producto ${producto.idProducto}',
            'precio': 0.0,
            'imagen': '',
          }).toList();
        },
        (productos) {
          // Combinar información del pedido con datos reales de productos
          productosDetalle.value = pedidoData.listaProductos.map((productoPedido) {
            final productoReal = productos.firstWhereOrNull(
              (p) => p.id == productoPedido.idProducto,
            );

            return {
              'idProducto': productoPedido.idProducto,
              'cantidad': productoPedido.cantidad,
              'nombre': productoReal?.nombre ?? 'Producto ${productoPedido.idProducto}',
              'precio': productoReal?.precio ?? 0.0,
              'imagen': productoReal?.imagenUrl ?? '',
            };
          }).toList();

          print('PedidoDetalleController: Productos detalle cargados exitosamente (${productosDetalle.length})');
        },
      );
    } catch (e) {
      print('PedidoDetalleController: Error en _cargarProductosDetalle: $e');
      // Fallback: usar datos básicos del pedido
      productosDetalle.value = pedidoData.listaProductos.map((producto) => {
        'idProducto': producto.idProducto,
        'cantidad': producto.cantidad,
        'nombre': 'Producto ${producto.idProducto}',
        'precio': 0.0,
        'imagen': '',
      }).toList();
    }
  }

  // Método para limpiar datos cuando se sale de la pantalla
  void limpiarDatos() {
    pedido.value = null;
    productosDetalle.clear();
    isLoading.value = false;
  }
}
