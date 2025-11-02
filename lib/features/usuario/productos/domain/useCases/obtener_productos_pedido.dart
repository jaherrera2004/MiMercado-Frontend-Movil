import 'package:mi_mercado/core/error/failure.dart';
import 'package:mi_mercado/core/useCases/use_case.dart';
import 'package:mi_mercado/features/usuario/productos/domain/entities/Producto.dart';
import 'package:mi_mercado/features/usuario/productos/domain/repositories/producto_repository.dart';
import 'package:dartz/dartz.dart';

class ObtenerProductosPedido implements UseCase<Either<Failure, List<Producto>>, List<String>> {
  final ProductoRepository repository;

  ObtenerProductosPedido(this.repository);

  @override
  Future<Either<Failure, List<Producto>>> call(List<String> productoIds) async {
    try {
      final productos = await repository.obtenerProductosPorIds(productoIds);
      print('obtener_productos_pedido.dart: productos obtenidos (${productos.length}) para pedido');
      return Right(productos);
    } catch (e) {
      print('obtener_productos_pedido.dart: error al obtener productos del pedido: $e');
      return Left(ServerFailure(e.toString()));
    }
  }
}