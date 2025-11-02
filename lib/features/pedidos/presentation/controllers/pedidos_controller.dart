import 'package:get/get.dart';
import 'package:mi_mercado/core/utils/shared_preferences_utils.dart';
import '../../domain/entities/Pedido.dart';
import '../../domain/useCases/obtener_pedidos.dart';

class PedidosController extends GetxController {
  final ObtenerPedidosUseCase obtenerPedidosUseCase;

  var pedidos = <Pedido>[].obs;
  var isLoading = false.obs;

  PedidosController({
    required this.obtenerPedidosUseCase,
  }) {
    print('PedidosController: Constructor llamado');
  }

  @override
  void onInit() {
    super.onInit();
    print('PedidosController: onInit llamado - controller inicializado');
    // No cargar pedidos automáticamente aquí, esperar a que se llame desde el screen
  }

  Future<void> cargarPedidosUsuario() async {
    print('PedidosController: cargarPedidosUsuario llamado');
    try {
      final userId = await SharedPreferencesUtils.getUserId();
      print('PedidosController: userId obtenido: $userId');

      if (userId != null) {
        print('PedidosController: Cargando pedidos para userId: $userId');
        await cargarPedidos(userId);
      } else {
        print('PedidosController: userId es null, no se pueden cargar pedidos');
        isLoading.value = false;
      }
    } catch (e) {
      print('PedidosController: Error en cargarPedidosUsuario: $e');
      isLoading.value = false;
    }
  }

  Future<void> cargarPedidos(String idUsuario) async {
    isLoading.value = true;
    final result = await obtenerPedidosUseCase.call(idUsuario);
    result.fold(
      (failure) => print('pedidos_controller.dart: error al cargar pedidos: $failure'),
      (data) {
        pedidos.value = data;
        print('pedidos_controller.dart: pedidos cargados (${data.length})');
      },
    );
    isLoading.value = false;
  }
}
