import 'package:mi_mercado/features/usuario/home/domain/entities/Categoria.dart';

abstract class CategoriaDataSource {
  Future<List<Categoria>> obtenerCategorias();
}