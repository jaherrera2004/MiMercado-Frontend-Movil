import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mi_mercado/features/auth/domain/entities/Repartidor.dart';
import 'package:mi_mercado/features/auth/domain/entities/Usuario.dart';
import 'package:mi_mercado/features/auth/domain/datasources/auth_datasource.dart';

class AuthDataSourceImpl implements AuthDataSource {
  final FirebaseFirestore _firestore;

  final String _coleccionUsuarios = 'usuarios';
  final String _coleccionRepartidores = 'repartidores';

  AuthDataSourceImpl(this._firestore);

  @override
  Future<Usuario?> obtenerUsuarioPorEmail(String email) async {
    try {
      final querySnapshot = await _firestore
          .collection(_coleccionUsuarios)
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        final userData = doc.data();
        // Incluir el ID del documento en el mapa
        final userDataWithId = {'id': doc.id, ...userData};
        return Usuario.fromMap(userDataWithId);
      } else {
        return null;
      }
    } catch (e) {
      print('Error al obtener el usuario por email: $e');
      rethrow;
    }
  }

  @override
  Future<Repartidor?> obtenerRepartidorPorEmail(String email) async {
    try {
      final querySnapshot = await _firestore
          .collection(_coleccionRepartidores)
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        final repartidorData = doc.data();
        // Incluir el ID del documento en el mapa
        final repartidorDataWithId = {'id': doc.id, ...repartidorData};
        return Repartidor.fromMap(repartidorDataWithId);
      } else {
        return null;
      }
    } catch (e) {
      print('Error al obtener el repartidor por email: $e');
      rethrow;
    }
  }

  @override
  Future<void> registrarUsuario(Usuario usuario) async {
    try {
      final usuarioMap = usuario.toDocument();
      await _firestore.collection(_coleccionUsuarios).doc(usuario.id).set(usuarioMap);
      print('Usuario registrado exitosamente');
    } catch (e) {
      print('Error al registrar el usuario: $e');
      rethrow;
    }
  }
  
  @override
  Future<bool> emailExiste(String email, String rol) async {
    try {
      QuerySnapshot querySnapshot;
      if (rol == 'usuario') {
        querySnapshot = await _firestore
            .collection(_coleccionUsuarios)
            .where('email', isEqualTo: email)
            .limit(1)
            .get();
      } else {
        querySnapshot = await _firestore
            .collection(_coleccionRepartidores)
            .where('email', isEqualTo: email)
            .limit(1)
            .get();
      }

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error al verificar si el email existe: $e');
      rethrow;
    }
  }
  
  @override
  Future<bool> telefonoExiste(String telefono, String rol) async {
    try {
      QuerySnapshot querySnapshot;
      if (rol == 'usuario') {
        querySnapshot = await _firestore
            .collection(_coleccionUsuarios)
            .where('telefono', isEqualTo: telefono)
            .limit(1)
            .get();
      } else {
        querySnapshot = await _firestore
            .collection(_coleccionRepartidores)
            .where('telefono', isEqualTo: telefono)
            .limit(1)
            .get();
      }

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error al verificar si el telefono existe: $e');
      rethrow;
    }
  }
}