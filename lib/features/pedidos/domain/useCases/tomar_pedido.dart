import 'package:mi_mercado/core/error/failure.dart';
import 'package:mi_mercado/core/useCases/use_case.dart';
import '../repositories/pedido_repository.dart';
import 'package:dartz/dartz.dart';

class TomarPedidoUseCase implements UseCase<Either<Failure, void>, TomarPedidoParams> {
  final PedidoRepository repository;
  TomarPedidoUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(TomarPedidoParams params) async {
    try {
      await repository.tomarPedido(params.idPedido, params.idRepartidor);
      print('tomar_pedido.dart: pedido ${params.idPedido} asignado al repartidor ${params.idRepartidor}');
      return const Right(null);
    } catch (e) {
      print('tomar_pedido.dart: error al asignar pedido: $e');
      return Left(ServerFailure(e.toString()));
    }
  }
}

class TomarPedidoParams {
  final String idPedido;
  final String idRepartidor;

  TomarPedidoParams({
    required this.idPedido,
    required this.idRepartidor,
  });
}