import '../entities/Pedido.dart';

abstract class PedidoRepository {
  Future<String> agregarPedido(Pedido pedido);
  Future<List<Pedido>> obtenerPedidos(String idUsuario);
  Future<Pedido?> obtenerPedidoPorId(String id);
  Future<Pedido?> obtenerPedidoActualRepartidor(String idRepartidor);
  Future<List<Pedido>> obtenerPedidosDisponibles();
  Future<List<Pedido>> obtenerHistorialPedidos(String idRepartidor);
  Future<void> actualizarEstadoPedido(String idPedido, String nuevoEstado);
  Future<void> tomarPedido(String idPedido, String idRepartidor);
}