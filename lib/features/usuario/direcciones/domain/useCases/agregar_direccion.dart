import 'package:mi_mercado/core/error/failure.dart';
import 'package:mi_mercado/core/useCases/use_case.dart';
import '../repositories/direccion_repository.dart';
import '../entities/Direccion.dart';
import 'package:dartz/dartz.dart';

class AgregarDireccionUseCase implements UseCase<Either<Failure, void>, Direccion> {
  final DireccionRepository repository;
  AgregarDireccionUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(Direccion direccion) async {
    try {
      await repository.agregarDireccion(direccion);
      print('agregar_direccion.dart: dirección agregada (${direccion.nombre})');
      return const Right(null);
    } catch (e) {
      print('agregar_direccion.dart: error al agregar dirección: $e');
      return Left(ServerFailure(e.toString()));
    }
  }
}