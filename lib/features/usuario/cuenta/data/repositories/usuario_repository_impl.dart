import '../../domain/datasources/usuario_datasource.dart';
import '../../domain/repositories/usuario_repository.dart';
import 'package:mi_mercado/features/auth/domain/entities/Usuario.dart';

class UsuarioRepositoryImpl implements UsuarioRepository {
  final UsuarioDataSource dataSource;

  UsuarioRepositoryImpl(this.dataSource);

  @override
  Future<Usuario?> obtenerUsuarioPorId(String id) {
    print('usuario_repository_impl.dart: obtenerUsuarioPorId ($id)');
    return dataSource.obtenerUsuarioPorId(id);
  }

  @override
  Future<void> editarUsuario(Usuario usuario) {
    print('usuario_repository_impl.dart: editarUsuario (${usuario.nombre})');
    return dataSource.editarUsuario(usuario);
  }

  @override
  Future<void> editarContrasena(String idUsuario, String nuevaContrasena) {
    print('usuario_repository_impl.dart: editarContrasena ($idUsuario)');
    return dataSource.editarContrasena(idUsuario, nuevaContrasena);
  }
}