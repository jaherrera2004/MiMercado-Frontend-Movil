
import 'package:mi_mercado/core/error/failure.dart';
import 'package:mi_mercado/core/useCases/use_case.dart';
import '../repositories/carrito_repository.dart';
import 'package:dartz/dartz.dart';

class IncrementarCantidadCarritoUseCase implements UseCase<Either<Failure, void>, String> {
  final CarritoRepository repository;
  IncrementarCantidadCarritoUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String idProducto) async {
    try {
      await repository.incrementarCantidad(idProducto);
      print('incrementar_cantidad.dart: cantidad incrementada ($idProducto)');
      return const Right(null);
    } catch (e) {
      print('incrementar_cantidad.dart: error al incrementar cantidad: $e');
      return Left(ServerFailure(e.toString()));
    }
  }
}
