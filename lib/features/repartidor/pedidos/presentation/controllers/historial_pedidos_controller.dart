import 'package:get/get.dart';
import 'package:mi_mercado/core/utils/shared_preferences_utils.dart';
import 'package:mi_mercado/features/pedidos/domain/entities/Pedido.dart';
import 'package:mi_mercado/features/pedidos/domain/useCases/obtener_historial_pedidos.dart';

class HistorialPedidosController extends GetxController {
  final ObtenerHistorialPedidosUseCase obtenerHistorialPedidosUseCase;

  HistorialPedidosController({
    required this.obtenerHistorialPedidosUseCase,
  });

  // Estados observables
  var isLoading = false.obs;
  var pedidos = <Pedido>[].obs;
  var errorMessage = ''.obs;

  // Filtros
  var filtroSeleccionado = 'Todos'.obs;

  @override
  void onInit() {
    super.onInit();
    cargarHistorialPedidos();
  }

  Future<void> cargarHistorialPedidos() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final idRepartidor = await SharedPreferencesUtils.getUserId();
      
      if (idRepartidor == null || idRepartidor.isEmpty) {
        errorMessage.value = 'No se encontró el ID del repartidor';
        return;
      }

      final result = await obtenerHistorialPedidosUseCase(idRepartidor);

      result.fold(
        (failure) {
          errorMessage.value = failure.message;
          pedidos.clear();
        },
        (pedidosObtenidos) {
          pedidos.value = pedidosObtenidos;
        },
      );
    } catch (e) {
      errorMessage.value = 'Error al cargar el historial: $e';
      pedidos.clear();
    } finally {
      isLoading.value = false;
    }
  }

  void cambiarFiltro(String filtro) {
    filtroSeleccionado.value = filtro;
    // TODO: Implementar filtrado local si es necesario
  }

  List<Pedido> get pedidosFiltrados {
    if (filtroSeleccionado.value == 'Todos') {
      return pedidos;
    }

    final now = DateTime.now();
    return pedidos.where((pedido) {
      switch (filtroSeleccionado.value) {
        case 'Hoy':
          return pedido.fecha.year == now.year &&
                 pedido.fecha.month == now.month &&
                 pedido.fecha.day == now.day;
        case 'Esta Semana':
          final weekStart = now.subtract(Duration(days: now.weekday - 1));
          final weekEnd = weekStart.add(const Duration(days: 6));
          return pedido.fecha.isAfter(weekStart.subtract(const Duration(days: 1))) &&
                 pedido.fecha.isBefore(weekEnd.add(const Duration(days: 1)));
        case 'Este Mes':
          return pedido.fecha.year == now.year && pedido.fecha.month == now.month;
        default:
          return true;
      }
    }).toList();
  }

  int get totalCompletados => pedidos.length;

  void refrescar() {
    cargarHistorialPedidos();
  }
}