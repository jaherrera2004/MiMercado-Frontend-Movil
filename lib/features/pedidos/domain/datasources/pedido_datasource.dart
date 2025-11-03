
import '../entities/Pedido.dart';

abstract class PedidoDataSource {
  Future<String> agregarPedido(Pedido pedido);
  Future<List<Pedido>> obtenerPedidos(String idUsuario);
  Future<Pedido?> obtenerPedidoPorId(String id);
  Future<Pedido?> obtenerPedidoActualRepartidor(String idRepartidor);
  Future<List<Pedido>> obtenerPedidosDisponibles();
}