import 'package:cloud_firestore/cloud_firestore.dart';
import 'Persona.dart';
import 'SharedPreferencesServices.dart';

class Usuario extends Persona {

  List<Map<String, dynamic>> direcciones;
  List<dynamic> pedidos;

  Usuario({
    required super.id,
    super.nombre,
    super.apellido,
    super.email,
    super.password,
    super.telefono,
    required this.direcciones,
    required this.pedidos,
  }) : super(firebaseCollection: 'usuarios');

  @override
  String toString() {
    return 'Usuario(id: $id, nombre: $nombre, apellido: $apellido, email: $email, telefono: $telefono)';
  }

  // Método público para registrar usuario en Firebase.
  Future<void> registrarUsuario() async {
    try {
      final firebase = FirebaseFirestore.instance;
      await firebase.collection(firebaseCollection).doc().set({
        'nombre': nombre ,
        'apellido': apellido,
        'telefono': telefono ,
        'email': email,
        'password': password,
        'pedidos': pedidos,
        'direcciones': direcciones,
      });
    } catch (e) {
      print('Error al registrar usuario: ${e.toString()}');
      rethrow; // Re-lanza la excepción para que el llamador pueda manejarla
    }
  }

 
  /// Método estático para obtener las direcciones usando el ID de SharedPreferences
  static Future<List<Map<String, dynamic>>> obtenerDireccionesActuales() async {
    try {
      // Obtener el ID del usuario actual desde SharedPreferences
      final String? currentUserId = await SharedPreferencesService.getCurrentUserId();
      
      if (currentUserId == null || currentUserId.isEmpty) {
        throw Exception('No hay usuario autenticado');
      }

      print('🔍 Obteniendo direcciones para usuario ID desde SharedPreferences: $currentUserId');
      
      final firebase = FirebaseFirestore.instance;
      
      // Obtener el documento del usuario actual
      final DocumentSnapshot userDoc = await firebase
          .collection('usuarios')
          .doc(currentUserId)
          .get();

      if (!userDoc.exists) {
        print('❌ Usuario no encontrado con ID: $currentUserId');
        throw Exception('Usuario no encontrado');
      }

      final userData = userDoc.data() as Map<String, dynamic>;
      print('✅ Usuario encontrado: ${userData['nombre'] ?? 'Sin nombre'}');

      // Obtener las direcciones del array
      final List<dynamic> direccionesData = userData['direcciones'] ?? [];
      print('📍 Direcciones encontradas: ${direccionesData.length}');

      // Convertir a List<Map<String, dynamic>> y agregar índices como ID
      final List<Map<String, dynamic>> direccionesProcesadas = [];

      for (int i = 0; i < direccionesData.length; i++) {
        final direccionData = direccionesData[i] as Map<String, dynamic>;
        
        // Agregar el índice como ID para identificar la dirección
        final direccionProcesada = {
          'id': i.toString(),
          'nombre': direccionData['nombre'] ?? 'Sin nombre',
          'direccion': direccionData['direccion'] ?? 'Sin dirección',
          'referencias': direccionData['referencias'] ?? '',
          'principal': direccionData['principal'] ?? false,
        };

        direccionesProcesadas.add(direccionProcesada);
        print('✅ Dirección procesada: ${direccionProcesada['nombre']} - ${direccionProcesada['direccion']}');
      }

      return direccionesProcesadas;
      
    } catch (e) {
      print('❌ Error obteniendo direcciones: $e');
      throw Exception('Error al obtener direcciones: ${e.toString()}');
    }
  }



  /// Método estático para agregar una nueva dirección al usuario actual
  static Future<void> agregarDireccion({
    required String nombre,
    required String direccion,
    String? referencia,
    bool esPrincipal = false,
  }) async {
    try {
      print('💾 Agregando nueva dirección para el usuario actual...');
      
      // Obtener el ID del usuario actual desde SharedPreferences
      final String? currentUserId = await SharedPreferencesService.getCurrentUserId();
      
      if (currentUserId == null || currentUserId.isEmpty) {
        throw Exception('No hay usuario autenticado');
      }

      print('🔍 Usuario ID: $currentUserId');
      
      final firebase = FirebaseFirestore.instance;
      
      // Obtener el documento del usuario actual
      final DocumentReference userDoc = firebase.collection('usuarios').doc(currentUserId);
      final DocumentSnapshot userData = await userDoc.get();

      if (!userData.exists) {
        print('❌ Usuario no encontrado con ID: $currentUserId');
        throw Exception('Usuario no encontrado');
      }

      // Obtener direcciones actuales
      final Map<String, dynamic> currentData = userData.data() as Map<String, dynamic>;
      List<dynamic> direccionesActuales = List.from(currentData['direcciones'] ?? []);

      print('📍 Direcciones actuales: ${direccionesActuales.length}');

      // Si la nueva dirección es principal, marcar las demás como no principales
      if (esPrincipal) {
        for (int i = 0; i < direccionesActuales.length; i++) {
          direccionesActuales[i]['principal'] = false;
        }
        print('🏠 Marcando nueva dirección como principal y quitando principal a las demás');
      }

      // Crear el mapa de la nueva dirección
      final nuevaDireccionMap = {
        'nombre': nombre,
        'direccion': direccion,
        'referencias': referencia ?? '',
        'principal': esPrincipal,
      };

      // Agregar la nueva dirección al array
      direccionesActuales.add(nuevaDireccionMap);

      // Actualizar en Firebase
      await userDoc.update({
        'direcciones': direccionesActuales,
      });

      print('✅ Dirección "$nombre" agregada exitosamente');
      print('📊 Total de direcciones: ${direccionesActuales.length}');
      
    } catch (e) {
      print('❌ Error agregando dirección: $e');
      throw Exception('Error al agregar dirección: ${e.toString()}');
    }
  }

