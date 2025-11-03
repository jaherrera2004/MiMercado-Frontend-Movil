import 'package:get/get.dart';
import 'package:mi_mercado/core/utils/shared_preferences_utils.dart';
import 'package:mi_mercado/features/auth/domain/entities/Usuario.dart';
import 'package:mi_mercado/features/usuario/cuenta/domain/useCases/obtener_usuario_por_id.dart';
import 'package:mi_mercado/features/usuario/cuenta/domain/useCases/editar_usuario.dart';
import 'package:mi_mercado/features/usuario/cuenta/domain/useCases/editar_contrasena.dart';

class MiCuentaController extends GetxController {
  final ObtenerUsuarioPorIdUseCase obtenerUsuarioPorId;
  final EditarUsuarioUseCase editarUsuario;
  final EditarContrasenaUseCase editarContrasena;

  MiCuentaController({
    required this.obtenerUsuarioPorId,
    required this.editarUsuario,
    required this.editarContrasena,
  });

  // Observables
  var isLoading = false.obs;
  var usuario = Rxn<Usuario>();
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    cargarUsuarioActual();
  }

  Future<void> cargarUsuarioActual() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final idUsuario = await SharedPreferencesUtils.getUserId();
      if (idUsuario == null) {
        errorMessage.value = 'Usuario no autenticado';
        return;
      }

      final result = await obtenerUsuarioPorId(idUsuario);
      result.fold(
        (failure) {
          errorMessage.value = failure.message;
        },
        (user) {
          usuario.value = user;
        },
      );
    } catch (e) {
      errorMessage.value = 'Error al cargar usuario: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> actualizarUsuario(Usuario usuarioActualizado) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final result = await editarUsuario(usuarioActualizado);
      return result.fold(
        (failure) {
          errorMessage.value = failure.message;
          return false;
        },
        (_) {
          usuario.value = usuarioActualizado;
          return true;
        },
      );
    } catch (e) {
      errorMessage.value = 'Error al actualizar usuario: $e';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> cambiarContrasena(String contrasenaActual, String nuevaContrasena) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final params = EditarContrasenaParams(
        contrasenaActual: contrasenaActual,
        nuevaContrasena: nuevaContrasena,
      );

      final result = await editarContrasena(params);
      return result.fold(
        (failure) {
          errorMessage.value = failure.message;
          return false;
        },
        (_) => true,
      );
    } catch (e) {
      errorMessage.value = 'Error al cambiar contraseña: $e';
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
