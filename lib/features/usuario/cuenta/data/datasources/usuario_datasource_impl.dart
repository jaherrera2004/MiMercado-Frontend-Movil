import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/datasources/usuario_datasource.dart';
import 'package:mi_mercado/features/auth/domain/entities/Usuario.dart';

class UsuarioDataSourceImpl implements UsuarioDataSource {
  final FirebaseFirestore _firestore;
  final String _coleccionUsuarios = 'usuarios';

  UsuarioDataSourceImpl(this._firestore);

  @override
  Future<Usuario?> obtenerUsuarioPorId(String id) async {
    try {
      final userDoc = await _firestore.collection(_coleccionUsuarios).doc(id).get();

      if (!userDoc.exists) {
        return null;
      }

      final userData = userDoc.data() as Map<String, dynamic>;

      final usuario = Usuario.fromMap({
        'id': userDoc.id,
        ...userData,
      });

      print('usuario_datasource_impl.dart: usuario obtenido (${usuario.nombre})');
      return usuario;
    } catch (e) {
      print('usuario_datasource_impl.dart: error al obtener usuario: $e');
      throw Exception('Error al obtener usuario: $e');
    }
  }

  @override
  Future<void> editarUsuario(Usuario usuario) async {
    try {
      final userDoc = _firestore.collection(_coleccionUsuarios).doc(usuario.id);

      // Verificar que el usuario existe
      final userData = await userDoc.get();
      if (!userData.exists) {
        throw Exception('Usuario no encontrado');
      }

      // Actualizar los datos del usuario
      await userDoc.update(usuario.toDocument());

      print('usuario_datasource_impl.dart: usuario editado (${usuario.nombre})');
    } catch (e) {
      print('usuario_datasource_impl.dart: error al editar usuario: $e');
      throw Exception('Error al editar usuario: $e');
    }
  }

  @override
  Future<void> editarContrasena(String idUsuario, String nuevaContrasena) async {
    try {
      final userDoc = _firestore.collection(_coleccionUsuarios).doc(idUsuario);

      // Verificar que el usuario existe
      final userData = await userDoc.get();
      if (!userData.exists) {
        throw Exception('Usuario no encontrado');
      }

      // La contraseña ya viene encriptada desde el useCase
      // Simplemente actualizar en la base de datos
      await userDoc.update({
        'password': nuevaContrasena,
      });

      print('usuario_datasource_impl.dart: contraseña editada para usuario ($idUsuario)');
    } catch (e) {
      print('usuario_datasource_impl.dart: error al editar contraseña: $e');
      throw Exception('Error al editar contraseña: $e');
    }
  }
}