import 'package:get/get.dart';
import 'package:mi_mercado/core/utils/shared_preferences_utils.dart';
import 'package:mi_mercado/features/pedidos/domain/useCases/obtener_pedido_actual_repartidor.dart';
import 'package:mi_mercado/features/pedidos/domain/useCases/actualizar_estado_pedido.dart';
import 'package:mi_mercado/features/pedidos/domain/entities/Pedido.dart';
import 'package:mi_mercado/features/usuario/cuenta/domain/useCases/obtener_usuario_por_id.dart';
import 'package:mi_mercado/features/auth/domain/entities/Usuario.dart';

class PedidoActualController extends GetxController {
  final ObtenerPedidoActualRepartidorUseCase obtenerPedidoActualUseCase;
  final ObtenerUsuarioPorIdUseCase obtenerUsuarioPorIdUseCase;
  final ActualizarEstadoPedidoUseCase actualizarEstadoPedidoUseCase;

  // Estados observables
  final pedidoActual = Rx<Pedido?>(null);
  final usuarioCliente = Rx<Usuario?>(null);
  final isLoading = false.obs;
  final errorMessage = Rx<String?>(null);

  PedidoActualController({
    required this.obtenerPedidoActualUseCase,
    required this.obtenerUsuarioPorIdUseCase,
    required this.actualizarEstadoPedidoUseCase,
  });

  @override
  void onInit() {
    super.onInit();
    cargarPedidoActual();
  }

  /// Carga el pedido actual del repartidor logueado
  Future<void> cargarPedidoActual() async {
    try {
      isLoading.value = true;
      errorMessage.value = null;

      // Obtener ID del repartidor actual
      final repartidorId = await SharedPreferencesUtils.getUserId();

      if (repartidorId == null) {
        pedidoActual.value = null;
        return;
      }

      // Obtener pedido actual del repartidor
      final result = await obtenerPedidoActualUseCase.call(repartidorId);

      result.fold(
        (failure) {
          print('PedidoActualController: Error obteniendo pedido actual: ${failure.message}');
          errorMessage.value = failure.message;
          pedidoActual.value = null;
          usuarioCliente.value = null;
        },
        (pedido) async {
          pedidoActual.value = pedido;
          print('PedidoActualController: Pedido actual cargado: ${pedido?.id ?? "null"}');

          // Si hay un pedido, cargar los datos del usuario cliente
          if (pedido != null && pedido.idUsuario.isNotEmpty) {
            await _cargarDatosUsuario(pedido.idUsuario);
          } else {
            usuarioCliente.value = null;
          }
        },
      );
    } catch (e) {
      print('PedidoActualController: Error inesperado: $e');
      errorMessage.value = 'Error inesperado al cargar el pedido';
      pedidoActual.value = null;
    } finally {
      isLoading.value = false;
    }
  }

  /// Refresca el pedido actual
  Future<void> refrescarPedido() async {
    await cargarPedidoActual();
  }

  /// Verifica si el repartidor tiene un pedido activo
  bool get tienePedidoActivo => pedidoActual.value != null;

  /// Obtiene el estado del pedido actual
  String? get estadoPedidoActual => pedidoActual.value?.estado;

  /// Limpia el pedido actual (útil después de completar entrega)
  void limpiarPedidoActual() {
    pedidoActual.value = null;
    usuarioCliente.value = null;
    errorMessage.value = null;
  }

  /// Marca el pedido actual como entregado
  Future<bool> marcarComoEntregado() async {
    try {
      if (pedidoActual.value == null) {
        errorMessage.value = 'No hay pedido activo para marcar como entregado';
        return false;
      }

      isLoading.value = true;
      errorMessage.value = null;

      final pedidoId = pedidoActual.value!.id;
      const nuevoEstado = 'Entregado';

      print('PedidoActualController: Marcando pedido $pedidoId como entregado');

      final result = await actualizarEstadoPedidoUseCase.call(
        ActualizarEstadoPedidoParams(
          idPedido: pedidoId,
          nuevoEstado: nuevoEstado,
        ),
      );

      return result.fold(
        (failure) {
          print('PedidoActualController: Error marcando pedido como entregado: ${failure.message}');
          errorMessage.value = failure.message;
          return false;
        },
        (_) {
          print('PedidoActualController: Pedido $pedidoId marcado como entregado exitosamente');
          // Actualizar el estado local del pedido
          pedidoActual.value = Pedido(
            id: pedidoActual.value!.id,
            costoTotal: pedidoActual.value!.costoTotal,
            direccion: pedidoActual.value!.direccion,
            estado: nuevoEstado,
            fecha: pedidoActual.value!.fecha,
            idRepartidor: pedidoActual.value!.idRepartidor,
            idUsuario: pedidoActual.value!.idUsuario,
            listaProductos: pedidoActual.value!.listaProductos,
          );
          return true;
        },
      );
    } catch (e) {
      print('PedidoActualController: Error inesperado marcando pedido como entregado: $e');
      errorMessage.value = 'Error inesperado al marcar pedido como entregado';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Carga los datos del usuario cliente
  Future<void> _cargarDatosUsuario(String usuarioId) async {
    try {
      print('PedidoActualController: Cargando datos del usuario $usuarioId');

      final result = await obtenerUsuarioPorIdUseCase.call(usuarioId);

      result.fold(
        (failure) {
          print('PedidoActualController: Error obteniendo datos del usuario: ${failure.message}');
          usuarioCliente.value = null;
        },
        (usuario) {
          usuarioCliente.value = usuario;
          print('PedidoActualController: Datos del usuario cargados: ${usuario?.nombre ?? "null"}');
        },
      );
    } catch (e) {
      print('PedidoActualController: Error inesperado al cargar datos del usuario: $e');
      usuarioCliente.value = null;
    }
  }
}
