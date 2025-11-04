import '../../domain/entities/Pedido.dart';
import '../../domain/datasources/pedido_datasource.dart';
import '../../domain/repositories/pedido_repository.dart';

class PedidoRepositoryImpl implements PedidoRepository {
  final PedidoDataSource dataSource;

  PedidoRepositoryImpl(this.dataSource);

  @override
  Future<String> agregarPedido(Pedido pedido) {
    print('pedido_repository_impl.dart: agregarPedido');
    return dataSource.agregarPedido(pedido);
  }

  @override
  Future<List<Pedido>> obtenerPedidos(String idUsuario) {
    print('pedido_repository_impl.dart: obtenerPedidos');
    return dataSource.obtenerPedidos(idUsuario);
  }

  @override
  Future<Pedido?> obtenerPedidoPorId(String id) {
    print('pedido_repository_impl.dart: obtenerPedidoPorId ($id)');
    return dataSource.obtenerPedidoPorId(id);
  }

  @override
  Future<Pedido?> obtenerPedidoActualRepartidor(String idRepartidor) {
    print('pedido_repository_impl.dart: obtenerPedidoActualRepartidor ($idRepartidor)');
    return dataSource.obtenerPedidoActualRepartidor(idRepartidor);
  }

  @override
  Future<List<Pedido>> obtenerPedidosDisponibles() {
    print('pedido_repository_impl.dart: obtenerPedidosDisponibles');
    return dataSource.obtenerPedidosDisponibles();
  }

  @override
  Future<List<Pedido>> obtenerHistorialPedidos(String idRepartidor) {
    print('pedido_repository_impl.dart: obtenerHistorialPedidos ($idRepartidor)');
    return dataSource.obtenerHistorialPedidos(idRepartidor);
  }

  @override
  Future<void> actualizarEstadoPedido(String idPedido, String nuevoEstado) {
    print('pedido_repository_impl.dart: actualizarEstadoPedido ($idPedido, $nuevoEstado)');
    return dataSource.actualizarEstadoPedido(idPedido, nuevoEstado);
  }

  @override
  Future<void> tomarPedido(String idPedido, String idRepartidor) {
    print('pedido_repository_impl.dart: tomarPedido ($idPedido, $idRepartidor)');
    return dataSource.tomarPedido(idPedido, idRepartidor);
  }
}