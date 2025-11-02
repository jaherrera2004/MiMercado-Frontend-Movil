import 'package:mi_mercado/core/error/failure.dart';
import 'package:mi_mercado/core/useCases/use_case.dart';
import '../repositories/pedido_repository.dart';
import '../entities/Pedido.dart';
import 'package:dartz/dartz.dart';

class ObtenerPedidosUseCase implements UseCase<Either<Failure, List<Pedido>>, String> {
  final PedidoRepository repository;
  ObtenerPedidosUseCase(this.repository);

  @override
  Future<Either<Failure, List<Pedido>>> call(String idUsuario) async {
    try {
      final pedidos = await repository.obtenerPedidos(idUsuario);
      print('obtener_pedidos.dart: pedidos obtenidos (${pedidos.length})');
      return Right(pedidos);
    } catch (e) {
      print('obtener_pedidos.dart: error al obtener pedidos: $e');
      return Left(ServerFailure(e.toString()));
    }
  }
}