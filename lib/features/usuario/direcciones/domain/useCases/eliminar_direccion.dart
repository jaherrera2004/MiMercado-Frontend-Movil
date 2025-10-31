import 'package:mi_mercado/core/error/failure.dart';
import 'package:mi_mercado/core/useCases/use_case.dart';
import '../repositories/direccion_repository.dart';
import 'package:dartz/dartz.dart';

class EliminarDireccionUseCase implements UseCase<Either<Failure, void>, EliminarDireccionParams> {
  final DireccionRepository repository;
  EliminarDireccionUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(EliminarDireccionParams params) async {
    try {
      await repository.eliminarDireccion(params.id, params.idUsuario);
      print('eliminar_direccion.dart: dirección eliminada (${params.id})');
      return const Right(null);
    } catch (e) {
      print('eliminar_direccion.dart: error al eliminar dirección: $e');
      return Left(ServerFailure(e.toString()));
    }
  }
}

class EliminarDireccionParams {
  final String id;
  final String idUsuario;

  EliminarDireccionParams({required this.id, required this.idUsuario});
}