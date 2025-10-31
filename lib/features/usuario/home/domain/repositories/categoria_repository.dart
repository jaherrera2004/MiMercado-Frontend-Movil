import 'package:mi_mercado/features/usuario/home/domain/entities/Categoria.dart';

abstract class CategoriaRepository {
  Future<List<Categoria>> obtenerCategorias();
}