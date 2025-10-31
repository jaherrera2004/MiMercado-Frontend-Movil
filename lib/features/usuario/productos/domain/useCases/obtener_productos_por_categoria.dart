
import 'package:mi_mercado/core/error/failure.dart';
import 'package:mi_mercado/core/useCases/use_case.dart';
import 'package:mi_mercado/features/usuario/productos/domain/entities/Producto.dart';
import 'package:mi_mercado/features/usuario/productos/domain/repositories/producto_repository.dart';
import 'package:dartz/dartz.dart';

class ObtenerProductosPorCategoria implements UseCase<Either<Failure, List<Producto>>, String> {
	final ProductoRepository repository;

	ObtenerProductosPorCategoria(this.repository);

	@override
	Future<Either<Failure, List<Producto>>> call(String categoriaId) async {
		try {
			final productos = await repository.obtenerProductosPorCategoria(categoriaId);
			print('obtener_productos_por_categoria.dart: productos obtenidos (${productos.length}) para categoria $categoriaId');
			return Right(productos);
		} catch (e) {
			print('obtener_productos_por_categoria.dart: error al obtener productos por categoria: $e');
			return Left(ServerFailure(e.toString()));
		}
	}
}