  /// Método estático para editar una dirección existente del usuario actual
  static Future<void> editarDireccion({
    required String direccionId,
    required String nombre,
    required String direccion,
    String? referencia,
    bool esPrincipal = false,
  }) async {
    try {
      print('✏️ Editando dirección para el usuario actual...');
      
      // Obtener el ID del usuario actual desde SharedPreferences
      final String? currentUserId = await SharedPreferencesService.getCurrentUserId();
      
      if (currentUserId == null || currentUserId.isEmpty) {
        throw Exception('No hay usuario autenticado');
      }

      print('🔍 Usuario ID: $currentUserId');
      print('📝 Editando dirección ID: $direccionId');
      
      final firebase = FirebaseFirestore.instance;
      
      // Obtener el documento del usuario actual
      final DocumentReference userDoc = firebase.collection('usuarios').doc(currentUserId);
      final DocumentSnapshot userData = await userDoc.get();

      if (!userData.exists) {
        print('❌ Usuario no encontrado con ID: $currentUserId');
        throw Exception('Usuario no encontrado');
      }

      // Obtener direcciones actuales
      final Map<String, dynamic> currentData = userData.data() as Map<String, dynamic>;
      List<dynamic> direccionesActuales = List.from(currentData['direcciones'] ?? []);

      print('📍 Direcciones actuales: ${direccionesActuales.length}');

      // Encontrar el índice de la dirección a editar
      int indexToEdit = -1;
      final direccionIndex = int.tryParse(direccionId) ?? -1;
      
      if (direccionIndex >= 0 && direccionIndex < direccionesActuales.length) {
        indexToEdit = direccionIndex;
        print('🎯 Dirección encontrada en índice: $indexToEdit');
      } else {
        throw Exception('Índice de dirección inválido: $direccionId');
      }

      // Si la dirección editada es principal, marcar las demás como no principales
      if (esPrincipal) {
        for (int i = 0; i < direccionesActuales.length; i++) {
          if (i != indexToEdit) {
            direccionesActuales[i]['principal'] = false;
          }
        }
        print('🏠 Marcando dirección como principal y quitando principal a las demás');
      }

      // Crear el mapa de la dirección actualizada
      final direccionActualizadaMap = {
        'nombre': nombre,
        'direccion': direccion,
        'referencias': referencia ?? '',
        'principal': esPrincipal,
      };

      // Actualizar la dirección específica en el array
      direccionesActuales[indexToEdit] = direccionActualizadaMap;

      // Actualizar en Firebase
      await userDoc.update({
        'direcciones': direccionesActuales,
      });

      print('✅ Dirección "$nombre" editada exitosamente');
      print('📊 Total de direcciones: ${direccionesActuales.length}');
      
    } catch (e) {
      print('❌ Error editando dirección: $e');
      throw Exception('Error al editar dirección: ${e.toString()}');
    }
  }

