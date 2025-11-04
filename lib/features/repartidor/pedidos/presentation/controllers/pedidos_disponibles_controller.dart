import 'package:get/get.dart';
import 'package:mi_mercado/core/utils/shared_preferences_utils.dart';
import 'package:mi_mercado/features/pedidos/domain/useCases/obtener_pedidos_disponibles.dart';
import 'package:mi_mercado/features/pedidos/domain/useCases/tomar_pedido.dart';
import 'package:mi_mercado/features/pedidos/domain/entities/Pedido.dart';

class PedidosDisponiblesController extends GetxController {
  final ObtenerPedidosDisponiblesUseCase obtenerPedidosDisponiblesUseCase;
  final TomarPedidoUseCase tomarPedidoUseCase;

  // Estado observable
  final pedidosDisponibles = <Pedido>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  PedidosDisponiblesController({
    required this.obtenerPedidosDisponiblesUseCase,
    required this.tomarPedidoUseCase,
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
      // Obtener el ID del repartidor actual
      final repartidorId = await SharedPreferencesUtils.getUserId();

      if (repartidorId == null) {
        errorMessage.value = 'No se pudo obtener el ID del repartidor';
        print('PedidosDisponiblesController: Error - ID de repartidor no encontrado');
        return false;
      }

      print('PedidosDisponiblesController: Tomando pedido $pedidoId para repartidor $repartidorId');

      final result = await tomarPedidoUseCase.call(
        TomarPedidoParams(
          idPedido: pedidoId,
          idRepartidor: repartidorId,
        ),
      );

      return result.fold(
        (failure) {
          errorMessage.value = failure.message;
          print('PedidosDisponiblesController: Error al tomar pedido: ${failure.message}');
          return false;
        },
        (_) {
          // Remover el pedido de la lista local después de tomarlo exitosamente
          pedidosDisponibles.removeWhere((pedido) => pedido.id == pedidoId);
          print('PedidosDisponiblesController: Pedido $pedidoId tomado exitosamente');
          return true;
        },
      );
    } catch (e) {
      errorMessage.value = e.toString();
      print('PedidosDisponiblesController: Error inesperado al tomar pedido: $e');
      return false;
    }
  }
}