
import 'package:mi_mercado/core/error/failure.dart';
import 'package:mi_mercado/core/useCases/use_case.dart';
import '../repositories/carrito_repository.dart';
import 'package:dartz/dartz.dart';


class SubtotalCarritoUseCase implements UseCase<Either<Failure, double>, NoParams> {
  final CarritoRepository repository;
  SubtotalCarritoUseCase(this.repository);

  @override
  Future<Either<Failure, double>> call(NoParams params) async {
    try {
      final total = repository.subtotal;
      print('calcular_subtotal.dart: subtotal calculado ($total)');
      return Right(total);
    } catch (e) {
      print('calcular_subtotal.dart: error al calcular subtotal: $e');
      return Left(ServerFailure(e.toString()));
    }
  }
}
