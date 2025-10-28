import 'package:bcrypt/bcrypt.dart';

class BcryptUtils {
  // Método para encriptar una contraseña
  static String encriptarContrasena(String contrasena) {
    try {
      // Genera un hash de la contraseña utilizando bcrypt
      final hashed = BCrypt.hashpw(contrasena, BCrypt.gensalt());
      return hashed;
    } catch (e) {
      print('Error al encriptar la contraseña: $e');
      rethrow;
    }
  }

  // Método para verificar si una contraseña coincide con su hash
  static bool verificarContrasena(String contrasena, String hash) {
    try {
      // Compara la contraseña con el hash almacenado
      return BCrypt.checkpw(contrasena, hash);
    } catch (e) {
      print('Error al verificar la contraseña: $e');
      return false;
    }
  }
}