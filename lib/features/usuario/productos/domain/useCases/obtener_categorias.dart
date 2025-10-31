import 'package:mi_mercado/core/error/failure.dart';
import 'package:mi_mercado/core/useCases/use_case.dart';
import 'package:mi_mercado/features/usuario/productos/domain/entities/Categoria.dart';
import 'package:mi_mercado/features/usuario/productos/domain/repositories/categoria_repository.dart';
import 'package:dartz/dartz.dart';

class ObtenerCategorias implements UseCase<Either<Failure, List<Categoria>>, NoParams> {
  final CategoriaRepository repository;

  ObtenerCategorias(this.repository);

  @override
  Future<Either<Failure, List<Categoria>>> call(NoParams params) async {
    try {
      final categorias = await repository.obtenerCategorias();
      print('obtener_categorias.dart: categorías obtenidas (${categorias.length})');
      return Right(categorias);
    } catch (e) {
      print('obtener_categorias.dart: error al obtener categorías: $e');
      return Left(ServerFailure(e.toString()));
    }
  }
}
