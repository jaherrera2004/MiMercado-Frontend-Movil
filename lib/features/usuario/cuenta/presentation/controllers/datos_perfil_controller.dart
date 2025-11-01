import 'package:get/get.dart';
import 'package:mi_mercado/features/auth/domain/entities/Usuario.dart';
import 'package:mi_mercado/features/usuario/cuenta/domain/useCases/obtener_usuario_por_id.dart';
import 'package:mi_mercado/features/usuario/cuenta/domain/useCases/editar_usuario.dart';
import 'package:mi_mercado/models/SharedPreferences.dart';

class DatosPerfilController extends GetxController {
  final ObtenerUsuarioPorIdUseCase obtenerUsuarioPorId;
  final EditarUsuarioUseCase editarUsuario;

  DatosPerfilController({
    required this.obtenerUsuarioPorId,
    required this.editarUsuario,
  });

  // Observables
  var isLoading = false.obs;
  var usuario = Rxn<Usuario>();
  var errorMessage = ''.obs;

  // Controladores de texto para edición
  var nombreController = ''.obs;
  var emailController = ''.obs;
  var telefonoController = ''.obs;

  @override
  void onInit() {
    super.onInit();
    cargarDatosPerfil();
  }

  Future<void> cargarDatosPerfil() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final idUsuario = await SharedPreferencesService.getCurrentUserId();
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
          if (user != null) {
            usuario.value = user;
            nombreController.value = user.nombre ?? '';
            emailController.value = user.email;
            telefonoController.value = user.telefono;
          }
        },
      );
    } catch (e) {
      errorMessage.value = 'Error al cargar datos del perfil: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> guardarCambios() async {
    if (usuario.value == null) return false;

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final usuarioActualizado = Usuario(
        id: usuario.value!.id,
        nombre: nombreController.value,
        apellido: usuario.value!.apellido, // Mantener apellido
        email: emailController.value,
        password: usuario.value!.password, // Mantener la contraseña existente
        telefono: telefonoController.value,
        direcciones: usuario.value!.direcciones, // Mantener direcciones
        pedidos: usuario.value!.pedidos, // Mantener pedidos
      );

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
      errorMessage.value = 'Error al guardar cambios: $e';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  void resetCambios() {
    if (usuario.value != null) {
      nombreController.value = usuario.value!.nombre ?? '';
      emailController.value = usuario.value!.email;
      telefonoController.value = usuario.value!.telefono;
    }
  }
}
