import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_mercado/core/di/injection.dart';
import 'package:mi_mercado/core/error/failure.dart';
import 'package:mi_mercado/features/auth/domain/entities/Usuario.dart';
import 'package:mi_mercado/features/auth/domain/useCases/registrar_usuario.dart';

/// Controller para manejar el registro de usuario usando GetX.
class RegistrarUsuarioController extends GetxController {
	// Compilar una sola vez las expresiones regulares para evitar reconstrucciones
	// y para poder manejar errores de manera centralizada.
	static final RegExp _emailRegex =
		RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
	static final RegExp _phoneRegex = RegExp(r'^[0-9]{8,15}$');
	// Controladores de texto utilizados por la UI.
	final nombreController = TextEditingController();
	final apellidoController = TextEditingController();
	final telefonoController = TextEditingController();
	final emailController = TextEditingController();
	final passwordController = TextEditingController();

	// Estado de carga observable
	final isLoading = false.obs;

	@override
	void onClose() {
		nombreController.dispose();
		apellidoController.dispose();
		telefonoController.dispose();
		emailController.dispose();
		passwordController.dispose();
		super.onClose();
	}

		// Validadores locales para email, teléfono y contraseña.
		// Devuelven null si el valor es válido, o un mensaje de error si no lo es.
		String? _validateEmail(String? value) {
			if (value == null || value.trim().isEmpty) {
				return 'El email es requerido';
			}

			final email = value.trim();
			final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
			if (!emailRegex.hasMatch(email)) {
				return 'Ingresa un email válido';
			}
			return null;
		}

		String? _validatePhone(String? value) {

			if (value == null || value.trim().isEmpty) {
				return 'El teléfono es requerido';
			}

			final phone = value.trim();
			final phoneRegex = RegExp(r'^[0-9]{8,15}$');

			if (!phoneRegex.hasMatch(phone)) {
				return 'Ingresa un teléfono válido (8-15 dígitos)';
			}

			return null;
		}

		String? _validatePassword(String? value) {
			if (value == null || value.isEmpty) {
				return 'La contraseña es requerida';
			}
			if (value.length < 6) {
				return 'La contraseña debe tener al menos 6 caracteres';
			}
			return null;
		}

	/// Realiza el registro del usuario creando el modelo y llamando al método
	/// `registrarUsuario` del modelo `Usuario`.
	/// Lanza una excepción en caso de error para que la UI la maneje.
	Future<void> register() async {
			// Validaciones en el controller (la UI también las realiza antes normalmente)
			final nombre = nombreController.text.trim();
			final apellido = apellidoController.text.trim();
			final telefono = telefonoController.text.trim();
			final email = emailController.text.trim();
			final password = passwordController.text;

			final phoneError = _validatePhone(telefono);
			if (phoneError != null) {
				throw InvalidPhoneFailure();
			}

			
			final emailError = _validateEmail(email);
			if (emailError != null) {
				throw InvalidEmailFailure();
			}

			final passwordError = _validatePassword(password);
			if (passwordError != null) {
				throw InvalidPasswordFailure();
			}

				isLoading.value = true;
				try {
					final nuevoUsuario = Usuario(
						nombre: nombre,
						apellido: apellido,
						telefono: telefono,
						email: email,
						password: password,
						pedidos: [],
						direcciones: [],
					);

					// Obtener el usecase desde el service locator (registrado en el composition root)
					final registrarUsuarioUseCase = getIt<RegistrarUsuario>();
					// Llamar al use case con los parámetros
        	await registrarUsuarioUseCase.call(RegistrarUsuarioParams(usuario: nuevoUsuario));
          
				} finally {
					isLoading.value = false;
				}
	}
}

