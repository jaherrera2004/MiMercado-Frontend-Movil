import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:mi_mercado/features/auth/data/datasources/auth_datasource_impl.dart';
import 'package:mi_mercado/features/auth/data/repositories/auth_repositories_impl.dart';
import 'package:mi_mercado/features/auth/domain/repositories/auth_repository.dart';
import 'package:mi_mercado/features/auth/domain/useCases/registrar_usuario.dart';
import 'package:mi_mercado/features/usuario/home/data/datasources/producto_datasource_impl.dart';
import 'package:mi_mercado/features/usuario/home/data/repositories/producto_repository_impl.dart';
import 'package:mi_mercado/features/usuario/home/domain/repositories/producto_repository.dart';
import 'package:mi_mercado/features/usuario/home/domain/useCases/obtener_productos.dart';
import 'package:mi_mercado/features/usuario/home/data/datasources/categoria_datasoruce_impl.dart';
import 'package:mi_mercado/features/usuario/home/data/repositories/categoria_repository_impl.dart';
import 'package:mi_mercado/features/usuario/home/domain/repositories/categoria_repository.dart';
import 'package:mi_mercado/features/usuario/home/domain/useCases/obtener_categorias.dart';
import 'package:mi_mercado/features/usuario/home/presentation/controllers/homepage_controller.dart';

final GetIt getIt = GetIt.instance;

void setupLocator() {
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
