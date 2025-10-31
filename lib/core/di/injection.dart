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

import 'package:mi_mercado/features/auth/data/datasources/auth_datasource_impl.dart';
import 'package:mi_mercado/features/auth/data/repositories/auth_repositories_impl.dart';
import 'package:mi_mercado/features/auth/domain/repositories/auth_repository.dart';
import 'package:mi_mercado/features/auth/domain/useCases/registrar_usuario.dart';
import 'package:mi_mercado/features/usuario/productos/data/datasources/producto_datasource_impl.dart';
import 'package:mi_mercado/features/usuario/productos/data/repositories/producto_repository_impl.dart';
import 'package:mi_mercado/features/usuario/productos/domain/repositories/producto_repository.dart';
import 'package:mi_mercado/features/usuario/productos/domain/useCases/obtener_productos.dart';
import 'package:mi_mercado/features/usuario/productos/domain/useCases/obtener_productos_por_categoria.dart';
import 'package:mi_mercado/features/usuario/productos/data/datasources/categoria_datasource_impl.dart';
import 'package:mi_mercado/features/usuario/productos/data/repositories/categoria_repository_impl.dart';
import 'package:mi_mercado/features/usuario/productos/domain/repositories/categoria_repository.dart';
import 'package:mi_mercado/features/usuario/productos/domain/useCases/obtener_categorias.dart';
import 'package:mi_mercado/features/usuario/productos/presentation/controllers/homepage_controller.dart';

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

  // Productos
  getIt.registerLazySingleton(() => ProductoDataSourceImpl(FirebaseFirestore.instance));
  getIt.registerLazySingleton<ProductoRepository>(() => ProductoRepositoryImpl(getIt<ProductoDataSourceImpl>()));
  getIt.registerFactory(() => ObtenerProductos(getIt<ProductoRepository>()));
  getIt.registerFactory(() => ObtenerProductosPorCategoria(getIt<ProductoRepository>()));

  // Categorias
  getIt.registerLazySingleton(() => CategoriaDataSourceImpl(FirebaseFirestore.instance));
  getIt.registerLazySingleton<CategoriaRepository>(() => CategoriaRepositoryImpl(getIt<CategoriaDataSourceImpl>()));
  getIt.registerFactory(() => ObtenerCategorias(getIt<CategoriaRepository>()));

  // Controller
  getIt.registerFactory<HomePageController>(() => HomePageController(
    obtenerCategorias: getIt<ObtenerCategorias>(),
    obtenerProductos: getIt<ObtenerProductos>(),
  ));
}
