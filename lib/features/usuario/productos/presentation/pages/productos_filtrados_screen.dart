import 'package:flutter/material.dart';
import 'package:mi_mercado/core/di/injection.dart';
import 'package:mi_mercado/features/usuario/productos/domain/useCases/obtener_productos_por_categoria.dart';
import 'package:get/get.dart';
import 'package:mi_mercado/core/widgets/navigation/BackButton.dart';
import 'package:mi_mercado/core/widgets/text/PageTitle.dart';
import '../controllers/productos_filtrados_controller.dart';
import 'widgets/widgets.dart';

class CategoriaScreen extends StatelessWidget {
  const CategoriaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductosFiltradosController(
      obtenerProductosPorCategoria: getIt<ObtenerProductosPorCategoria>(),
    ));

    // Obtener argumentos y cargar productos
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (arguments != null) {
        final categoriaId = arguments['categoriaId'] ?? '';
        final categoriaNombre = arguments['categoriaNombre'] ?? 'Categoría';
        controller.setCategoriaNombre(categoriaNombre);
        controller.cargarProductosPorCategoria(categoriaId);
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            CustomBackButton(
              iconPath: 'lib/resources/go_back_icon.png',
              size: 35,
            ),
            const Spacer(),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: IconButton(
              icon: Image.asset(
                'lib/resources/carrito_icon.png',
                height: 40,
                width: 40,
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/carrito');
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0), // Further increased horizontal padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Barra de búsqueda
              CategoriaSearchBar(
                onChanged: (value) {
                  controller.setSearchQuery(value);
                },
              ),
              const SizedBox(height: 15),
              const SizedBox(height: 20),
              Obx(() => PageTitle(
                title: controller.categoriaNombre.value,
                fontSize: 24,
                textAlign: TextAlign.left,
              )),
              const SizedBox(height: 15),
              Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(50),
                      child: Column(
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text('Cargando productos...'),
                        ],
                      ),
                    ),
                  );
                } else if (controller.productos.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(50),
                      child: Column(
                        children: [
                          Icon(Icons.shopping_basket_outlined, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            'No hay productos en esta categoría',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return ProductGrid(
                    productos: (controller.productosFiltrados.isEmpty && controller.searchQuery.value.isEmpty
                            ? controller.productos
                            : controller.productosFiltrados)
                        .map((producto) => {
                      'id': producto.id,
                      'nombre': producto.nombre,
                      'precio': '\$${producto.precio.toStringAsFixed(1)}',
                      'precioNumerico': producto.precio,
                      'img': producto.imagenUrl.isNotEmpty 
                          ? producto.imagenUrl 
                          : 'lib/resources/temp/image.png',
                    }).toList(),
                    onAddToCart: (producto) async {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${producto["nombre"]} agregado al carrito'),
                            duration: const Duration(seconds: 2),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    },
                  );
                }
              }),
            ],
          ),
        ),
      ),
  // Barra de navegación inferior eliminada
    );
  }
}
