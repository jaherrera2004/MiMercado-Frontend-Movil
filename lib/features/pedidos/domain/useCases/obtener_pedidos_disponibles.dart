import 'package:mi_mercado/core/error/failure.dart';
import 'package:mi_mercado/core/useCases/use_case.dart';
import '../repositories/pedido_repository.dart';
import '../entities/Pedido.dart';
import 'package:dartz/dartz.dart';

class ObtenerPedidosDisponiblesUseCase implements UseCase<Either<Failure, List<Pedido>>, void> {
  final PedidoRepository repository;
  ObtenerPedidosDisponiblesUseCase(this.repository);

  @override
  Future<Either<Failure, List<Pedido>>> call(void params) async {
    try {
      final pedidos = await repository.obtenerPedidosDisponibles();
      print('obtener_pedidos_disponibles.dart: pedidos disponibles obtenidos (${pedidos.length})');
      return Right(pedidos);
    } catch (e) {
      print('obtener_pedidos_disponibles.dart: error al obtener pedidos disponibles: $e');
      return Left(ServerFailure(e.toString()));
    }
  }
}