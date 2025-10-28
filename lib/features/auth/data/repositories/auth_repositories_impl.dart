import 'package:mi_mercado/features/auth/domain/entities/Repartidor.dart';
import 'package:mi_mercado/features/auth/domain/entities/Usuario.dart';
import 'package:mi_mercado/features/auth/domain/datasources/auth_datasource.dart';
import 'package:mi_mercado/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource _authDataSource;

  AuthRepositoryImpl(this._authDataSource);

  @override
  Future<Usuario?> obtenerUsuarioPorEmail(String email) {
    return _authDataSource.obtenerUsuarioPorEmail(email);
  }

  @override
  Future<Repartidor?> obtenerRepartidorPorEmail(String email) {
    return _authDataSource.obtenerRepartidorPorEmail(email);
  }

  @override
  Future<void> registrarUsuario(Usuario usuario) {
    return _authDataSource.registrarUsuario(usuario);
  }
  
  @override
  Future<bool> emailExiste(String email, String rol) {
    return _authDataSource.emailExiste(email, rol);
  }
  
  @override
  Future<bool> telefonoExiste(String telefono, String rol) {
    return _authDataSource.telefonoExiste(telefono, rol);
  }
}