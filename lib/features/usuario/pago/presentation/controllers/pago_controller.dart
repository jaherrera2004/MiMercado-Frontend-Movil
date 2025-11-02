import 'package:get/get.dart';
import 'package:mi_mercado/core/useCases/use_case.dart';
import 'package:mi_mercado/core/utils/shared_preferences_utils.dart';
import 'package:mi_mercado/features/pedidos/domain/entities/Pedido.dart';
import 'package:mi_mercado/features/pedidos/domain/useCases/agregar_pedido.dart';
import 'package:mi_mercado/features/usuario/direcciones/domain/entities/Direccion.dart';
import 'package:mi_mercado/features/usuario/direcciones/domain/useCases/obtener_direcciones.dart';
import 'package:mi_mercado/features/usuario/productos/domain/entities/CarritoItem.dart';
import 'package:mi_mercado/features/usuario/productos/domain/useCases/calcular_subtotal.dart';
import 'package:mi_mercado/features/usuario/productos/domain/useCases/obtener_items_carrito.dart';
import 'package:mi_mercado/features/usuario/productos/domain/useCases/vaciar_carrito.dart';
import 'package:mi_mercado/features/usuario/productos/presentation/controllers/carrito_controller.dart';

class PagoController extends GetxController {
  final ObtenerDireccionesUseCase obtenerDireccionesUseCase;
  final AgregarPedidoUseCase agregarPedidoUseCase;
  final SubtotalCarritoUseCase subtotalCarritoUseCase;
  final ObtenerItemsCarritoUseCase obtenerItemsCarritoUseCase;
  final VaciarCarritoUseCase vaciarCarritoUseCase;

  // Estados observables
  var isLoading = false.obs;
  var cargandoDirecciones = true.obs;
  var direcciones = <Direccion>[].obs;
  var direccionSeleccionada = Rxn<String>();
  var carritoVacioObs = true.obs;
  var subtotalObs = 0.0.obs;
  var itemsCarritoObs = <CarritoItem>[].obs;

  // Costos fijos
  final double valorDomicilio = 5000.0;
  final double valorServicio = 2000.0;

  PagoController({
    required this.obtenerDireccionesUseCase,
    required this.agregarPedidoUseCase,
    required this.subtotalCarritoUseCase,
    required this.obtenerItemsCarritoUseCase,
    required this.vaciarCarritoUseCase,
  }) {
    print('PagoController: Constructor llamado');
  }

  @override
  void onInit() {
    super.onInit();
    print('PagoController: onInit llamado');
    // Inicializar el estado del carrito desde storage
    cargarDatosCarrito();

    // Suscribirse a los cambios del CarritoController para mantener sincronizado el estado
    try {
      final carritoCtrl = Get.find<CarritoController>();

      // Sync inicial con el estado actual de CarritoController
      _syncWithCarritoController(carritoCtrl);

      // Sync items y subtotal en tiempo real para cambios futuros
      ever<List<CarritoItem>>(carritoCtrl.items, (items) {
        itemsCarritoObs.value = items;
        carritoVacioObs.value = items.isEmpty;
        // No recalculamos aquí el subtotal con fold para evitar duplicar lógica
        subtotalObs.value = carritoCtrl.subtotal.value;
        print('PagoController: Sync con CarritoController -> items:${items.length}, subtotal:${subtotalObs.value}');
      });

      ever<double>(carritoCtrl.subtotal, (sub) {
        subtotalObs.value = sub;
        print('PagoController: Subtotal actualizado desde CarritoController -> $sub');
      });
    } catch (e) {
      // Si no existe aún el CarritoController, no es crítico; seguiremos con los casos de uso
      print('PagoController: No se pudo suscribir al CarritoController: $e');
    }
    cargarDirecciones();
  }

  // Método para sincronizar inicialmente con CarritoController
  void _syncWithCarritoController(CarritoController ctrl) {
    itemsCarritoObs.value = ctrl.items;
    carritoVacioObs.value = ctrl.items.isEmpty;
    subtotalObs.value = ctrl.subtotal.value;
    print('PagoController: Sync inicial con CarritoController -> items:${ctrl.items.length}, subtotal:${ctrl.subtotal.value}');
  }

  // Cargar datos del carrito
  Future<void> cargarDatosCarrito() async {
    try {
      // Cargar subtotal
      final subtotalResult = await subtotalCarritoUseCase.call(NoParams());
      subtotalResult.fold(
        (failure) => print('PagoController: Error cargando subtotal: $failure'),
        (subtotal) => subtotalObs.value = subtotal,
      );

      // Cargar items
      final itemsResult = await obtenerItemsCarritoUseCase.call(NoParams());
      itemsResult.fold(
        (failure) => print('PagoController: Error cargando items: $failure'),
        (items) {
          itemsCarritoObs.value = items;
          carritoVacioObs.value = items.isEmpty;
          print('PagoController: Items cargados: ${items.length}, carrito vacío: ${carritoVacioObs.value}');
        },
      );
  
      print('PagoController: Datos del carrito cargados');
    } catch (e) {
      print('PagoController: Error en cargarDatosCarrito: $e');
    }
  }

