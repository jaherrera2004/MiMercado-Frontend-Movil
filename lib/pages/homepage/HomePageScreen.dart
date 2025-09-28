import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../shared/widgets/text/PageTitle.dart';
import '../categoria/widgets/CategoriaSearchBar.dart';
import '../categoria/widgets/ProductGrid.dart';
import 'widgets/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseFirestore firebase = FirebaseFirestore.instance;
  List<Map<String, dynamic>> categorias = [];
  List<Map<String, dynamic>> productos = [];

  @override
  void initState() {
    super.initState();
    _cargarCategorias();
    _cargarProductos();
  }

  Future<void> _cargarCategorias() async {
    try {
      final QuerySnapshot snapshot = await firebase.collection('categorias').get();
      
      final List<Map<String, dynamic>> categoriasFirebase = [];
      
      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        categoriasFirebase.add({
          'label': data['nombre'] ?? 'Categoría sin nombre',
          'img': "lib/resources/temp/image.png", // imagen por defecto
        });
      }
      
      setState(() {
        categorias = categoriasFirebase;
      });
      
    } catch (e) {
      print('Error cargando categorías: $e');
      // Mantener categorías de ejemplo si hay error
      setState(() {
        categorias = [
          {"img": "lib/resources/temp/lacteos_icon.png", "label": "Lácteos"},
          {"img": "lib/resources/temp/snacks_icon.png", "label": "Snacks"},
          {"img": "lib/resources/temp/bebidas_icon.png", "label": "Bebidas"},
          {"img": "lib/resources/temp/panaderia_icon.png", "label": "Panadería"},
        ];
      });
    }
  }

  Future<void> _cargarProductos() async {
    try {
      final QuerySnapshot snapshot = await firebase.collection('productos').get();
      
      final List<Map<String, dynamic>> productosFirebase = [];
      
      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        productosFirebase.add({
          'nombre': data['nombre'] ?? 'Producto sin nombre',
          'precio': '${data['precio'] ?? 0} \$',
          'img': 'lib/resources/temp/image.png', // Usar imagen que sabemos que funciona
        });
      }
      
      setState(() {
        productos = productosFirebase;
      });
      
    } catch (e) {
      print('Error cargando productos: $e');
      // Mantener productos de ejemplo si hay error
      setState(() {
        productos = [
          {
            "nombre": "Producto de ejemplo",
            "precio": "5.000 \$",
            "img": "lib/resources/image.png"
          },
        ];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
  // int currentIndex = 0; // Eliminado porque no se usa
  return Scaffold(
      backgroundColor: Colors.white,
      appBar: const HomeAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0), // Further increased horizontal padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Barra de búsqueda
              CategoriaSearchBar(
                onChanged: (value) {
                  // Lógica de búsqueda en home
                },
              ),
              const SizedBox(height: 15),

              // Categorías como carrusel con imágenes
              CategoriesCarousel(
                categorias: categorias,
                onCategoryTap: (categoria) {
                  Navigator.pushNamed(context, '/categoria');
                },
              ),
              const SizedBox(height: 20),

              // Título productos
              const PageTitle(
                title: "Nuestros Productos",
                fontSize: 24,
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 15),

              // Grid de productos
              ProductGrid(
                productos: productos,
                onAddToCart: (producto) {
                  // Lógica para agregar al carrito desde home
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${producto["nombre"]} agregado al carrito'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const HomeBottomNavigation(
        currentIndex: 0,
      ),
    );
  }
}
