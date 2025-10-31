import 'package:mi_mercado/features/usuario/home/domain/entities/Producto.dart';

abstract class ProductoDataSource {
  Future<List<Producto>> obtenerProductos();
}
