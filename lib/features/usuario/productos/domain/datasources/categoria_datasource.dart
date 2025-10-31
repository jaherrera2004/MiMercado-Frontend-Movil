import 'package:mi_mercado/features/usuario/productos/domain/entities/Categoria.dart';

abstract class CategoriaDataSource {
  Future<List<Categoria>> obtenerCategorias();
}