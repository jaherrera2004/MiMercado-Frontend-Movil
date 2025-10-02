import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  // Claves para SharedPreferences
  static const String _keyId = 'id';
  static const String _keyNombre = 'nombre';
  static const String _keyRol = 'rol';
  static const String _keyPedidoActual = 'pedido_actual';
  static const String _keyEstadoActual = 'estado_actual';

  /// Guarda los datos de sesión básicos en SharedPreferences
  static Future<void> saveSessionData({
    required String id,
    required String nombre,
    required String rol,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();


      // Guardar con validaciones adicionales
      await prefs.setString(_keyId, id);
      await prefs.setString(_keyNombre, nombre);
      await prefs.setString(_keyRol, rol);
      
      
    } catch (e) {
      print('Error detallado en saveSessionData: $e');
      throw Exception('Error guardando datos de sesión: ${e.toString()}');
    }
  }

  /// Guarda los datos de sesión específicos para repartidor
  static Future<void> saveRepartidorSessionData({
    required String id,
    required String nombre,
    required String rol,
    String? pedidoActual,
    String? estadoActual,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Guardar datos básicos
      await prefs.setString(_keyId, id);
      await prefs.setString(_keyNombre, nombre);
      await prefs.setString(_keyRol, rol);
      
      // Guardar datos específicos del repartidor
      await prefs.setString(_keyPedidoActual, pedidoActual ?? '');
      await prefs.setString(_keyEstadoActual, estadoActual ?? '');
      
      print('Datos de repartidor guardados: ID=$id, Nombre=$nombre, PedidoActual=${pedidoActual ?? "vacío"}, EstadoActual=${estadoActual ?? "vacío"}');
      
    } catch (e) {
      print('Error detallado en saveRepartidorSessionData: $e');
      throw Exception('Error guardando datos de sesión del repartidor: ${e.toString()}');
    }
  }

  /// Obtiene el ID del usuario actual
  static Future<String?> getCurrentUserId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_keyId);
    } catch (e) {
      return null;
    }
  }

  /// Obtiene el nombre del usuario actual
  static Future<String?> getCurrentUserName() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_keyNombre);
    } catch (e) {
      return null;
    }
  }

  /// Obtiene el pedido actual del repartidor
  static Future<String?> getCurrentPedidoActual() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_keyPedidoActual);
    } catch (e) {
      return null;
    }
  }

  /// Obtiene el estado actual del repartidor
  static Future<String?> getCurrentEstadoActual() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_keyEstadoActual);
    } catch (e) {
      return null;
    }
  }

  /// Actualiza el pedido actual del repartidor
  static Future<void> updatePedidoActual(String pedidoActual) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyPedidoActual, pedidoActual);
    } catch (e) {
      throw Exception('Error actualizando pedido actual: ${e.toString()}');
    }
  }

  /// Actualiza el estado actual del repartidor
  static Future<void> updateEstadoActual(String estadoActual) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyEstadoActual, estadoActual);
    } catch (e) {
      throw Exception('Error actualizando estado actual: ${e.toString()}');
    }
  }

  /// Limpia todos los datos de sesión (logout)
  static Future<void> clearSessionData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      await Future.wait([
        prefs.remove(_keyId),
        prefs.remove(_keyNombre),
        prefs.remove(_keyRol),
        prefs.remove(_keyPedidoActual),
        prefs.remove(_keyEstadoActual),
      ]);
    } catch (e) {
      throw Exception('Error limpiando datos de sesión: ${e.toString()}');
    }
  }

  /// Actualiza el nombre del usuario
  static Future<void> updateUserName(String newName) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyNombre, newName);
    } catch (e) {
      throw Exception('Error actualizando nombre: ${e.toString()}');
    }
  }
}
