import 'package:get/get.dart';
import 'package:mi_mercado/features/pedidos/domain/useCases/obtener_pedidos_disponibles.dart';
import 'package:mi_mercado/features/pedidos/domain/entities/Pedido.dart';

class PedidosDisponiblesController extends GetxController {
  final ObtenerPedidosDisponiblesUseCase obtenerPedidosDisponiblesUseCase;

  // Estado observable
  final pedidosDisponibles = <Pedido>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  PedidosDisponiblesController({
    required this.obtenerPedidosDisponiblesUseCase,
  });

  @override
  void onInit() {
    super.onInit();
    cargarPedidosDisponibles();
  }

  /// Carga la lista de pedidos disponibles
  Future<void> cargarPedidosDisponibles() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await obtenerPedidosDisponiblesUseCase.call(null);

      result.fold(
        (failure) {
          errorMessage.value = failure.message;
          pedidosDisponibles.clear();
          print('PedidosDisponiblesController: Error al cargar pedidos disponibles: ${failure.message}');
        },
        (pedidos) {
          pedidosDisponibles.value = pedidos;
          print('PedidosDisponiblesController: ${pedidos.length} pedidos disponibles cargados');
        },
      );
    } catch (e) {
      errorMessage.value = e.toString();
      pedidosDisponibles.clear();
      print('PedidosDisponiblesController: Error inesperado: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Refresca la lista de pedidos disponibles
  Future<void> refrescarPedidos() async {
    await cargarPedidosDisponibles();
  }

  /// Toma un pedido disponible (lo asigna al repartidor actual)
  Future<bool> tomarPedido(String pedidoId) async {
    try {
      // Aquí iría la lógica para tomar el pedido
      // Por ahora solo simulamos que se tomó exitosamente
      print('PedidosDisponiblesController: Tomando pedido $pedidoId');
      
      // Remover el pedido de la lista local
      pedidosDisponibles.removeWhere((pedido) => pedido.id == pedidoId);
      
      return true;
    } catch (e) {
      print('PedidosDisponiblesController: Error al tomar pedido: $e');
      return false;
    }
  }
}