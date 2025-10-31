import 'package:mi_mercado/features/usuario/productos/domain/entities/Producto.dart';

abstract class ProductoRepository {
  Future<List<Producto>> obtenerProductos();
  Future<List<Producto>> obtenerProductosPorCategoria(String categoriaId);
}