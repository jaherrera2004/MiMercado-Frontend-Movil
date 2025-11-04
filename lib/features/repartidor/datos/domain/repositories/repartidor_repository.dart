import 'package:mi_mercado/features/auth/domain/entities/Repartidor.dart';

abstract class RepartidorRepository {
  Future<Repartidor?> obtenerDatosRepartidor(String idRepartidor);
}