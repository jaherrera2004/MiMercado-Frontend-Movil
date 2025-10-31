
import 'package:mi_mercado/core/error/failure.dart';
import 'package:mi_mercado/core/useCases/use_case.dart';
import '../repositories/carrito_repository.dart';
import 'package:dartz/dartz.dart';

class VaciarCarritoUseCase implements UseCase<Either<Failure, void>, NoParams> {
  final CarritoRepository repository;
  VaciarCarritoUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    try {
      await repository.vaciarCarrito();
      print('vaciar_carrito.dart: carrito vaciado');
      return const Right(null);
    } catch (e) {
      print('vaciar_carrito.dart: error al vaciar carrito: $e');
      return Left(ServerFailure(e.toString()));
    }
  }
}