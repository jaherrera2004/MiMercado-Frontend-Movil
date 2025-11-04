import 'package:mi_mercado/core/error/failure.dart';
import 'package:mi_mercado/core/useCases/use_case.dart';
import 'package:mi_mercado/features/repartidor/datos/domain/repositories/repartidor_repository.dart';
import 'package:mi_mercado/features/auth/domain/entities/Repartidor.dart';
import 'package:dartz/dartz.dart';

class ObtenerDatosRepartidorUseCase implements UseCase<Either<Failure, Repartidor?>, String> {
  final RepartidorRepository repository;

  ObtenerDatosRepartidorUseCase(this.repository);

  @override
  Future<Either<Failure, Repartidor?>> call(String idRepartidor) async {
    try {
      final repartidor = await repository.obtenerDatosRepartidor(idRepartidor);
      return Right(repartidor);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}