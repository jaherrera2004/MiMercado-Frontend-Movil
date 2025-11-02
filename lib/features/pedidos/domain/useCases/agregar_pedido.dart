import 'package:mi_mercado/core/error/failure.dart';
import 'package:mi_mercado/core/useCases/use_case.dart';
import '../repositories/pedido_repository.dart';
import '../entities/Pedido.dart';
import 'package:dartz/dartz.dart';

class AgregarPedidoUseCase implements UseCase<Either<Failure, String>, Pedido> {
  final PedidoRepository repository;
  AgregarPedidoUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(Pedido pedido) async {
    try {
      final pedidoId = await repository.agregarPedido(pedido);
      print('agregar_pedido.dart: pedido agregado ($pedidoId)');
      return Right(pedidoId);
    } catch (e) {
      print('agregar_pedido.dart: error al agregar pedido: $e');
      return Left(ServerFailure(e.toString()));
    }
  }
}