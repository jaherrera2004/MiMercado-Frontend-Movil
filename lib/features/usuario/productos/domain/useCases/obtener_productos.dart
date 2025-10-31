import 'package:mi_mercado/core/error/failure.dart';
import 'package:mi_mercado/core/useCases/use_case.dart';
import 'package:mi_mercado/features/usuario/productos/domain/entities/Producto.dart';
import 'package:mi_mercado/features/usuario/productos/domain/repositories/producto_repository.dart';
import 'package:dartz/dartz.dart'; // Either


class ObtenerProductos implements UseCase<Either<Failure, List<Producto>>, NoParams> {
  final ProductoRepository repository;

  ObtenerProductos(this.repository);

  @override
  Future<Either<Failure, List<Producto>>> call(NoParams params) async {
    try {
      final productos = await repository.obtenerProductos();
      print('obtener_productos.dart: productos obtenidos (${productos.length})');
      return Right(productos);
    } catch (e) {
      print('obtener_productos.dart: error al obtener productos: $e');
      return Left(ServerFailure(e.toString()));
    }
  }
}
