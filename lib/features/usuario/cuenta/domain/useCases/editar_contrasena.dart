import 'package:mi_mercado/core/error/failure.dart';
import 'package:mi_mercado/core/useCases/use_case.dart';
import 'package:mi_mercado/core/utils/shared_preferences_utils.dart';
import '../repositories/usuario_repository.dart';
import 'package:mi_mercado/core/utils/bcrypt_utils.dart';
import 'package:dartz/dartz.dart';

class EditarContrasenaUseCase implements UseCase<Either<Failure, void>, EditarContrasenaParams> {
  final UsuarioRepository repository;
  EditarContrasenaUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(EditarContrasenaParams params) async {
    try {
      // Obtener el idUsuario desde SharedPreferences
      final idUsuario = await SharedPreferencesUtils.getUserId();
      if (idUsuario == null) {
        return Left(ServerFailure('Usuario no autenticado'));
      }

      // 1. Obtener el usuario para validar la contraseña actual
      final usuario = await repository.obtenerUsuarioPorId(idUsuario);

      if (usuario == null) {
        return Left(ServerFailure('Usuario no encontrado'));
      }

      // 2. Verificar que la contraseña actual sea correcta
      final contrasenaActualValida = BcryptUtils.verificarContrasena(
        params.contrasenaActual,
        usuario.password
      );

      if (!contrasenaActualValida) {
        return Left(ServerFailure('La contraseña actual es incorrecta'));
      }

      // 3. Validar que la nueva contraseña sea diferente a la actual
      final nuevaContrasenaValida = BcryptUtils.verificarContrasena(
        params.nuevaContrasena,
        usuario.password
      );

      if (nuevaContrasenaValida) {
        return Left(ServerFailure('La nueva contraseña debe ser diferente a la actual'));
      }

      // 4. Encriptar la nueva contraseña usando bcrypt en el dominio
      final contrasenaEncriptada = BcryptUtils.encriptarContrasena(params.nuevaContrasena);

      // 5. Actualizar la contraseña
      await repository.editarContrasena(idUsuario, contrasenaEncriptada);
      print('editar_contrasena.dart: contraseña editada para usuario ($idUsuario)');
      return const Right(null);
    } catch (e) {
      print('editar_contrasena.dart: error al editar contraseña: $e');
      return Left(ServerFailure(e.toString()));
    }
  }
}

class EditarContrasenaParams {
  final String contrasenaActual;
  final String nuevaContrasena;

  EditarContrasenaParams({
    required this.contrasenaActual,
    required this.nuevaContrasena,
  });
}