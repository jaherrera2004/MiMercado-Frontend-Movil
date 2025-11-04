import 'package:mi_mercado/features/repartidor/pedidos/presentation/controllers/pedido_actual_controller.dart';
import 'package:mi_mercado/features/repartidor/pedidos/presentation/controllers/productos_pedido_controller.dart';
import 'package:mi_mercado/features/usuario/productos/data/datasources/carrito_datasource_impl.dart';
import 'package:mi_mercado/features/usuario/productos/data/repositories/carrito_repository_impl.dart';
import 'package:mi_mercado/features/usuario/productos/domain/repositories/carrito_repository.dart';
import 'package:mi_mercado/features/usuario/productos/domain/useCases/agregar_producto_carrito.dart';
import 'package:mi_mercado/features/usuario/productos/domain/useCases/obtener_items_carrito.dart';
import 'package:mi_mercado/features/usuario/productos/domain/useCases/incrementar_cantidad.dart';
import 'package:mi_mercado/features/usuario/productos/domain/useCases/decrementar_cantidad.dart';
import 'package:mi_mercado/features/usuario/productos/domain/useCases/eliminar_producto_carrito.dart';
import 'package:mi_mercado/features/usuario/productos/domain/useCases/vaciar_carrito.dart';
import 'package:mi_mercado/features/usuario/productos/domain/useCases/calcular_subtotal.dart';
import 'package:mi_mercado/features/usuario/productos/presentation/controllers/carrito_controller.dart';
import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import 'package:mi_mercado/features/auth/data/datasources/auth_datasource_impl.dart';
import 'package:mi_mercado/features/auth/data/repositories/auth_repositories_impl.dart';
import 'package:mi_mercado/features/auth/domain/repositories/auth_repository.dart';
import 'package:mi_mercado/features/auth/domain/useCases/login.dart';
import 'package:mi_mercado/features/auth/domain/useCases/registrar_usuario.dart';
import 'package:mi_mercado/features/usuario/productos/data/datasources/producto_datasource_impl.dart';
import 'package:mi_mercado/features/usuario/productos/data/repositories/producto_repository_impl.dart';
import 'package:mi_mercado/features/usuario/productos/domain/repositories/producto_repository.dart';
import 'package:mi_mercado/features/usuario/productos/domain/useCases/obtener_productos.dart';
import 'package:mi_mercado/features/usuario/productos/domain/useCases/obtener_productos_por_categoria.dart';
import 'package:mi_mercado/features/usuario/productos/domain/useCases/obtener_productos_pedido.dart';
import 'package:mi_mercado/features/usuario/productos/data/datasources/categoria_datasource_impl.dart';
import 'package:mi_mercado/features/usuario/productos/data/repositories/categoria_repository_impl.dart';
import 'package:mi_mercado/features/usuario/productos/domain/repositories/categoria_repository.dart';
import 'package:mi_mercado/features/usuario/productos/domain/useCases/obtener_categorias.dart';
import 'package:mi_mercado/features/usuario/productos/presentation/controllers/homepage_controller.dart';

// Direcciones
import 'package:mi_mercado/features/usuario/direcciones/data/datasources/direccion_datasource_impl.dart';
import 'package:mi_mercado/features/usuario/direcciones/data/repositories/direccion_repository_impl.dart';
import 'package:mi_mercado/features/usuario/direcciones/domain/repositories/direccion_repository.dart';
import 'package:mi_mercado/features/usuario/direcciones/domain/useCases/agregar_direccion.dart';
import 'package:mi_mercado/features/usuario/direcciones/domain/useCases/obtener_direcciones.dart';
import 'package:mi_mercado/features/usuario/direcciones/domain/useCases/editar_direccion.dart';
import 'package:mi_mercado/features/usuario/direcciones/domain/useCases/eliminar_direccion.dart';
import 'package:mi_mercado/features/usuario/direcciones/presentation/controllers/direccion_controller.dart';

