import 'package:mi_mercado/core/useCases/use_case.dart';
import 'package:mi_mercado/core/utils/bcrypt_utils.dart';
import 'package:mi_mercado/core/error/failure.dart';
import 'package:mi_mercado/features/auth/domain/entities/Persona.dart';
import 'package:mi_mercado/features/auth/domain/repositories/auth_repository.dart';

class Login implements UseCase<void, LoginParams> {
  final AuthRepository _authRepository;

  Login(this._authRepository);

  @override
  Future<dynamic> call(LoginParams params) async {
    Persona? personaActual;
    if (params.rol == 'usuario') {
      personaActual = await _authRepository.obtenerUsuarioPorEmail(params.email) as Persona?;
    } else if (params.rol == 'repartidor') {
      personaActual = await _authRepository.obtenerRepartidorPorEmail(params.email) as Persona?;
    }

    if (personaActual == null) {
      throw InvalidCredentialsFailure();
    }

    if (!BcryptUtils.verificarContrasena(params.password, personaActual.password)) {
      throw InvalidCredentialsFailure();
    }

    return personaActual;
  }
}

class LoginParams {
  final String email;
  final String password;
  final String rol;

  LoginParams({required this.email, required this.password, required this.rol});
}