  /// Método estático para eliminar una dirección existente del usuario actual
  static Future<void> eliminarDireccion({
    required String direccionId,
  }) async {
    try {
      print('🗑️ Eliminando dirección para el usuario actual...');
      
      // Obtener el ID del usuario actual desde SharedPreferences
      final String? currentUserId = await SharedPreferencesService.getCurrentUserId();
      
      if (currentUserId == null || currentUserId.isEmpty) {
        throw Exception('No hay usuario autenticado');
      }

      print('🔍 Usuario ID: $currentUserId');
      print('🗑️ Eliminando dirección ID: $direccionId');
      
      final firebase = FirebaseFirestore.instance;
      
      // Obtener el documento del usuario actual
      final DocumentReference userDoc = firebase.collection('usuarios').doc(currentUserId);
      final DocumentSnapshot userData = await userDoc.get();

      if (!userData.exists) {
        print('❌ Usuario no encontrado con ID: $currentUserId');
        throw Exception('Usuario no encontrado');
      }

      // Obtener direcciones actuales
      final Map<String, dynamic> currentData = userData.data() as Map<String, dynamic>;
      List<dynamic> direccionesActuales = List.from(currentData['direcciones'] ?? []);

      print('📍 Direcciones actuales: ${direccionesActuales.length}');

      // Encontrar el índice de la dirección a eliminar
      int indexToRemove = -1;
      final direccionIndex = int.tryParse(direccionId) ?? -1;
      
      if (direccionIndex >= 0 && direccionIndex < direccionesActuales.length) {
        indexToRemove = direccionIndex;
        print('🎯 Dirección encontrada en índice: $indexToRemove');
      } else {
        throw Exception('Índice de dirección inválido: $direccionId');
      }

      // Guardar el nombre de la dirección antes de eliminarla para el log
      final direccionAEliminar = direccionesActuales[indexToRemove];
      final nombreDireccion = direccionAEliminar['nombre'] ?? 'Sin nombre';

      // Eliminar la dirección del array
      direccionesActuales.removeAt(indexToRemove);

      // Actualizar en Firebase
      await userDoc.update({
        'direcciones': direccionesActuales,
      });

      print('✅ Dirección "$nombreDireccion" eliminada exitosamente');
      print('📊 Total de direcciones restantes: ${direccionesActuales.length}');
      
    } catch (e) {
      print('❌ Error eliminando dirección: $e');
      throw Exception('Error al eliminar dirección: ${e.toString()}');
    }
  }


  /// Método estático para obtener solo la información básica del usuario actual
  static Future<Map<String, dynamic>?> obtenerDatosUsuarioActual() async {
    try {
      // Obtener el ID del usuario actual desde SharedPreferences
      final String? currentUserId = await SharedPreferencesService.getCurrentUserId();
      
      if (currentUserId == null || currentUserId.isEmpty) {
        throw Exception('No hay usuario autenticado');
      }

      print('🔍 Obteniendo datos básicos del usuario ID: $currentUserId');
      
      final firebase = FirebaseFirestore.instance;
      
      // Obtener el documento del usuario actual
      final DocumentSnapshot userDoc = await firebase
          .collection('usuarios')
          .doc(currentUserId)
          .get();

      if (!userDoc.exists) {
        print('❌ Usuario no encontrado con ID: $currentUserId');
        return null;
      }

      final userData = userDoc.data() as Map<String, dynamic>;
      
      // Retornar solo los datos básicos
      final datosBasicos = {
        'id': currentUserId,
        'nombre': userData['nombre'] ?? '',
        'apellido': userData['apellido'] ?? '',
        'email': userData['email'] ?? '',
        'telefono': userData['telefono'] ?? '',
      };

      print('✅ Datos básicos obtenidos: ${datosBasicos['nombre']} ${datosBasicos['apellido']}');
      return datosBasicos;
      
    } catch (e) {
      print('❌ Error obteniendo datos básicos del usuario: $e');
      throw Exception('Error al obtener datos básicos del usuario: ${e.toString()}');
    }
  }

  /// Método estático para actualizar los datos básicos del usuario actual
  static Future<void> actualizarDatosUsuario({
    required String nombre,
    required String apellido,
    required String telefono,
    required String email,
  }) async {
    try {
      print('✏️ Actualizando datos del usuario...');
      
      // Obtener el ID del usuario actual desde SharedPreferences
      final String? currentUserId = await SharedPreferencesService.getCurrentUserId();
      
      if (currentUserId == null || currentUserId.isEmpty) {
        throw Exception('No hay usuario autenticado');
      }

      print('🔍 Usuario ID: $currentUserId');
      
      final firebase = FirebaseFirestore.instance;
      
      // Obtener el documento del usuario actual
      final DocumentReference userDoc = firebase.collection('usuarios').doc(currentUserId);
      final DocumentSnapshot userData = await userDoc.get();

      if (!userData.exists) {
        print('❌ Usuario no encontrado con ID: $currentUserId');
        throw Exception('Usuario no encontrado');
      }

      // Validar que los campos no estén vacíos
      if (nombre.trim().isEmpty) {
        throw Exception('El nombre no puede estar vacío');
      }
      if (apellido.trim().isEmpty) {
        throw Exception('El apellido no puede estar vacío');
      }
      if (telefono.trim().isEmpty) {
        throw Exception('El teléfono no puede estar vacío');
      }
      if (email.trim().isEmpty) {
        throw Exception('El email no puede estar vacío');
      }

      // Crear el mapa con los datos actualizados
      final datosActualizados = {
        'nombre': nombre.trim(),
        'apellido': apellido.trim(),
        'telefono': telefono.trim(),
        'email': email.trim(),
      };

      // Actualizar en Firebase
      await userDoc.update(datosActualizados);

      // Actualizar el nombre en SharedPreferences también
      await SharedPreferencesService.updateUserName(nombre.trim());

      print('✅ Datos del usuario actualizados exitosamente');
      print('📊 Nuevos datos: $nombre $apellido - $email');
      
    } catch (e) {
      print('❌ Error actualizando datos del usuario: $e');
      throw Exception('Error al actualizar datos del usuario: ${e.toString()}');
    }
  }
}