// Pedidos
import 'package:mi_mercado/features/pedidos/data/datasources/pedido_datasource_impl.dart';
import 'package:mi_mercado/features/pedidos/data/repositories/pedido_repository_impl.dart';
import 'package:mi_mercado/features/pedidos/domain/repositories/pedido_repository.dart';
import 'package:mi_mercado/features/pedidos/domain/useCases/agregar_pedido.dart';
import 'package:mi_mercado/features/pedidos/domain/useCases/obtener_pedidos.dart';
import 'package:mi_mercado/features/pedidos/domain/useCases/obtener_pedido_por_id.dart';
import 'package:mi_mercado/features/pedidos/domain/useCases/obtener_pedido_actual_repartidor.dart';
import 'package:mi_mercado/features/pedidos/domain/useCases/obtener_pedidos_disponibles.dart';
import 'package:mi_mercado/features/pedidos/domain/useCases/obtener_historial_pedidos.dart';
import 'package:mi_mercado/features/pedidos/domain/useCases/actualizar_estado_pedido.dart';
import 'package:mi_mercado/features/pedidos/domain/useCases/tomar_pedido.dart';
import 'package:mi_mercado/features/pedidos/presentation/controllers/pedidos_controller.dart';
import 'package:mi_mercado/features/pedidos/presentation/controllers/pedido_detalle_controller.dart';
import 'package:mi_mercado/features/repartidor/pedidos/presentation/controllers/pedidos_disponibles_controller.dart';
import 'package:mi_mercado/features/repartidor/pedidos/presentation/controllers/historial_pedidos_controller.dart';

// Cuenta
import 'package:mi_mercado/features/usuario/cuenta/data/datasources/usuario_datasource_impl.dart';
import 'package:mi_mercado/features/usuario/cuenta/data/repositories/usuario_repository_impl.dart';
import 'package:mi_mercado/features/usuario/cuenta/domain/repositories/usuario_repository.dart';
import 'package:mi_mercado/features/usuario/cuenta/domain/useCases/obtener_usuario_por_id.dart';
import 'package:mi_mercado/features/usuario/cuenta/domain/useCases/editar_usuario.dart';
import 'package:mi_mercado/features/usuario/cuenta/domain/useCases/editar_contrasena.dart';
import 'package:mi_mercado/features/usuario/cuenta/presentation/controllers/mi_cuenta_controller.dart';
import 'package:mi_mercado/features/usuario/cuenta/presentation/controllers/datos_perfil_controller.dart';
import 'package:mi_mercado/features/usuario/cuenta/presentation/controllers/editar_contrasena_controller.dart';
import 'package:mi_mercado/features/usuario/cuenta/presentation/controllers/seguridad_controller.dart';
import 'package:mi_mercado/features/usuario/pago/presentation/controllers/pago_controller.dart';

// Repartidor
import 'package:mi_mercado/features/repartidor/home/presentation/controllers/repartidor_home_controller.dart';
import 'package:mi_mercado/features/repartidor/datos/data/datasources/repartidor_datasource_impl.dart';
import 'package:mi_mercado/features/repartidor/datos/data/repositories/repartidor_repository_impl.dart';
import 'package:mi_mercado/features/repartidor/datos/domain/repositories/repartidor_repository.dart';
import 'package:mi_mercado/features/repartidor/datos/domain/useCases/obtener_datos_repartidor.dart';
import 'package:mi_mercado/features/repartidor/datos/presentation/controllers/datos_repartidor_controller.dart';

final GetIt getIt = GetIt.instance;

