import 'package:mi_mercado/core/error/failure.dart';
import 'package:mi_mercado/core/useCases/use_case.dart';
import '../repositories/direccion_repository.dart';
import '../entities/Direccion.dart';
import 'package:dartz/dartz.dart';

class EditarDireccionUseCase implements UseCase<Either<Failure, void>, Direccion> {
  final DireccionRepository repository;
  EditarDireccionUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(Direccion direccion) async {
    try {
      await repository.editarDireccion(direccion);
      print('editar_direccion.dart: dirección editada (${direccion.nombre})');
      return const Right(null);
    } catch (e) {
      print('editar_direccion.dart: error al editar dirección: $e');
      return Left(ServerFailure(e.toString()));
    }
  }
}