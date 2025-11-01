import 'package:mi_mercado/core/error/failure.dart';
import 'package:mi_mercado/core/useCases/use_case.dart';
import '../repositories/usuario_repository.dart';
import 'package:mi_mercado/features/auth/domain/entities/Usuario.dart';
import 'package:dartz/dartz.dart';

class ObtenerUsuarioPorIdUseCase implements UseCase<Either<Failure, Usuario?>, String> {
  final UsuarioRepository repository;
  ObtenerUsuarioPorIdUseCase(this.repository);

  @override
  Future<Either<Failure, Usuario?>> call(String id) async {
    try {
      final usuario = await repository.obtenerUsuarioPorId(id);
      print('obtener_usuario_por_id.dart: usuario obtenido (${usuario?.nombre ?? "null"})');
      return Right(usuario);
    } catch (e) {
      print('obtener_usuario_por_id.dart: error al obtener usuario: $e');
      return Left(ServerFailure(e.toString()));
    }
  }
}