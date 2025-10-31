
import 'package:mi_mercado/core/error/failure.dart';
import 'package:mi_mercado/core/useCases/use_case.dart';
import '../repositories/carrito_repository.dart';
import '../entities/CarritoItem.dart';
import 'package:dartz/dartz.dart';

class ObtenerItemsCarritoUseCase implements UseCase<Either<Failure, List<CarritoItem>>, NoParams> {
  final CarritoRepository repository;
  ObtenerItemsCarritoUseCase(this.repository);

  @override
  Future<Either<Failure, List<CarritoItem>>> call(NoParams params) async {
    try {
      final items = repository.obtenerItems();
      print('obtener_items_carrito.dart: items obtenidos (${items.length})');
      return Right(items);
    } catch (e) {
      print('obtener_items_carrito.dart: error al obtener items: $e');
      return Left(ServerFailure(e.toString()));
    }
  }
}