import 'package:cloud_firestore/cloud_firestore.dart';
import 'Persona.dart';
import 'SharedPreferences.dart';

// Enum para definir los estados posibles del repartidor
enum EstadoRepartidor {
  conectado('Disponible'),
  ocupado('Ocupado'),
  desconectado('Desconectado');

  const EstadoRepartidor(this.displayName);
  final String displayName;

  // Método para obtener el enum desde un string
  static EstadoRepartidor fromString(String estado) {
    switch (estado.toLowerCase()) {
      case 'disponible':
        return EstadoRepartidor.conectado;
      case 'ocupado':
        return EstadoRepartidor.ocupado;
      case 'desconectado':
        return EstadoRepartidor.desconectado;
      default:
        return EstadoRepartidor.desconectado;
    }
  }
}

class Repartidor extends Persona {
  String cedula;
  String estadoActual;
  List<dynamic> historialPedidos;
  String pedidoActual;

  Repartidor({
    required super.id,
    super.nombre,
    super.apellido,
    super.email,
    super.password,
    super.telefono,
    required this.cedula,
    required this.estadoActual,
    required this.historialPedidos,
    required this.pedidoActual,
  }) : super(firebaseCollection: 'repartidores');

  /// Método para cambiar el estado del repartidor en Firebase
  /// Obtiene el ID desde SharedPreferences y actualiza tanto Firebase como las preferencias locales
  static Future<bool> cambiarEstado(EstadoRepartidor nuevoEstado) async {
    try {
      // Obtener el ID del repartidor desde SharedPreferences
      final String? repartidorId = await SharedPreferencesService.getCurrentUserId();
      
      if (repartidorId == null || repartidorId.isEmpty) {
        print('Error: No se encontró el ID del repartidor en SharedPreferences');
        return false;
      }

      // Referencia a la colección de repartidores en Firestore
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final DocumentReference repartidorRef = firestore
          .collection('repartidores')
          .doc(repartidorId);

      // Verificar que el documento existe
      final DocumentSnapshot repartidorDoc = await repartidorRef.get();
      if (!repartidorDoc.exists) {
        print('Error: No se encontró el repartidor con ID: $repartidorId');
        return false;
      }

      // Actualizar el estado en Firebase
      await repartidorRef.update({
        'estado_actual': nuevoEstado.displayName,
      });

      // Actualizar el estado en SharedPreferences
      await SharedPreferencesService.updateEstadoActual(nuevoEstado.displayName);

      print('Estado del repartidor actualizado exitosamente a: ${nuevoEstado.displayName}');
      return true;

    } catch (e) {
      print('Error al cambiar el estado del repartidor: $e');
      return false;
    }
  }

  /// Método para obtener el estado actual del repartidor desde Firebase
  static Future<EstadoRepartidor?> obtenerEstadoActual() async {
    try {
      // Obtener el ID del repartidor desde SharedPreferences
      final String? repartidorId = await SharedPreferencesService.getCurrentUserId();
      
      if (repartidorId == null || repartidorId.isEmpty) {
        print('Error: No se encontró el ID del repartidor en SharedPreferences');
        return null;
      }

      // Obtener el documento del repartidor desde Firebase
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final DocumentSnapshot repartidorDoc = await firestore
          .collection('repartidores')
          .doc(repartidorId)
          .get();

      if (!repartidorDoc.exists) {
        print('Error: No se encontró el repartidor con ID: $repartidorId');
        return null;
      }

      // Extraer el estado actual del documento
      final Map<String, dynamic> data = repartidorDoc.data() as Map<String, dynamic>;
      final String estadoString = data['estado_actual'] ?? 'Desconectado';

      return EstadoRepartidor.fromString(estadoString);

    } catch (e) {
      print('Error al obtener el estado del repartidor: $e');
      return null;
    }
  }



  /// Método para asignar un pedido al repartidor (tomar pedido)
  static Future<bool> asignarPedido(String pedidoId) async {
    if (pedidoId.isEmpty) {
      print('Error: El ID del pedido no puede estar vacío');
      return false;
    }
    
    try {
      // Obtener el ID del repartidor desde SharedPreferences
      final String? repartidorId = await SharedPreferencesService.getCurrentUserId();
      
      if (repartidorId == null || repartidorId.isEmpty) {
        print('Error: No se encontró el ID del repartidor en SharedPreferences');
        return false;
      }

      // Referencia a la colección de repartidores en Firestore
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final DocumentReference repartidorRef = firestore
          .collection('repartidores')
          .doc(repartidorId);

      // Verificar que el documento existe
      final DocumentSnapshot repartidorDoc = await repartidorRef.get();
      if (!repartidorDoc.exists) {
        print('Error: No se encontró el repartidor con ID: $repartidorId');
        return false;
      }

      // Actualizar el pedido actual en Firebase
      await repartidorRef.update({
        'pedido_actual': pedidoId,
      });

      // Actualizar el pedido actual en SharedPreferences
      await SharedPreferencesService.updatePedidoActual(pedidoId);

      print('Pedido actual del repartidor actualizado a: $pedidoId');
      return true;

    } catch (e) {
      print('Error al asignar el pedido al repartidor: $e');
      return false;
    }
  }

