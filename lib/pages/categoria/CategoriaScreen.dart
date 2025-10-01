import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../shared/widgets/navigation/BackButton.dart';
import '../../shared/widgets/text/PageTitle.dart';
import '../../models/Producto.dart';
import 'widgets/widgets.dart';

class CategoriaScreen extends StatefulWidget {
  const CategoriaScreen({super.key});

  @override
  State<CategoriaScreen> createState() => _CategoriaScreenState();
}

class _CategoriaScreenState extends State<CategoriaScreen> {
  final FirebaseFirestore firebase = FirebaseFirestore.instance;
  List<Producto> productos = [];
  bool isLoading = true;
  String categoriaId = '';
  String categoriaNombre = 'Categoría';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _obtenerArgumentos();
  }

  void _obtenerArgumentos() {
    final arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    print('📱 Argumentos recibidos: $arguments');
    
    if (arguments != null) {
      categoriaId = arguments['categoriaId'] ?? '';
      categoriaNombre = arguments['categoriaNombre'] ?? 'Categoría';
      
      print('📱 Categoria ID: $categoriaId');
      print('📱 Categoria Nombre: $categoriaNombre');
      
      _cargarProductosPorCategoria();
    } else {
      print('❌ No se recibieron argumentos');
    }
  }

  Future<void> _cargarProductosPorCategoria() async {
    if (categoriaId.isEmpty) return;

    try {
      setState(() {
        isLoading = true;
      });

      print('🔍 Buscando productos para categoría ID: $categoriaId');

      // Usar el método del modelo Producto para obtener productos por categoría
      final List<Producto> productosFirebase = await Producto.obtenerProductosPorCategoria(categoriaId);

      print('✅ Productos cargados: ${productosFirebase.length}');

      setState(() {
        productos = productosFirebase;
        isLoading = false;
      });

    } catch (e) {
      print('❌ Error cargando productos de categoría: $e');
      setState(() {
        isLoading = false;
        productos = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  // Lógica de búsqueda
                },
              ),
              const SizedBox(height: 15),

              
              const SizedBox(height: 20),

              // Título productos con nombre de categoría
              PageTitle(
                title: categoriaNombre,
                fontSize: 24,
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 15),

              // Grid de productos o estado de carga
              if (isLoading)
                const Center(
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
                )
              else if (productos.isEmpty)
                const Center(
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
                )
              else
                ProductGrid(
                  productos: productos.map((producto) => {
                    'nombre': producto.nombre,
                    'precio': '\$${producto.precio.toStringAsFixed(0)}',
                    'img': producto.imagenUrl.isNotEmpty 
                        ? producto.imagenUrl 
                        : 'lib/resources/temp/image.png',
                    'stock': producto.stock,
                    'disponible': producto.disponible,
                  }).toList(),
                  onAddToCart: (producto) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${producto["nombre"]} agregado al carrito'),
                        duration: const Duration(seconds: 2),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
  // Barra de navegación inferior eliminada
    );
  }
}
