import 'package:mi_mercado/features/repartidor/datos/domain/datasources/repartidor_datasource.dart';
import 'package:mi_mercado/features/repartidor/datos/domain/repositories/repartidor_repository.dart';
import 'package:mi_mercado/features/auth/domain/entities/Repartidor.dart';

class RepartidorRepositoryImpl implements RepartidorRepository {
  final RepartidorDataSource dataSource;

  RepartidorRepositoryImpl(this.dataSource);

  @override
  Future<Repartidor?> obtenerDatosRepartidor(String idRepartidor) async {
    return await dataSource.obtenerDatosRepartidor(idRepartidor);
  }
}