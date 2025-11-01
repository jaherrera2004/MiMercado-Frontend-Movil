import 'package:get/get.dart';
import 'package:mi_mercado/features/usuario/cuenta/domain/useCases/editar_contrasena.dart';

class SeguridadController extends GetxController {
  final EditarContrasenaUseCase editarContrasena;

  SeguridadController({
    required this.editarContrasena,
  });

  // Observables
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var successMessage = ''.obs;

  // Controladores de texto
  var contrasenaActualController = ''.obs;
  var nuevaContrasenaController = ''.obs;
  var confirmarContrasenaController = ''.obs;

  void resetForm() {
    contrasenaActualController.value = '';
    nuevaContrasenaController.value = '';
    confirmarContrasenaController.value = '';
    errorMessage.value = '';
    successMessage.value = '';
  }

  Future<bool> cambiarContrasena() async {
    if (!validarFormulario()) return false;

    isLoading.value = true;
    errorMessage.value = '';
    successMessage.value = '';

    try {
      final params = EditarContrasenaParams(
        contrasenaActual: contrasenaActualController.value,
        nuevaContrasena: nuevaContrasenaController.value,
      );

      final result = await editarContrasena(params);
      return result.fold(
        (failure) {
          errorMessage.value = failure.message;
          return false;
        },
        (_) {
          successMessage.value = 'Contraseña cambiada exitosamente';
          resetForm();
          return true;
        },
      );
    } catch (e) {
      errorMessage.value = 'Error al cambiar contraseña: $e';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  bool validarFormulario() {
    if (contrasenaActualController.value.isEmpty) {
      errorMessage.value = 'La contraseña actual es requerida';
      return false;
    }

    if (nuevaContrasenaController.value.isEmpty) {
      errorMessage.value = 'La nueva contraseña es requerida';
      return false;
    }

    if (nuevaContrasenaController.value.length < 6) {
      errorMessage.value = 'La nueva contraseña debe tener al menos 6 caracteres';
      return false;
    }

    if (nuevaContrasenaController.value != confirmarContrasenaController.value) {
      errorMessage.value = 'Las contraseñas no coinciden';
      return false;
    }

    return true;
  }
}