  // Cargar direcciones del usuario
  Future<void> cargarDirecciones() async {
    print('PagoController: cargarDirecciones iniciado');
    try {
      cargandoDirecciones.value = true;
      final userId = await SharedPreferencesUtils.getUserId();
      print('PagoController: userId obtenido: $userId');

      if (userId != null) {
        print('PagoController: Llamando obtenerDireccionesUseCase con userId: $userId');
        final result = await obtenerDireccionesUseCase.call(userId);
        result.fold(
          (failure) {
            print('PagoController: Error en obtenerDireccionesUseCase: $failure');
            direcciones.clear();
          },
          (direccionesData) {
            direcciones.value = direccionesData;
            print('PagoController: Direcciones obtenidas: ${direccionesData.length}');

            // Seleccionar la primera dirección por defecto si hay alguna
            if (direccionesData.isNotEmpty) {
              direccionSeleccionada.value = direccionesData.first.direccion;
            }
          },
        );
      } else {
        print('PagoController: No hay usuario autenticado');
        direcciones.clear();
      }
    } catch (e) {
      print('PagoController: Error en cargarDirecciones: $e');
      direcciones.clear();
    } finally {
      cargandoDirecciones.value = false;
      print('PagoController: cargarDirecciones finalizado, cargandoDirecciones: ${cargandoDirecciones.value}');
    }
  }

  // Seleccionar dirección
  void seleccionarDireccion(String? direccion) {
    direccionSeleccionada.value = direccion;
    print('PagoController: Dirección seleccionada: $direccion');
  }

  // Calcular subtotal del carrito
  double get subtotal => subtotalObs.value;

  // Calcular total
  double get total => subtotal + valorDomicilio + valorServicio;

  // Obtener items del carrito
  List<CarritoItem> get itemsCarrito => itemsCarritoObs;

  // Verificar si el carrito está vacío
  bool get carritoVacio {
    final vacio = itemsCarrito.isEmpty;
    carritoVacioObs.value = vacio;
    return vacio;
  }

  // Realizar pedido
  Future<bool> realizarPedido() async {
    // Validar dirección seleccionada
    if (direccionSeleccionada.value == null || direccionSeleccionada.value!.isEmpty) {
      print('PagoController: No hay dirección seleccionada');
      return false;
    }

    // Validar que el carrito no esté vacío
    if (carritoVacio) {
      print('PagoController: El carrito está vacío');
      return false;
    }

    isLoading.value = true;

    try {
      // Obtener el ID del usuario actual
      final String? userId = await SharedPreferencesUtils.getUserId();

      if (userId == null) {
        throw Exception('No hay usuario autenticado');
      }

      // Convertir items del carrito a ProductoPedido
      final List<ProductoPedido> listaProductos = itemsCarrito.map((item) {
        return ProductoPedido(
          idProducto: item.idProducto,
          cantidad: item.cantidad,
        );
      }).toList();

      // Crear el pedido
      final pedido = Pedido(
        id: '', // Se asignará por Firebase
        costoTotal: total,
        direccion: direccionSeleccionada.value!,
        estado: 'En Proceso',
        fecha: DateTime.now(),
        idRepartidor: '', // Se asignará después
        idUsuario: userId,
        listaProductos: listaProductos,
      );

      // Guardar el pedido usando el caso de uso
      final result = await agregarPedidoUseCase.call(pedido);
      late String pedidoId;

      result.fold(
        (failure) {
          throw Exception('Error al guardar pedido: $failure');
        },
        (id) {
          pedidoId = id;
        },
      );

      print('PagoController: ✅ Pedido creado con ID: $pedidoId');

      // Vaciar el carrito después de crear el pedido
      final vaciarResult = await vaciarCarritoUseCase.call(NoParams());
      vaciarResult.fold(
        (failure) => print('PagoController: Error vaciando carrito: $failure'),
        (_) {
          carritoVacioObs.value = true;
          itemsCarritoObs.clear();
          subtotalObs.value = 0.0;
        },
      );

      isLoading.value = false;
      return true;

    } catch (e) {
      print('PagoController: ❌ Error al realizar pedido: $e');
      isLoading.value = false;
      return false;
    }
  }

  // Limpiar datos
  void limpiarDatos() {
    direcciones.clear();
    direccionSeleccionada.value = null;
    isLoading.value = false;
    cargandoDirecciones.value = false;
  }

  // Método para debug cuando se abre PagoScreen
  void debugPagoScreen() {
    print('PagoController: PagoScreen abierta - carritoVacioObs: ${carritoVacioObs.value}, items: ${itemsCarritoObs.length}, subtotal: ${subtotalObs.value}');
  }
}