void setupLocator() {
  // Carrito
  getIt.registerLazySingleton(() => CarritoDataSourceImpl());
  getIt.registerLazySingleton<CarritoRepository>(() => CarritoRepositoryImpl(getIt<CarritoDataSourceImpl>()));
  getIt.registerFactory(() => AgregarProductoCarritoUseCase(getIt<CarritoRepository>()));
  getIt.registerFactory(() => ObtenerItemsCarritoUseCase(getIt<CarritoRepository>()));
  getIt.registerFactory(() => IncrementarCantidadCarritoUseCase(getIt<CarritoRepository>()));
  getIt.registerFactory(() => DecrementarCantidadCarritoUseCase(getIt<CarritoRepository>()));
  getIt.registerFactory(() => EliminarProductoCarritoUseCase(getIt<CarritoRepository>()));
  getIt.registerFactory(() => VaciarCarritoUseCase(getIt<CarritoRepository>()));
  getIt.registerFactory(() => SubtotalCarritoUseCase(getIt<CarritoRepository>()));
  getIt.registerFactory<CarritoController>(() => CarritoController(
    agregarProductoUseCase: getIt<AgregarProductoCarritoUseCase>(),
    obtenerItemsUseCase: getIt<ObtenerItemsCarritoUseCase>(),
    incrementarCantidadUseCase: getIt<IncrementarCantidadCarritoUseCase>(),
    decrementarCantidadUseCase: getIt<DecrementarCantidadCarritoUseCase>(),
    eliminarProductoUseCase: getIt<EliminarProductoCarritoUseCase>(),
    vaciarCarritoUseCase: getIt<VaciarCarritoUseCase>(),
    subtotalUseCase: getIt<SubtotalCarritoUseCase>(),
  ));
  // Data sources
  getIt.registerLazySingleton(() => AuthDataSourceImpl(FirebaseFirestore.instance));

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(getIt<AuthDataSourceImpl>()));

  // Use cases
  getIt.registerFactory(() => RegistrarUsuario(getIt<AuthRepository>()));
  getIt.registerFactory(() => Login(getIt<AuthRepository>()));

  // Productos
  getIt.registerLazySingleton(() => ProductoDataSourceImpl(FirebaseFirestore.instance));
  getIt.registerLazySingleton<ProductoRepository>(() => ProductoRepositoryImpl(getIt<ProductoDataSourceImpl>()));
  getIt.registerFactory(() => ObtenerProductos(getIt<ProductoRepository>()));
  getIt.registerFactory(() => ObtenerProductosPorCategoria(getIt<ProductoRepository>()));
  getIt.registerFactory(() => ObtenerProductosPedido(getIt<ProductoRepository>()));

  // Categorias
  getIt.registerLazySingleton(() => CategoriaDataSourceImpl(FirebaseFirestore.instance));
  getIt.registerLazySingleton<CategoriaRepository>(() => CategoriaRepositoryImpl(getIt<CategoriaDataSourceImpl>()));
  getIt.registerFactory(() => ObtenerCategorias(getIt<CategoriaRepository>()));

  // Controller
  getIt.registerFactory<HomePageController>(() => HomePageController(
    obtenerCategorias: getIt<ObtenerCategorias>(),
    obtenerProductos: getIt<ObtenerProductos>(),
  ));

  // Direcciones
  getIt.registerLazySingleton(() => DireccionDataSourceImpl(FirebaseFirestore.instance));
  getIt.registerLazySingleton<DireccionRepository>(() => DireccionRepositoryImpl(getIt<DireccionDataSourceImpl>()));
  getIt.registerFactory(() => AgregarDireccionUseCase(getIt<DireccionRepository>()));
  getIt.registerFactory(() => ObtenerDireccionesUseCase(getIt<DireccionRepository>()));
  getIt.registerFactory(() => EditarDireccionUseCase(getIt<DireccionRepository>()));
  getIt.registerFactory(() => EliminarDireccionUseCase(getIt<DireccionRepository>()));
  getIt.registerFactory<DireccionController>(() => DireccionController(
    agregarDireccionUseCase: getIt<AgregarDireccionUseCase>(),
    obtenerDireccionesUseCase: getIt<ObtenerDireccionesUseCase>(),
    editarDireccionUseCase: getIt<EditarDireccionUseCase>(),
    eliminarDireccionUseCase: getIt<EliminarDireccionUseCase>(),
  ));

  // Pedidos
  getIt.registerLazySingleton(() => PedidoDataSourceImpl(FirebaseFirestore.instance));
  getIt.registerLazySingleton<PedidoRepository>(() => PedidoRepositoryImpl(getIt<PedidoDataSourceImpl>()));
  getIt.registerFactory(() => AgregarPedidoUseCase(getIt<PedidoRepository>()));
  getIt.registerFactory(() => ObtenerPedidosUseCase(getIt<PedidoRepository>()));
  getIt.registerFactory(() => ObtenerPedidoPorIdUseCase(getIt<PedidoRepository>()));
  getIt.registerFactory(() => ObtenerPedidoActualRepartidorUseCase(getIt<PedidoRepository>()));
  getIt.registerFactory(() => ObtenerPedidosDisponiblesUseCase(getIt<PedidoRepository>()));
  getIt.registerFactory(() => ObtenerHistorialPedidosUseCase(getIt<PedidoRepository>()));
  getIt.registerFactory(() => ActualizarEstadoPedidoUseCase(getIt<PedidoRepository>()));
  getIt.registerFactory(() => TomarPedidoUseCase(getIt<PedidoRepository>()));
  getIt.registerFactory<PedidosController>(() => PedidosController(
    obtenerPedidosUseCase: getIt<ObtenerPedidosUseCase>(),
  ));
  getIt.registerFactory<PedidoDetalleController>(() => PedidoDetalleController(
    obtenerPedidoPorIdUseCase: getIt<ObtenerPedidoPorIdUseCase>(),
    obtenerProductosPedido: getIt<ObtenerProductosPedido>(),
  ));
  getIt.registerFactory<PedidosDisponiblesController>(() => PedidosDisponiblesController(
    obtenerPedidosDisponiblesUseCase: getIt<ObtenerPedidosDisponiblesUseCase>(),
    tomarPedidoUseCase: getIt<TomarPedidoUseCase>(),
  ));
 

  // Cuenta
  getIt.registerLazySingleton(() => UsuarioDataSourceImpl(FirebaseFirestore.instance));
  getIt.registerLazySingleton<UsuarioRepository>(() => UsuarioRepositoryImpl(getIt<UsuarioDataSourceImpl>()));
  getIt.registerFactory<ObtenerUsuarioPorIdUseCase>(() => ObtenerUsuarioPorIdUseCase(getIt<UsuarioRepository>()));
  getIt.registerFactory<EditarUsuarioUseCase>(() => EditarUsuarioUseCase(getIt<UsuarioRepository>()));
  getIt.registerFactory<EditarContrasenaUseCase>(() => EditarContrasenaUseCase(getIt<UsuarioRepository>()));
  getIt.registerFactory<MiCuentaController>(() => MiCuentaController(
    obtenerUsuarioPorId: getIt<ObtenerUsuarioPorIdUseCase>(),
    editarUsuario: getIt<EditarUsuarioUseCase>(),
    editarContrasena: getIt<EditarContrasenaUseCase>(),
  ));
  getIt.registerFactory<DatosPerfilController>(() => DatosPerfilController(
    obtenerUsuarioPorId: getIt<ObtenerUsuarioPorIdUseCase>(),
    editarUsuario: getIt<EditarUsuarioUseCase>(),
  ));
  getIt.registerFactory<EditarContrasenaController>(() => EditarContrasenaController(
    editarContrasena: getIt<EditarContrasenaUseCase>(),
  ));
  getIt.registerFactory<SeguridadController>(() => SeguridadController(
    editarContrasena: getIt<EditarContrasenaUseCase>(),
  ));

  // Pago
  getIt.registerFactory<PagoController>(() => PagoController(
    obtenerDireccionesUseCase: getIt<ObtenerDireccionesUseCase>(),
    agregarPedidoUseCase: getIt<AgregarPedidoUseCase>(),
    subtotalCarritoUseCase: getIt<SubtotalCarritoUseCase>(),
    obtenerItemsCarritoUseCase: getIt<ObtenerItemsCarritoUseCase>(),
    vaciarCarritoUseCase: getIt<VaciarCarritoUseCase>(),
  ));

  // Registro de usecases de cuenta en GetX para widgets que usan Get.find
  Get.lazyPut<ObtenerUsuarioPorIdUseCase>(() => getIt<ObtenerUsuarioPorIdUseCase>());
  Get.lazyPut<EditarUsuarioUseCase>(() => getIt<EditarUsuarioUseCase>());
  Get.lazyPut<EditarContrasenaUseCase>(() => getIt<EditarContrasenaUseCase>());

  // Repartidor
  getIt.registerLazySingleton(() => RepartidorDataSourceImpl(FirebaseFirestore.instance));
  getIt.registerLazySingleton<RepartidorRepository>(() => RepartidorRepositoryImpl(getIt<RepartidorDataSourceImpl>()));
  getIt.registerFactory(() => ObtenerDatosRepartidorUseCase(getIt<RepartidorRepository>()));
  getIt.registerFactory<RepartidorHomeController>(() => RepartidorHomeController(
    obtenerPedidoActualUseCase: getIt<ObtenerPedidoActualRepartidorUseCase>(),
  ));
  getIt.registerFactory<DatosRepartidorController>(() => DatosRepartidorController(
    obtenerDatosRepartidorUseCase: getIt<ObtenerDatosRepartidorUseCase>(),
  ));
  getIt.registerFactory<PedidoActualController>(() => PedidoActualController(
    obtenerPedidoActualUseCase: getIt<ObtenerPedidoActualRepartidorUseCase>(),
    obtenerUsuarioPorIdUseCase: getIt<ObtenerUsuarioPorIdUseCase>(),
    actualizarEstadoPedidoUseCase: getIt<ActualizarEstadoPedidoUseCase>(),
  ));
  getIt.registerFactory<ProductosPedidoController>(() => ProductosPedidoController(
    obtenerProductosPedido: getIt<ObtenerProductosPedido>(),
  ));
  getIt.registerFactory<HistorialPedidosController>(() => HistorialPedidosController(
    obtenerHistorialPedidosUseCase: getIt<ObtenerHistorialPedidosUseCase>(),
  ));

  // Registro en GetX para widgets que usan GetView
  Get.lazyPut<RepartidorHomeController>(() => getIt<RepartidorHomeController>());
  Get.lazyPut<PedidoActualController>(() => getIt<PedidoActualController>());
  Get.lazyPut<ProductosPedidoController>(() => getIt<ProductosPedidoController>());
  Get.lazyPut<HistorialPedidosController>(() => getIt<HistorialPedidosController>());
}
