import 'package:get/get.dart';
import 'package:mi_mercado/core/utils/shared_preferences_utils.dart';
import 'package:mi_mercado/features/pedidos/domain/useCases/obtener_pedido_actual_repartidor.dart';
import 'package:mi_mercado/features/pedidos/domain/entities/Pedido.dart';

class RepartidorHomeController extends GetxController {
  final ObtenerPedidoActualRepartidorUseCase obtenerPedidoActualUseCase;

  // Estado observable
  final estadoActual = 'Disponible'.obs;
  final pedidoActual = Rx<Pedido?>(null);
  final isLoading = false.obs;

  RepartidorHomeController({
    required this.obtenerPedidoActualUseCase,
  });

  @override
  void onInit() {
    super.onInit();
    cargarEstadoRepartidor();
  }

  /// Carga el estado del repartidor basado en si tiene pedido activo
  Future<void> cargarEstadoRepartidor() async {
    try {
      isLoading.value = true;

      // Obtener ID del repartidor actual
      final repartidorId = await SharedPreferencesUtils.getUserId();

      if (repartidorId == null) {
        estadoActual.value = 'Disponible';
        pedidoActual.value = null;
        return;
      }

      // Obtener pedido actual del repartidor
      final result = await obtenerPedidoActualUseCase.call(repartidorId);

      result.fold(
        (failure) {
          print('Error obteniendo pedido actual del repartidor: ${failure.message}');
          estadoActual.value = 'Disponible';
          pedidoActual.value = null;
        },
        (pedido) {
          pedidoActual.value = pedido;
          
          // Determinar el nuevo estado basado en si hay pedido activo
          final nuevoEstado = pedido != null ? 'Ocupado' : 'Disponible';
          
          print('RepartidorHomeController: pedido actual: ${pedido?.id ?? "null"}, estado del pedido: ${pedido?.estado ?? "null"}, nuevo estado del repartidor: $nuevoEstado');
          
          // Actualizar el estado siempre
          estadoActual.value = nuevoEstado;
        },
      );
    } catch (e) {
      estadoActual.value = 'Disponible';
      pedidoActual.value = null;
    } finally {
      isLoading.value = false;
    }
  }

  /// Refresca el estado del repartidor
  Future<void> refrescarEstado() async {
    await cargarEstadoRepartidor();
  }
}