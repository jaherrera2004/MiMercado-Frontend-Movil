import 'package:mi_mercado/features/usuario/productos/domain/entities/Categoria.dart';

abstract class CategoriaRepository {
  Future<List<Categoria>> obtenerCategorias();
}