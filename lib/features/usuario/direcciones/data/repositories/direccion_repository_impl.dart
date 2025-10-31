import '../../domain/entities/Direccion.dart';
import '../../domain/datasources/direccion_datasource.dart';
import '../../domain/repositories/direccion_repository.dart';

class DireccionRepositoryImpl implements DireccionRepository {
  final DireccionDataSource dataSource;

  DireccionRepositoryImpl(this.dataSource);

  @override
  Future<void> agregarDireccion(Direccion direccion) {
    print('direccion_repository_impl.dart: agregarDireccion (${direccion.nombre})');
    return dataSource.agregarDireccion(direccion);
  }

  @override
  Future<List<Direccion>> obtenerDirecciones(String idUsuario) {
    print('direccion_repository_impl.dart: obtenerDirecciones');
    return dataSource.obtenerDirecciones(idUsuario);
  }

  @override
  Future<void> editarDireccion(Direccion direccion) {
    print('direccion_repository_impl.dart: editarDireccion (${direccion.nombre})');
    return dataSource.editarDireccion(direccion);
  }

  @override
  Future<void> eliminarDireccion(String id, String idUsuario) {
    print('direccion_repository_impl.dart: eliminarDireccion ($id)');
    return dataSource.eliminarDireccion(id, idUsuario);
  }
}