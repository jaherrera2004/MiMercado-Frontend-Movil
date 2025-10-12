import 'package:cloud_firestore/cloud_firestore.dart';
import 'Persona.dart';
import 'SharedPreferences.dart';

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
      // Validar que email y teléfono no estén ya registrados en 'usuarios' o 'repartidores'
      if (email != null && email!.trim().isNotEmpty) {
        final emailQueryUsuarios = await firebase.collection('usuarios').where('email', isEqualTo: email!.trim().toLowerCase()).get();
        final emailQueryRepartidores = await firebase.collection('repartidores').where('email', isEqualTo: email!.trim().toLowerCase()).get();

        if (emailQueryUsuarios.docs.isNotEmpty || emailQueryRepartidores.docs.isNotEmpty) {
          throw Exception('El email proporcionado ya está registrado');
        }
      }

      if (telefono != null && telefono!.trim().isNotEmpty) {
        final telefonoQueryUsuarios = await firebase.collection('usuarios').where('telefono', isEqualTo: telefono!.trim()).get();
        final telefonoQueryRepartidores = await firebase.collection('repartidores').where('telefono', isEqualTo: telefono!.trim()).get();

        if (telefonoQueryUsuarios.docs.isNotEmpty || telefonoQueryRepartidores.docs.isNotEmpty) {
          throw Exception('El teléfono proporcionado ya está registrado');
        }
      }

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

  // obteniendo direcciones para usuario
      
      final firebase = FirebaseFirestore.instance;
      
      // Obtener el documento del usuario actual
      final DocumentSnapshot userDoc = await firebase
          .collection('usuarios')
          .doc(currentUserId)
          .get();

      if (!userDoc.exists) {
        throw Exception('Usuario no encontrado');
      }

      final userData = userDoc.data() as Map<String, dynamic>;

      // Obtener las direcciones del array
      final List<dynamic> direccionesData = userData['direcciones'] ?? [];

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
      }

      return direccionesProcesadas;
      
    } catch (e) {
      print('Error obteniendo direcciones: $e');
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
  // agregando nueva dirección
      
      // Obtener el ID del usuario actual desde SharedPreferences
      final String? currentUserId = await SharedPreferencesService.getCurrentUserId();
      
      if (currentUserId == null || currentUserId.isEmpty) {
        throw Exception('No hay usuario autenticado');
      }

  // usuario id obtenido
      
      final firebase = FirebaseFirestore.instance;
      
      // Obtener el documento del usuario actual
      final DocumentReference userDoc = firebase.collection('usuarios').doc(currentUserId);
      final DocumentSnapshot userData = await userDoc.get();

      if (!userData.exists) {
        throw Exception('Usuario no encontrado');
      }

      // Obtener direcciones actuales
      final Map<String, dynamic> currentData = userData.data() as Map<String, dynamic>;
      List<dynamic> direccionesActuales = List.from(currentData['direcciones'] ?? []);

  // direcciones actuales obtenidas

      // Si la nueva dirección es principal, marcar las demás como no principales
      if (esPrincipal) {
        for (int i = 0; i < direccionesActuales.length; i++) {
          direccionesActuales[i]['principal'] = false;
        }
  // marcando nueva direccion como principal
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

  // dirección agregada con éxito
      
    } catch (e) {
      print('Error agregando dirección: $e');
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
  // editando direccion
      
      // Obtener el ID del usuario actual desde SharedPreferences
      final String? currentUserId = await SharedPreferencesService.getCurrentUserId();
      
      if (currentUserId == null || currentUserId.isEmpty) {
        throw Exception('No hay usuario autenticado');
      }

  // usuario id y direccion a editar obtenidos
      
      final firebase = FirebaseFirestore.instance;
      
      // Obtener el documento del usuario actual
      final DocumentReference userDoc = firebase.collection('usuarios').doc(currentUserId);
      final DocumentSnapshot userData = await userDoc.get();

      if (!userData.exists) {
        throw Exception('Usuario no encontrado');
      }

      // Obtener direcciones actuales
      final Map<String, dynamic> currentData = userData.data() as Map<String, dynamic>;
      List<dynamic> direccionesActuales = List.from(currentData['direcciones'] ?? []);

  // direcciones actuales obtenidas

      // Encontrar el índice de la dirección a editar
      int indexToEdit = -1;
      final direccionIndex = int.tryParse(direccionId) ?? -1;
      
      if (direccionIndex >= 0 && direccionIndex < direccionesActuales.length) {
  indexToEdit = direccionIndex;
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
  // marcando direccion como principal
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

  // dirección editada con éxito
      
    } catch (e) {
      print('Error editando dirección: $e');
      throw Exception('Error al editar dirección: ${e.toString()}');
    }
  }

  /// Método estático para eliminar una dirección existente del usuario actual
  static Future<void> eliminarDireccion({
    required String direccionId,
  }) async {
    try {
  // eliminando direccion
      
      // Obtener el ID del usuario actual desde SharedPreferences
      final String? currentUserId = await SharedPreferencesService.getCurrentUserId();
      
      if (currentUserId == null || currentUserId.isEmpty) {
        throw Exception('No hay usuario autenticado');
      }

  // usuario id y direccion a eliminar obtenidos
      
      final firebase = FirebaseFirestore.instance;
      
      // Obtener el documento del usuario actual
      final DocumentReference userDoc = firebase.collection('usuarios').doc(currentUserId);
      final DocumentSnapshot userData = await userDoc.get();

      if (!userData.exists) {
        throw Exception('Usuario no encontrado');
      }

      // Obtener direcciones actuales
      final Map<String, dynamic> currentData = userData.data() as Map<String, dynamic>;
      List<dynamic> direccionesActuales = List.from(currentData['direcciones'] ?? []);

  // direcciones actuales obtenidas

      // Encontrar el índice de la dirección a eliminar
      int indexToRemove = -1;
      final direccionIndex = int.tryParse(direccionId) ?? -1;
      
      if (direccionIndex >= 0 && direccionIndex < direccionesActuales.length) {
  indexToRemove = direccionIndex;
      } else {
        throw Exception('Índice de dirección inválido: $direccionId');
      }

  // Eliminar la dirección del array
  direccionesActuales.removeAt(indexToRemove);

      // Actualizar en Firebase
      await userDoc.update({
        'direcciones': direccionesActuales,
      });

  // dirección eliminada con éxito
      
    } catch (e) {
      print('Error eliminando dirección: $e');
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

  // obteniendo datos basicos del usuario
      
      final firebase = FirebaseFirestore.instance;
      
      // Obtener el documento del usuario actual
      final DocumentSnapshot userDoc = await firebase
          .collection('usuarios')
          .doc(currentUserId)
          .get();

      if (!userDoc.exists) {
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

      return datosBasicos;
      
    } catch (e) {
      print('Error obteniendo datos básicos del usuario: $e');
      throw Exception('Error al obtener datos básicos del usuario: ${e.toString()}');
    }
  }

  /// Método estático para obtener el nombre (nombre + apellido) de un usuario por su ID
  /// Retorna null si el usuario no existe o no tiene datos de nombre.
  static Future<String?> obtenerNombrePorId(String usuarioId) async {
    try {
      if (usuarioId.isEmpty) {
        throw Exception('El ID de usuario no puede estar vacío');
      }

      final firebase = FirebaseFirestore.instance;
      final DocumentSnapshot userDoc = await firebase
          .collection('usuarios')
          .doc(usuarioId)
          .get();

      if (!userDoc.exists) {
        return null;
      }

      final data = userDoc.data() as Map<String, dynamic>;
      final String nombre = (data['nombre'] ?? '').toString().trim();
      final String apellido = (data['apellido'] ?? '').toString().trim();
      final String nombreCompleto = (nombre + ' ' + apellido).trim();

      if (nombreCompleto.isEmpty) {
        return null;
      }

      return nombreCompleto;
    } catch (e) {
      print('❌ Error obteniendo nombre por ID ($usuarioId): $e');
      return null;
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
  // actualizando datos del usuario
      
      // Obtener el ID del usuario actual desde SharedPreferences
      final String? currentUserId = await SharedPreferencesService.getCurrentUserId();
      
      if (currentUserId == null || currentUserId.isEmpty) {
        throw Exception('No hay usuario autenticado');
      }

  // usuario id obtenido
      
      final firebase = FirebaseFirestore.instance;
      
      // Obtener el documento del usuario actual
      final DocumentReference userDoc = firebase.collection('usuarios').doc(currentUserId);
      final DocumentSnapshot userData = await userDoc.get();

      if (!userData.exists) {
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

  // datos actualizados exitosamente
      
    } catch (e) {
      print('Error actualizando datos del usuario: $e');
      throw Exception('Error al actualizar datos del usuario: ${e.toString()}');
    }
  }

  /// Método estático para editar la contraseña del usuario actual
  static Future<void> editarContrasena({
    required String contrasenaActual,
    required String contrasenaNueva,
  }) async {
    try {
  // iniciando cambio de contraseña
      
      // Obtener el ID del usuario actual desde SharedPreferences
      final String? currentUserId = await SharedPreferencesService.getCurrentUserId();
      
      if (currentUserId == null || currentUserId.isEmpty) {
        throw Exception('No hay usuario autenticado');
      }

  // usuario id obtenido
      
      final firebase = FirebaseFirestore.instance;
      
      // Obtener el documento del usuario actual
      final DocumentReference userDoc = firebase.collection('usuarios').doc(currentUserId);
      final DocumentSnapshot userData = await userDoc.get();

      if (!userData.exists) {
        throw Exception('Usuario no encontrado');
      }

      // Obtener los datos actuales del usuario
      final Map<String, dynamic> currentData = userData.data() as Map<String, dynamic>;
      final String? passwordGuardada = currentData['password'];

      // Validar que los campos no estén vacíos
      if (contrasenaActual.trim().isEmpty) {
        throw Exception('La contraseña actual no puede estar vacía');
      }
      if (contrasenaNueva.trim().isEmpty) {
        throw Exception('La nueva contraseña no puede estar vacía');
      }

      // Verificar que la contraseña actual sea correcta
      if (passwordGuardada != contrasenaActual.trim()) {
  // contraseña incorrecta
        throw Exception('La contraseña actual es incorrecta');
      }

      // Validar la nueva contraseña (mínimo 6 caracteres)
      if (contrasenaNueva.trim().length < 6) {
        throw Exception('La nueva contraseña debe tener al menos 6 caracteres');
      }

      // Verificar que la nueva contraseña sea diferente a la actual
      if (contrasenaActual.trim() == contrasenaNueva.trim()) {
        throw Exception('La nueva contraseña debe ser diferente a la actual');
      }

  // validaciones completadas

      // Actualizar la contraseña en Firebase
      await userDoc.update({
        'password': contrasenaNueva.trim(),
      });

  // contraseña actualizada con éxito
      
    } catch (e) {
      print('Error cambiando contraseña: $e');
      throw Exception('Error al cambiar contraseña: ${e.toString()}');
    }
  }

  
}
