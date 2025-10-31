
import 'package:mi_mercado/core/error/failure.dart';
import 'package:mi_mercado/core/useCases/use_case.dart';
import '../repositories/carrito_repository.dart';
import '../entities/CarritoItem.dart';
import 'package:dartz/dartz.dart';

class AgregarProductoCarritoUseCase implements UseCase<Either<Failure, void>, CarritoItem> {
  final CarritoRepository repository;
  AgregarProductoCarritoUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(CarritoItem item) async {
    try {
      await repository.agregarProducto(item);
      print('agregar_producto_carrito.dart: producto agregado (${item.nombre})');
      return const Right(null);
    } catch (e) {
      print('agregar_producto_carrito.dart: error al agregar producto: $e');
      return Left(ServerFailure(e.toString()));
    }
  }
}