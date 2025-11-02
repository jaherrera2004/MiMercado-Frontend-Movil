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
}