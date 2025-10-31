
import 'package:mi_mercado/core/error/failure.dart';
import 'package:mi_mercado/core/useCases/use_case.dart';
import '../repositories/carrito_repository.dart';
import 'package:dartz/dartz.dart';

class DecrementarCantidadCarritoUseCase implements UseCase<Either<Failure, void>, String> {
  final CarritoRepository repository;
  DecrementarCantidadCarritoUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String idProducto) async {
    try {
      await repository.decrementarCantidad(idProducto);
      print('decrementar_cantidad.dart: cantidad decrementada ($idProducto)');
      return const Right(null);
    } catch (e) {
      print('decrementar_cantidad.dart: error al decrementar cantidad: $e');
      return Left(ServerFailure(e.toString()));
    }
  }
}