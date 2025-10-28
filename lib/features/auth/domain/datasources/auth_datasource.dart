import 'package:mi_mercado/features/auth/domain/entities/Repartidor.dart';
import 'package:mi_mercado/features/auth/domain/entities/Usuario.dart';

abstract class AuthDataSource {
  Future<Usuario?> obtenerUsuarioPorEmail(String email);
  Future<Repartidor?> obtenerRepartidorPorEmail(String email);
  Future<void> registrarUsuario(Usuario usuario);
  Future<bool> emailExiste(String email, String rol);
  Future<bool> telefonoExiste(String telefono, String rol);
}
