import 'package:mi_mercado/core/error/failure.dart';
import 'package:mi_mercado/core/useCases/use_case.dart';
import '../repositories/usuario_repository.dart';
import 'package:mi_mercado/features/auth/domain/entities/Usuario.dart';
import 'package:dartz/dartz.dart';

class EditarUsuarioUseCase implements UseCase<Either<Failure, void>, Usuario> {
  final UsuarioRepository repository;
  EditarUsuarioUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(Usuario usuario) async {
    try {
      await repository.editarUsuario(usuario);
      print('editar_usuario.dart: usuario editado (${usuario.nombre})');
      return const Right(null);
    } catch (e) {
      print('editar_usuario.dart: error al editar usuario: $e');
      return Left(ServerFailure(e.toString()));
    }
  }
}