import 'package:mi_mercado/core/error/failure.dart';
import 'package:mi_mercado/core/useCases/use_case.dart';
import '../repositories/pedido_repository.dart';
import '../entities/Pedido.dart';
import 'package:dartz/dartz.dart';

class ObtenerPedidoPorIdUseCase implements UseCase<Either<Failure, Pedido?>, String> {
  final PedidoRepository repository;
  ObtenerPedidoPorIdUseCase(this.repository);

  @override
  Future<Either<Failure, Pedido?>> call(String id) async {
    try {
      final pedido = await repository.obtenerPedidoPorId(id);
      print('obtener_pedido_por_id.dart: pedido obtenido ($id)');
      return Right(pedido);
    } catch (e) {
      print('obtener_pedido_por_id.dart: error al obtener pedido por ID: $e');
      return Left(ServerFailure(e.toString()));
    }
  }
}