  /// Método para liberar el pedido actual del repartidor (entregar/cancelar)
  static Future<bool> liberarPedidoActual() async {
    try {
      // Obtener el ID del repartidor desde SharedPreferences
      final String? repartidorId = await SharedPreferencesService.getCurrentUserId();
      
      if (repartidorId == null || repartidorId.isEmpty) {
        print('Error: No se encontró el ID del repartidor en SharedPreferences');
        return false;
      }

      // Referencia a la colección de repartidores en Firestore
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final DocumentReference repartidorRef = firestore
          .collection('repartidores')
          .doc(repartidorId);

      // Verificar que el documento existe
      final DocumentSnapshot repartidorDoc = await repartidorRef.get();
      if (!repartidorDoc.exists) {
        print('Error: No se encontró el repartidor con ID: $repartidorId');
        return false;
      }

      // Actualizar el pedido actual en Firebase
      await repartidorRef.update({
        'pedido_actual': '',
      });

      // Actualizar el pedido actual en SharedPreferences
      await SharedPreferencesService.updatePedidoActual('');

      print('Pedido actual del repartidor liberado exitosamente');
      return true;

    } catch (e) {
      print('Error al liberar el pedido actual del repartidor: $e');
      return false;
    }
  }

  /// Método para obtener el pedido actual del repartidor desde Firebase
  static Future<String?> obtenerPedidoActual() async {
    try {
      // Obtener el ID del repartidor desde SharedPreferences
      final String? repartidorId = await SharedPreferencesService.getCurrentUserId();
      
      if (repartidorId == null || repartidorId.isEmpty) {
        print('Error: No se encontró el ID del repartidor en SharedPreferences');
        return null;
      }

      // Obtener el documento del repartidor desde Firebase
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final DocumentSnapshot repartidorDoc = await firestore
          .collection('repartidores')
          .doc(repartidorId)
          .get();

      if (!repartidorDoc.exists) {
        print('Error: No se encontró el repartidor con ID: $repartidorId');
        return null;
      }

      // Extraer el pedido actual del documento
      final Map<String, dynamic> data = repartidorDoc.data() as Map<String, dynamic>;
      final String pedidoActual = data['pedido_actual'] ?? '';

      return pedidoActual;

    } catch (e) {
      print('Error al obtener el pedido actual del repartidor: $e');
      return null;
    }
  }



  /// Método para agregar un pedido al historial del repartidor
  static Future<bool> agregarPedidoAlHistorial(String pedidoId) async {
    try {
      // Obtener el ID del repartidor desde SharedPreferences
      final String? repartidorId = await SharedPreferencesService.getCurrentUserId();
      
      if (repartidorId == null || repartidorId.isEmpty) {
        print('Error: No se pudo obtener el ID del repartidor');
        return false;
      }

      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final DocumentReference repartidorRef = firestore
          .collection('repartidores')
          .doc(repartidorId);

      // Usar FieldValue.arrayUnion para agregar el pedido al array sin duplicados
      await repartidorRef.update({
        'historial_pedidos': FieldValue.arrayUnion([pedidoId]),
      });

      print('Pedido $pedidoId agregado al historial del repartidor $repartidorId');
      return true;

    } catch (e) {
      print('Error al agregar pedido al historial: $e');
      return false;
    }
  }

  /// Método para obtener el historial de pedidos del repartidor
  static Future<List<String>> obtenerHistorialPedidos() async {
    try {
      // Obtener el ID del repartidor desde SharedPreferences
      final String? repartidorId = await SharedPreferencesService.getCurrentUserId();
      
      if (repartidorId == null || repartidorId.isEmpty) {
        print('Error: No se pudo obtener el ID del repartidor');
        return [];
      }

      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final DocumentSnapshot repartidorDoc = await firestore
          .collection('repartidores')
          .doc(repartidorId)
          .get();

      if (!repartidorDoc.exists) {
        print('Error: No se encontró el repartidor con ID: $repartidorId');
        return [];
      }

      final Map<String, dynamic> data = repartidorDoc.data() as Map<String, dynamic>;
      final List<dynamic> historial = data['historial_pedidos'] ?? [];

      // Convertir a List<String> y retornar
      return historial.map((pedidoId) => pedidoId.toString()).toList();

    } catch (e) {
      print('Error al obtener historial de pedidos: $e');
      return [];
    }
  }

  /// Método para obtener los datos completos del repartidor actual
  static Future<Repartidor?> obtenerRepartidorActual() async {
    try {
      // Obtener el ID del repartidor desde SharedPreferences
      final String? repartidorId = await SharedPreferencesService.getCurrentUserId();
      
      if (repartidorId == null || repartidorId.isEmpty) {
        print('Error: No se pudo obtener el ID del repartidor desde SharedPreferences');
        return null;
      }

      // Obtener el documento del repartidor desde Firebase
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final DocumentSnapshot repartidorDoc = await firestore
          .collection('repartidores')
          .doc(repartidorId)
          .get();

      if (!repartidorDoc.exists) {
        print('Error: No se encontró el repartidor con ID: $repartidorId en Firebase');
        return null;
      }

      // Extraer los datos del documento
      final Map<String, dynamic> data = repartidorDoc.data() as Map<String, dynamic>;

      // Crear y retornar el objeto Repartidor
      return Repartidor(
        id: repartidorId,
        nombre: data['nombre'] ?? '',
        apellido: data['apellido'] ?? '',
        email: data['email'] ?? '',
        password: '', // No retornamos la contraseña por seguridad
        telefono: data['telefono'] ?? '',
        cedula: data['cedula'] ?? '',
        estadoActual: data['estado_actual'] ?? 'Desconectado',
        historialPedidos: data['historial_pedidos'] ?? [],
        pedidoActual: data['pedido_actual'] ?? '',
      );

    } catch (e) {
      print('Error al obtener datos del repartidor actual: $e');
      return null;
    }
  }


}