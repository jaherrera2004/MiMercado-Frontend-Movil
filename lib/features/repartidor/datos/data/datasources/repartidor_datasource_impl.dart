import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/datasources/repartidor_datasource.dart';
import 'package:mi_mercado/features/auth/domain/entities/Repartidor.dart';

class RepartidorDataSourceImpl implements RepartidorDataSource {
  final FirebaseFirestore _firestore;
  final String _coleccionRepartidores = 'repartidores';

  RepartidorDataSourceImpl(this._firestore);

  @override
  Future<Repartidor?> obtenerDatosRepartidor(String idRepartidor) async {
    try {
      final repartidorDoc = await _firestore.collection(_coleccionRepartidores).doc(idRepartidor).get();

      if (!repartidorDoc.exists) {
        return null;
      }

      final repartidorData = repartidorDoc.data() as Map<String, dynamic>;

      final repartidor = Repartidor.fromMap({
        'id': repartidorDoc.id,
        ...repartidorData,
      });

      print('repartidor_datasource_impl.dart: repartidor obtenido (${repartidor.nombre})');
      return repartidor;
    } catch (e) {
      print('repartidor_datasource_impl.dart: error al obtener repartidor: $e');
      throw Exception('Error al obtener repartidor: $e');
    }
  }
}