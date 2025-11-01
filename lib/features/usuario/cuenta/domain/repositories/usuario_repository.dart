import 'package:mi_mercado/features/auth/domain/entities/Usuario.dart';

abstract class UsuarioRepository {
  Future<Usuario?> obtenerUsuarioPorId(String id);
  Future<void> editarUsuario(Usuario usuario);
  Future<void> editarContrasena(String idUsuario, String nuevaContrasena);
}