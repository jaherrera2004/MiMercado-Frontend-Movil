
import 'package:mi_mercado/core/error/failure.dart';
import 'package:mi_mercado/core/useCases/use_case.dart';
import '../repositories/carrito_repository.dart';
import 'package:dartz/dartz.dart';

class EliminarProductoCarritoUseCase implements UseCase<Either<Failure, void>, String> {
  final CarritoRepository repository;
  EliminarProductoCarritoUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String idProducto) async {
    try {
      await repository.eliminarProducto(idProducto);
      print('eliminar_producto_carrito.dart: producto eliminado ($idProducto)');
      return const Right(null);
    } catch (e) {
      print('eliminar_producto_carrito.dart: error al eliminar producto: $e');
      return Left(ServerFailure(e.toString()));
    }
  }
}
