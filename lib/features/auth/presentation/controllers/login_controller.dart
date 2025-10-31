import 'package:mi_mercado/core/utils/shared_preferences_utils.dart';
import 'package:mi_mercado/features/auth/domain/entities/Persona.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_mercado/core/di/injection.dart';
import 'package:mi_mercado/features/auth/domain/useCases/login.dart';

class LoginController extends GetxController {
	final emailController = TextEditingController();
	final passwordController = TextEditingController();

	final isLoading = false.obs;

	@override
	void onClose() {
		emailController.dispose();
		passwordController.dispose();
		super.onClose();
	}

	String? validateEmail(String? value) {
		if (value == null || value.trim().isEmpty) {
			return 'El email es requerido';
		}
		final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
		if (!emailRegex.hasMatch(value.trim())) {
			return 'Ingresa un email válido';
		}
		return null;
	}

	String? validatePassword(String? value) {
		if (value == null || value.isEmpty) {
			return 'La contraseña es requerida';
		}
		if (value.length < 6) {
			return 'La contraseña debe tener al menos 6 caracteres';
		}
		return null;
	}

	Future<Persona?> login({String rol = 'usuario'}) async {
		final email = emailController.text.trim();
		final password = passwordController.text;

		final emailError = validateEmail(email);
		final passwordError = validatePassword(password);
		if (emailError != null || passwordError != null) {
			throw Exception(emailError ?? passwordError);
		}

		isLoading.value = true;
			try {
				final loginUseCase = getIt<Login>();
				final params = LoginParams(email: email, password: password, rol: rol);
				final persona = await loginUseCase.call(params);

				if (persona != null) {
					await SharedPreferencesUtils.saveUserId(persona.id!);
				}
        
				return persona;
			} finally {
				isLoading.value = false;
			}
	}
}
