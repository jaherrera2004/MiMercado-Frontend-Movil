import 'package:mi_mercado/core/error/failure.dart';
import 'package:mi_mercado/core/useCases/use_case.dart';
import '../repositories/pedido_repository.dart';
import 'package:dartz/dartz.dart';

class ActualizarEstadoPedidoUseCase implements UseCase<Either<Failure, void>, ActualizarEstadoPedidoParams> {
  final PedidoRepository repository;
  ActualizarEstadoPedidoUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(ActualizarEstadoPedidoParams params) async {
    try {
      await repository.actualizarEstadoPedido(params.idPedido, params.nuevoEstado);
      print('actualizar_estado_pedido.dart: estado del pedido ${params.idPedido} actualizado a ${params.nuevoEstado}');
      return const Right(null);
    } catch (e) {
      print('actualizar_estado_pedido.dart: error al actualizar estado del pedido: $e');
      return Left(ServerFailure(e.toString()));
    }
  }
}

class ActualizarEstadoPedidoParams {
  final String idPedido;
  final String nuevoEstado;

  ActualizarEstadoPedidoParams({
    required this.idPedido,
    required this.nuevoEstado,
  });
}