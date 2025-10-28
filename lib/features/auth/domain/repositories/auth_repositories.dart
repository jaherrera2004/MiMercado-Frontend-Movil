import 'package:mi_mercado/features/auth/domain/entities/Repartidor.dart';
import 'package:mi_mercado/features/auth/domain/entities/Usuario.dart';

abstract class AuthRepository {
  Future<Usuario?> obtenerUsuarioPorEmail(String email);
  Future<Repartidor?> obtenerRepartidorPorEmail(String email);
  Future<void> registrarUsuario(Usuario usuario);
}
