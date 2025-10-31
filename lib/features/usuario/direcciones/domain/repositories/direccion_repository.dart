import '../entities/Direccion.dart';

abstract class DireccionRepository {
  Future<void> agregarDireccion(Direccion direccion);
  Future<List<Direccion>> obtenerDirecciones(String idUsuario);
  Future<void> editarDireccion(Direccion direccion);
  Future<void> eliminarDireccion(String id, String idUsuario);
}