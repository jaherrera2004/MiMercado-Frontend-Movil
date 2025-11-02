import '../entities/Pedido.dart';

abstract class PedidoRepository {
  Future<void> agregarPedido(Pedido pedido);
  Future<List<Pedido>> obtenerPedidos(String idUsuario);
  Future<Pedido?> obtenerPedidoPorId(String id);
}