import 'package:mi_mercado/core/error/failure.dart';
import 'package:mi_mercado/core/useCases/use_case.dart';
import '../repositories/pedido_repository.dart';
import '../entities/Pedido.dart';
import 'package:dartz/dartz.dart';

class AgregarPedidoUseCase implements UseCase<Either<Failure, void>, Pedido> {
  final PedidoRepository repository;
  AgregarPedidoUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(Pedido pedido) async {
    try {
      await repository.agregarPedido(pedido);
      print('agregar_pedido.dart: pedido agregado (${pedido.id})');
      return const Right(null);
    } catch (e) {
      print('agregar_pedido.dart: error al agregar pedido: $e');
      return Left(ServerFailure(e.toString()));
    }
  }
}