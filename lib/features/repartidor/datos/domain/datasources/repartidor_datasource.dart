import 'package:mi_mercado/features/auth/domain/entities/Repartidor.dart';

abstract class RepartidorDataSource {
  Future<Repartidor?> obtenerDatosRepartidor(String idRepartidor);
}