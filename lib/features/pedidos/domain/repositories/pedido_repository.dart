import '../entities/Pedido.dart';

abstract class PedidoRepository {
  Future<String> agregarPedido(Pedido pedido);
  Future<List<Pedido>> obtenerPedidos(String idUsuario);
  Future<Pedido?> obtenerPedidoPorId(String id);
}