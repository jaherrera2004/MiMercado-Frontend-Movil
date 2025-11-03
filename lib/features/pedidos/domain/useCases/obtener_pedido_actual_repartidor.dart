import 'package:mi_mercado/core/error/failure.dart';
import 'package:mi_mercado/core/useCases/use_case.dart';
import '../repositories/pedido_repository.dart';
import '../entities/Pedido.dart';
import 'package:dartz/dartz.dart';

class ObtenerPedidoActualRepartidorUseCase implements UseCase<Either<Failure, Pedido?>, String> {
  final PedidoRepository repository;
  ObtenerPedidoActualRepartidorUseCase(this.repository);

  @override
  Future<Either<Failure, Pedido?>> call(String idRepartidor) async {
    try {
      final pedido = await repository.obtenerPedidoActualRepartidor(idRepartidor);
      print('obtener_pedido_actual_repartidor.dart: pedido actual obtenido para repartidor ($idRepartidor)');
      return Right(pedido);
    } catch (e) {
      print('obtener_pedido_actual_repartidor.dart: error al obtener pedido actual del repartidor: $e');
      return Left(ServerFailure(e.toString()));
    }
  }
}