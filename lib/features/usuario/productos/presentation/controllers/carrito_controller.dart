import 'package:get/get.dart';
import '../../domain/entities/CarritoItem.dart';
import '../../domain/useCases/agregar_producto_carrito.dart';
import '../../domain/useCases/obtener_items_carrito.dart';
import '../../domain/useCases/incrementar_cantidad.dart';
import '../../domain/useCases/decrementar_cantidad.dart';
import '../../domain/useCases/eliminar_producto_carrito.dart';
import '../../domain/useCases/vaciar_carrito.dart';
import '../../domain/useCases/calcular_subtotal.dart';
import 'package:mi_mercado/core/useCases/use_case.dart';

class CarritoController extends GetxController {
  final AgregarProductoCarritoUseCase agregarProductoUseCase;
  final ObtenerItemsCarritoUseCase obtenerItemsUseCase;
  final IncrementarCantidadCarritoUseCase incrementarCantidadUseCase;
  final DecrementarCantidadCarritoUseCase decrementarCantidadUseCase;
  final EliminarProductoCarritoUseCase eliminarProductoUseCase;
  final VaciarCarritoUseCase vaciarCarritoUseCase;
  final SubtotalCarritoUseCase subtotalUseCase;

  var items = <CarritoItem>[].obs;
  var subtotal = 0.0.obs;

  CarritoController({
    required this.agregarProductoUseCase,
    required this.obtenerItemsUseCase,
    required this.incrementarCantidadUseCase,
    required this.decrementarCantidadUseCase,
    required this.eliminarProductoUseCase,
    required this.vaciarCarritoUseCase,
    required this.subtotalUseCase,
  });

  @override
  void onInit() {
    super.onInit();
    cargarItems();
    calcularSubtotal();
  }

  Future<void> cargarItems() async {
    final result = await obtenerItemsUseCase.call(NoParams());
    result.fold(
      (failure) => print('carrito_controller.dart: error al cargar items: $failure'),
      (data) {
        items.value = data;
        print('carrito_controller.dart: items cargados (${data.length})');
      },
    );
  }

  Future<void> agregarProducto(CarritoItem item) async {
    final result = await agregarProductoUseCase.call(item);
    result.fold(
      (failure) => print('carrito_controller.dart: error al agregar producto: $failure'),
      (_) {
        print('carrito_controller.dart: producto agregado (${item.nombre})');
        cargarItems();
        calcularSubtotal();
      },
    );
  }

  Future<void> incrementarCantidad(String idProducto) async {
    final result = await incrementarCantidadUseCase.call(idProducto);
    result.fold(
      (failure) => print('carrito_controller.dart: error al incrementar cantidad: $failure'),
      (_) {
        print('carrito_controller.dart: cantidad incrementada ($idProducto)');
        cargarItems();
        calcularSubtotal();
      },
    );
  }

  Future<void> decrementarCantidad(String idProducto) async {
    final result = await decrementarCantidadUseCase.call(idProducto);
    result.fold(
      (failure) => print('carrito_controller.dart: error al decrementar cantidad: $failure'),
      (_) {
        print('carrito_controller.dart: cantidad decrementada ($idProducto)');
        cargarItems();
        calcularSubtotal();
      },
    );
  }

  Future<void> eliminarProducto(String idProducto) async {
    final result = await eliminarProductoUseCase.call(idProducto);
    result.fold(
      (failure) => print('carrito_controller.dart: error al eliminar producto: $failure'),
      (_) {
        print('carrito_controller.dart: producto eliminado ($idProducto)');
        cargarItems();
        calcularSubtotal();
      },
    );
  }

  Future<void> vaciarCarrito() async {
    final result = await vaciarCarritoUseCase.call(NoParams());
    result.fold(
      (failure) => print('carrito_controller.dart: error al vaciar carrito: $failure'),
      (_) {
        print('carrito_controller.dart: carrito vaciado');
        cargarItems();
        calcularSubtotal();
      },
    );
  }

  Future<void> calcularSubtotal() async {
    final result = await subtotalUseCase.call(NoParams());
    result.fold(
      (failure) => print('carrito_controller.dart: error al calcular subtotal: $failure'),
      (total) {
        subtotal.value = total;
        print('carrito_controller.dart: subtotal actualizado ($total)');
      },
    );
  }
}
