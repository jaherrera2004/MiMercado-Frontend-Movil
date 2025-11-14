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
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import 'package:mi_mercado/features/auth/data/datasources/auth_datasource_impl.dart';
import 'package:mi_mercado/features/auth/data/repositories/auth_repositories_impl.dart';
import 'package:mi_mercado/features/auth/domain/repositories/auth_repository.dart';
import 'package:mi_mercado/features/auth/domain/useCases/login.dart';
import 'package:mi_mercado/features/auth/domain/useCases/registrar_usuario.dart';
import 'package:mi_mercado/features/auth/presentation/controllers/login_controller.dart';
import 'package:mi_mercado/features/auth/presentation/controllers/registrar_usuario_controller.dart';
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
import 'package:mi_mercado/features/usuario/productos/presentation/controllers/productos_filtrados_controller.dart';

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

/// Configuración de inyección de dependencias usando solo GetX
/// Todas las dependencias se registran usando Get.put() y Get.lazyPut()
void setupDependencies() {
  // ===== DATA SOURCES (Singleton - una instancia compartida) =====
  Get.put(CarritoDataSourceImpl(), permanent: true);
  Get.put(AuthDataSourceImpl(FirebaseFirestore.instance), permanent: true);
  Get.put(ProductoDataSourceImpl(FirebaseFirestore.instance), permanent: true);
  Get.put(CategoriaDataSourceImpl(FirebaseFirestore.instance), permanent: true);
  Get.put(DireccionDataSourceImpl(FirebaseFirestore.instance), permanent: true);
  Get.put(PedidoDataSourceImpl(FirebaseFirestore.instance), permanent: true);
  Get.put(UsuarioDataSourceImpl(FirebaseFirestore.instance), permanent: true);
  Get.put(RepartidorDataSourceImpl(FirebaseFirestore.instance), permanent: true);

  // ===== REPOSITORIES (Singleton - implementan interfaces) =====
  Get.put<CarritoRepository>(CarritoRepositoryImpl(Get.find<CarritoDataSourceImpl>()), permanent: true);
  Get.put<AuthRepository>(AuthRepositoryImpl(Get.find<AuthDataSourceImpl>()), permanent: true);
  Get.put<ProductoRepository>(ProductoRepositoryImpl(Get.find<ProductoDataSourceImpl>()), permanent: true);
  Get.put<CategoriaRepository>(CategoriaRepositoryImpl(Get.find<CategoriaDataSourceImpl>()), permanent: true);
  Get.put<DireccionRepository>(DireccionRepositoryImpl(Get.find<DireccionDataSourceImpl>()), permanent: true);
  Get.put<PedidoRepository>(PedidoRepositoryImpl(Get.find<PedidoDataSourceImpl>()), permanent: true);
  Get.put<UsuarioRepository>(UsuarioRepositoryImpl(Get.find<UsuarioDataSourceImpl>()), permanent: true);
  Get.put<RepartidorRepository>(RepartidorRepositoryImpl(Get.find<RepartidorDataSourceImpl>()), permanent: true);

  // ===== USE CASES (Factory - nueva instancia cada vez) =====
  // Carrito
  Get.lazyPut(() => AgregarProductoCarritoUseCase(Get.find<CarritoRepository>()));
  Get.lazyPut(() => ObtenerItemsCarritoUseCase(Get.find<CarritoRepository>()));
  Get.lazyPut(() => IncrementarCantidadCarritoUseCase(Get.find<CarritoRepository>()));
  Get.lazyPut(() => DecrementarCantidadCarritoUseCase(Get.find<CarritoRepository>()));
  Get.lazyPut(() => EliminarProductoCarritoUseCase(Get.find<CarritoRepository>()));
  Get.lazyPut(() => VaciarCarritoUseCase(Get.find<CarritoRepository>()));
  Get.lazyPut(() => SubtotalCarritoUseCase(Get.find<CarritoRepository>()));

  // Auth
  Get.lazyPut(() => RegistrarUsuario(Get.find<AuthRepository>()));
  Get.lazyPut(() => Login(Get.find<AuthRepository>()));

  // Productos
  Get.lazyPut(() => ObtenerProductos(Get.find<ProductoRepository>()));
  Get.lazyPut(() => ObtenerProductosPorCategoria(Get.find<ProductoRepository>()));
  Get.lazyPut(() => ObtenerProductosPedido(Get.find<ProductoRepository>()));

  // Categorias
  Get.lazyPut(() => ObtenerCategorias(Get.find<CategoriaRepository>()));

  // Direcciones
  Get.lazyPut(() => AgregarDireccionUseCase(Get.find<DireccionRepository>()));
  Get.lazyPut(() => ObtenerDireccionesUseCase(Get.find<DireccionRepository>()));
  Get.lazyPut(() => EditarDireccionUseCase(Get.find<DireccionRepository>()));
  Get.lazyPut(() => EliminarDireccionUseCase(Get.find<DireccionRepository>()));

  // Pedidos
  Get.lazyPut(() => AgregarPedidoUseCase(Get.find<PedidoRepository>()));
  Get.lazyPut(() => ObtenerPedidosUseCase(Get.find<PedidoRepository>()));
  Get.lazyPut(() => ObtenerPedidoPorIdUseCase(Get.find<PedidoRepository>()));
  Get.lazyPut(() => ObtenerPedidoActualRepartidorUseCase(Get.find<PedidoRepository>()));
  Get.lazyPut(() => ObtenerPedidosDisponiblesUseCase(Get.find<PedidoRepository>()));
  Get.lazyPut(() => ObtenerHistorialPedidosUseCase(Get.find<PedidoRepository>()));
  Get.lazyPut(() => ActualizarEstadoPedidoUseCase(Get.find<PedidoRepository>()));
  Get.lazyPut(() => TomarPedidoUseCase(Get.find<PedidoRepository>()));

  // Cuenta
  Get.lazyPut(() => ObtenerUsuarioPorIdUseCase(Get.find<UsuarioRepository>()));
  Get.lazyPut(() => EditarUsuarioUseCase(Get.find<UsuarioRepository>()));
  Get.lazyPut(() => EditarContrasenaUseCase(Get.find<UsuarioRepository>()));

  // Repartidor
  Get.put(ObtenerDatosRepartidorUseCase(Get.find<RepartidorRepository>()), permanent: true);

  // ===== CONTROLLERS =====
  // Controllers que necesitan existir toda la vida de la app
  Get.put(CarritoController(
    agregarProductoUseCase: Get.find<AgregarProductoCarritoUseCase>(),
    obtenerItemsUseCase: Get.find<ObtenerItemsCarritoUseCase>(),
    incrementarCantidadUseCase: Get.find<IncrementarCantidadCarritoUseCase>(),
    decrementarCantidadUseCase: Get.find<DecrementarCantidadCarritoUseCase>(),
    eliminarProductoUseCase: Get.find<EliminarProductoCarritoUseCase>(),
    vaciarCarritoUseCase: Get.find<VaciarCarritoUseCase>(),
    subtotalUseCase: Get.find<SubtotalCarritoUseCase>(),
  ), permanent: true);

  Get.put(DireccionController(
    agregarDireccionUseCase: Get.find<AgregarDireccionUseCase>(),
    obtenerDireccionesUseCase: Get.find<ObtenerDireccionesUseCase>(),
    editarDireccionUseCase: Get.find<EditarDireccionUseCase>(),
    eliminarDireccionUseCase: Get.find<EliminarDireccionUseCase>(),
  ), permanent: true);

  Get.put(PedidosController(
    obtenerPedidosUseCase: Get.find<ObtenerPedidosUseCase>(),
  ), permanent: true);

  Get.put(PedidoDetalleController(
    obtenerPedidoPorIdUseCase: Get.find<ObtenerPedidoPorIdUseCase>(),
    obtenerProductosPedido: Get.find<ObtenerProductosPedido>(),
  ), permanent: true);

  Get.put(PedidosDisponiblesController(
    obtenerPedidosDisponiblesUseCase: Get.find<ObtenerPedidosDisponiblesUseCase>(),
    tomarPedidoUseCase: Get.find<TomarPedidoUseCase>(),
  ), permanent: true);

  // Controllers perezosos (se crean cuando se necesitan)
  Get.lazyPut(() => HomePageController(
    obtenerCategorias: Get.find<ObtenerCategorias>(),
    obtenerProductos: Get.find<ObtenerProductos>(),
  ), fenix: true);

  Get.lazyPut(() => ProductosFiltradosController(
    obtenerProductosPorCategoria: Get.find<ObtenerProductosPorCategoria>(),
  ), fenix: true);

  Get.lazyPut(() => LoginController(), fenix: true);
  Get.lazyPut(() => RegistrarUsuarioController(), fenix: true);

  Get.lazyPut(() => PagoController(
    obtenerDireccionesUseCase: Get.find<ObtenerDireccionesUseCase>(),
    agregarPedidoUseCase: Get.find<AgregarPedidoUseCase>(),
    subtotalCarritoUseCase: Get.find<SubtotalCarritoUseCase>(),
    obtenerItemsCarritoUseCase: Get.find<ObtenerItemsCarritoUseCase>(),
    vaciarCarritoUseCase: Get.find<VaciarCarritoUseCase>(),
  ), fenix: true);

  Get.lazyPut(() => MiCuentaController(
    obtenerUsuarioPorId: Get.find<ObtenerUsuarioPorIdUseCase>(),
    editarUsuario: Get.find<EditarUsuarioUseCase>(),
    editarContrasena: Get.find<EditarContrasenaUseCase>(),
  ), fenix: true);

  Get.lazyPut(() => DatosPerfilController(
    obtenerUsuarioPorId: Get.find<ObtenerUsuarioPorIdUseCase>(),
    editarUsuario: Get.find<EditarUsuarioUseCase>(),
  ), fenix: true);

  Get.lazyPut(() => EditarContrasenaController(
    editarContrasena: Get.find<EditarContrasenaUseCase>(),
  ), fenix: true);

  Get.lazyPut(() => SeguridadController(
    editarContrasena: Get.find<EditarContrasenaUseCase>(),
  ), fenix: true);

  Get.lazyPut(() => RepartidorHomeController(
    obtenerPedidoActualUseCase: Get.find<ObtenerPedidoActualRepartidorUseCase>(),
  ), fenix: true);

  Get.lazyPut(() => DatosRepartidorController(
    obtenerDatosRepartidorUseCase: Get.find<ObtenerDatosRepartidorUseCase>(),
  ), fenix: true);

  Get.lazyPut(() => PedidoActualController(
    obtenerPedidoActualUseCase: Get.find<ObtenerPedidoActualRepartidorUseCase>(),
    obtenerUsuarioPorIdUseCase: Get.find<ObtenerUsuarioPorIdUseCase>(),
    actualizarEstadoPedidoUseCase: Get.find<ActualizarEstadoPedidoUseCase>(),
  ), fenix: true);

  Get.lazyPut(() => ProductosPedidoController(
    obtenerProductosPedido: Get.find<ObtenerProductosPedido>(),
  ), fenix: true);

  Get.lazyPut(() => HistorialPedidosController(
    obtenerHistorialPedidosUseCase: Get.find<ObtenerHistorialPedidosUseCase>(),
  ), fenix: true);
}