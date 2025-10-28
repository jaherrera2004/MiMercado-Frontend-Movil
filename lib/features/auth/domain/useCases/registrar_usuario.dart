import 'package:mi_mercado/core/useCases/use_case.dart';
import 'package:mi_mercado/core/utils/bcrypt_utils.dart';
import 'package:mi_mercado/features/auth/domain/entities/Usuario.dart';
import 'package:mi_mercado/features/auth/domain/repositories/auth_repository.dart';

class RegistrarUsuario implements UseCase<void, RegistrarUsuarioParams> {
  final AuthRepository _authRepository;

  RegistrarUsuario(this._authRepository);

  @override
  Future<void> call(RegistrarUsuarioParams params) async {
    final emailExiste = await _authRepository.emailExiste(params.usuario.email, 'usuario');
    if (emailExiste) {
      throw Exception('El email ya está registrado');
    }

    final telefonoExiste = await _authRepository.telefonoExiste(params.usuario.telefono, 'usuario');
    if (telefonoExiste) {
      throw Exception('El teléfono ya está registrado');
    }

    final hashedPassword = BcryptUtils.encriptarContrasena(params.usuario.password);
    final usuarioContrasenaHasheada = Usuario(
      id: params.usuario.id,
      nombre: params.usuario.nombre,
      apellido: params.usuario.apellido,
      email: params.usuario.email,
      password: hashedPassword,
      telefono: params.usuario.telefono,
      direcciones: params.usuario.direcciones,
      pedidos: params.usuario.pedidos,
    );

    await _authRepository.registrarUsuario(usuarioContrasenaHasheada);
  }
}

class RegistrarUsuarioParams {
  final Usuario usuario;

  RegistrarUsuarioParams({
    required this.usuario,
  });
}
