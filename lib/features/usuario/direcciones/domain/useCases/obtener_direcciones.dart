import 'package:mi_mercado/core/error/failure.dart';
import 'package:mi_mercado/core/useCases/use_case.dart';
import '../repositories/direccion_repository.dart';
import '../entities/Direccion.dart';
import 'package:dartz/dartz.dart';

class ObtenerDireccionesUseCase implements UseCase<Either<Failure, List<Direccion>>, String> {
  final DireccionRepository repository;
  ObtenerDireccionesUseCase(this.repository);

  @override
  Future<Either<Failure, List<Direccion>>> call(String idUsuario) async {
    try {
      final direcciones = await repository.obtenerDirecciones(idUsuario);
      print('obtener_direcciones.dart: direcciones obtenidas (${direcciones.length})');
      return Right(direcciones);
    } catch (e) {
      print('obtener_direcciones.dart: error al obtener direcciones: $e');
      return Left(ServerFailure(e.toString()));
    }
  }
}