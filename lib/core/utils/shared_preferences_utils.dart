import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtils {
	static const String _userIdKey = 'id_usuario';

	/// Guarda el id del usuario actual
	static Future<void> saveUserId(String userId) async {
		final prefs = await SharedPreferences.getInstance();
		await prefs.setString(_userIdKey, userId);
	}

	/// Edita el id del usuario actual
	static Future<void> editUserId(String newUserId) async {
		final prefs = await SharedPreferences.getInstance();
		await prefs.setString(_userIdKey, newUserId);
	}

	/// Elimina el id del usuario actual
	static Future<void> removeUserId() async {
		final prefs = await SharedPreferences.getInstance();
		await prefs.remove(_userIdKey);
	}

	/// Obtiene el id del usuario actual
	static Future<String?> getUserId() async {
		final prefs = await SharedPreferences.getInstance();
		return prefs.getString(_userIdKey);
	}
}
