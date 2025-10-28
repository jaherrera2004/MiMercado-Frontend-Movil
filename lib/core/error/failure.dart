abstract class Failure {
  final String message;

  Failure(this.message);
}

class ServerFailure extends Failure {
  ServerFailure(String message) : super(message);
}

class CacheFailure extends Failure {
  CacheFailure(String message) : super(message);
}

class InvalidCredentialsFailure extends Failure {
  InvalidCredentialsFailure() : super('Email o contraseña incorrectos');
}
  
class InvalidEmailFailure extends Failure {
  InvalidEmailFailure() : super('Email no válido');
}

class InvalidPhoneFailure extends Failure {
  InvalidPhoneFailure() : super('Ingresa un teléfono válido (8-15 dígitos)');
}

class InvalidPasswordFailure extends Failure {
  InvalidPasswordFailure() : super('Contraseña no válida');
}
