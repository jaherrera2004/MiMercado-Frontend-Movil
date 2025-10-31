import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/datasources/direccion_datasource.dart';
import '../../domain/entities/Direccion.dart';

class DireccionDataSourceImpl implements DireccionDataSource {
  final FirebaseFirestore _firestore;
  final String _coleccionUsuarios = 'usuarios';

  DireccionDataSourceImpl(this._firestore);

  @override
  Future<void> agregarDireccion(Direccion direccion) async {
    try {
      final userDoc = _firestore.collection(_coleccionUsuarios).doc(direccion.idUsuario);
      final userData = await userDoc.get();

      if (!userData.exists) {
        throw Exception('Usuario no encontrado');
      }

      final Map<String, dynamic> currentData = userData.data() as Map<String, dynamic>;
      List<dynamic> direccionesActuales = List.from(currentData['direcciones'] ?? []);

      // Si la nueva dirección es principal, marcar las demás como no principales
      if (direccion.esPrincipal) {
        for (int i = 0; i < direccionesActuales.length; i++) {
          direccionesActuales[i]['principal'] = false;
        }
      }

      // Crear el mapa de la nueva dirección
      final nuevaDireccionMap = {
        'nombre': direccion.nombre,
        'direccion': direccion.direccion,
        'referencias': direccion.referencia,
        'principal': direccion.esPrincipal,
      };

      // Agregar la nueva dirección al array
      direccionesActuales.add(nuevaDireccionMap);

      // Actualizar en Firebase
      await userDoc.update({
        'direcciones': direccionesActuales,
      });

      print('direccion_datasource_impl.dart: dirección agregada (${direccion.nombre})');
    } catch (e) {
      print('direccion_datasource_impl.dart: error al agregar dirección: $e');
      throw Exception('Error al agregar dirección: $e');
    }
  }

  @override
  Future<List<Direccion>> obtenerDirecciones(String idUsuario) async {
    try {
      final userDoc = await _firestore.collection(_coleccionUsuarios).doc(idUsuario).get();

      if (!userDoc.exists) {
        throw Exception('Usuario no encontrado');
      }

      final userData = userDoc.data() as Map<String, dynamic>;
      final List<dynamic> direccionesData = userData['direcciones'] ?? [];

      // Convertir a List<Direccion> y agregar índices como ID
      final List<Direccion> direcciones = [];

      for (int i = 0; i < direccionesData.length; i++) {
        final direccionData = direccionesData[i] as Map<String, dynamic>;

        final direccion = Direccion(
          id: i.toString(),
          idUsuario: idUsuario,
          nombre: direccionData['nombre'] ?? 'Sin nombre',
          direccion: direccionData['direccion'] ?? 'Sin dirección',
          referencia: direccionData['referencias'] ?? '',
          esPrincipal: direccionData['principal'] ?? false,
        );

        direcciones.add(direccion);
      }

      print('direccion_datasource_impl.dart: direcciones obtenidas (${direcciones.length})');
      return direcciones;
    } catch (e) {
      print('direccion_datasource_impl.dart: error al obtener direcciones: $e');
      throw Exception('Error al obtener direcciones: $e');
    }
  }

  @override
  Future<void> editarDireccion(Direccion direccion) async {
    try {
      final userDoc = _firestore.collection(_coleccionUsuarios).doc(direccion.idUsuario);
      final userData = await userDoc.get();

      if (!userData.exists) {
        throw Exception('Usuario no encontrado');
      }

      final Map<String, dynamic> currentData = userData.data() as Map<String, dynamic>;
      List<dynamic> direccionesActuales = List.from(currentData['direcciones'] ?? []);

      // Encontrar el índice de la dirección a editar
      int indexToEdit = -1;
      final direccionIndex = int.tryParse(direccion.id) ?? -1;

      if (direccionIndex >= 0 && direccionIndex < direccionesActuales.length) {
        indexToEdit = direccionIndex;
      } else {
        throw Exception('Índice de dirección inválido: ${direccion.id}');
      }

      // Si la dirección editada es principal, marcar las demás como no principales
      if (direccion.esPrincipal) {
        for (int i = 0; i < direccionesActuales.length; i++) {
          if (i != indexToEdit) {
            direccionesActuales[i]['principal'] = false;
          }
        }
      }

      // Crear el mapa de la dirección actualizada
      final direccionActualizadaMap = {
        'nombre': direccion.nombre,
        'direccion': direccion.direccion,
        'referencias': direccion.referencia,
        'principal': direccion.esPrincipal,
      };

      // Actualizar la dirección específica en el array
      direccionesActuales[indexToEdit] = direccionActualizadaMap;

      // Actualizar en Firebase
      await userDoc.update({
        'direcciones': direccionesActuales,
      });

      print('direccion_datasource_impl.dart: dirección editada (${direccion.nombre})');
    } catch (e) {
      print('direccion_datasource_impl.dart: error al editar dirección: $e');
      throw Exception('Error al editar dirección: $e');
    }
  }

  @override
  Future<void> eliminarDireccion(String id, String idUsuario) async {
    try {
      final userDoc = _firestore.collection(_coleccionUsuarios).doc(idUsuario);
      final userData = await userDoc.get();

      if (!userData.exists) {
        throw Exception('Usuario no encontrado');
      }

      final Map<String, dynamic> currentData = userData.data() as Map<String, dynamic>;
      List<dynamic> direccionesActuales = List.from(currentData['direcciones'] ?? []);

      // Encontrar el índice de la dirección a eliminar
      int indexToRemove = -1;
      final direccionIndex = int.tryParse(id) ?? -1;

      if (direccionIndex >= 0 && direccionIndex < direccionesActuales.length) {
        indexToRemove = direccionIndex;
      } else {
        throw Exception('Índice de dirección inválido: $id');
      }

      // Eliminar la dirección del array
      direccionesActuales.removeAt(indexToRemove);

      // Actualizar en Firebase
      await userDoc.update({
        'direcciones': direccionesActuales,
      });

      print('direccion_datasource_impl.dart: dirección eliminada ($id)');
    } catch (e) {
      print('direccion_datasource_impl.dart: error al eliminar dirección: $e');
      throw Exception('Error al eliminar dirección: $e');
    }
  }
}