import 'package:get/get.dart';
import '../controllers/homepage_controller.dart';
import 'package:mi_mercado/core/di/injection.dart';
import 'package:flutter/material.dart';
import 'package:mi_mercado/core/widgets/text/PageTitle.dart';
import 'package:mi_mercado/features/usuario/home/presentation/pages/widgets/widgets.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
  // Inyecta el controlador usando GetIt
  final controller = Get.put(getIt<HomePageController>());
    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: const HomeAppBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CategoriaSearchBar(
                  onChanged: (value) {
                    controller.searchQuery.value = value;
                    controller.aplicarFiltro();
                  },
                ),
                const SizedBox(height: 15),
                if (controller.categorias.isNotEmpty)
                  CategoriesCarousel(
                    categorias: controller.categorias.map((categoria) {
                      return {
                        'id': categoria.id,
                        'label': categoria.nombre,
                        'img': categoria.imagenUrl.isEmpty
                            ? 'lib/resources/temp/image.png'
                            : categoria.imagenUrl,
                      };
                    }).toList(),
                    onCategoryTap: (categoria) {
                      Navigator.pushNamed(
                        context,
                        '/categoria',
                        arguments: {
                          'categoriaId': categoria['id'],
                          'categoriaNombre': categoria['label'],
                        },
                      );
                    },
                  )
                else
                  const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Center(
                      child: Text('Cargando categorías...'),
                    ),
                  ),
                const SizedBox(height: 20),
                const PageTitle(
                  title: "Nuestros Productos",
                  fontSize: 24,
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 15),
                ProductGrid(
                  productos: (controller.productosFiltrados.isEmpty && controller.searchQuery.isEmpty
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
                ),
              ],
            )),
          ),
        ),
        bottomNavigationBar: const HomeBottomNavigation(
          currentIndex: 0,
        ),
      ),
    );
  }

  Future<bool> _onWillPop(BuildContext context) async {
    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¿Salir de la aplicación?'),
        content: const Text('¿Estás seguro que deseas salir?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Salir'),
          ),
        ],
      ),
    );
    return shouldExit == true;
  }
}
