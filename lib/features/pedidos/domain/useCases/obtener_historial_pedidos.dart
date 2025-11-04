import 'package:mi_mercado/core/error/failure.dart';
import 'package:mi_mercado/core/useCases/use_case.dart';
import '../repositories/pedido_repository.dart';
import '../entities/Pedido.dart';
import 'package:dartz/dartz.dart';

class ObtenerHistorialPedidosUseCase implements UseCase<Either<Failure, List<Pedido>>, String> {
  final PedidoRepository repository;
  ObtenerHistorialPedidosUseCase(this.repository);

  @override
  Future<Either<Failure, List<Pedido>>> call(String idRepartidor) async {
    try {
      final pedidos = await repository.obtenerHistorialPedidos(idRepartidor);
      print('obtener_historial_pedidos.dart: historial de pedidos obtenido para repartidor $idRepartidor (${pedidos.length} pedidos)');
      return Right(pedidos);
    } catch (e) {
      print('obtener_historial_pedidos.dart: error al obtener historial de pedidos: $e');
      return Left(ServerFailure(e.toString()));
    }
  }
}