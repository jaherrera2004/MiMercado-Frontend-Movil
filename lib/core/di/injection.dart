import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:mi_mercado/features/auth/data/datasources/auth_datasource_impl.dart';
import 'package:mi_mercado/features/auth/data/repositories/auth_repositories_impl.dart';
import 'package:mi_mercado/features/auth/domain/repositories/auth_repository.dart';
import 'package:mi_mercado/features/auth/domain/useCases/registrar_usuario.dart';

final GetIt getIt = GetIt.instance;

void setupLocator() {
  // Data sources
  getIt.registerLazySingleton(() => AuthDataSourceImpl(FirebaseFirestore.instance));

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(getIt<AuthDataSourceImpl>()));

  // Use cases
  getIt.registerFactory(() => RegistrarUsuario(getIt<AuthRepository>()));
}
