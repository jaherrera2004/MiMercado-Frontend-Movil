import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../shared/widgets/text/PageTitle.dart';
import '../categoria/widgets/CategoriaSearchBar.dart';
import '../categoria/widgets/ProductGrid.dart';
import 'widgets/widgets.dart';
import '../../models/Producto.dart';
import '../../models/Categoria.dart';
import '../../models/CarritoService.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseFirestore firebase = FirebaseFirestore.instance;
  List<Categoria> categorias = [];
  List<Producto> productos = [];
  // Estado para búsqueda
  String _searchQuery = '';
  List<Producto> _productosFiltrados = [];

  @override
  void initState() {
    super.initState();
    _cargarCategorias();
    _cargarProductos();
  }

  Future<void> _cargarCategorias() async {
    try {
      // Usar el método del modelo Categoria para obtener categorías
      final List<Categoria> categoriasFirebase = await Categoria.obtenerCategorias();
      
      print('📦 Categorías cargadas en HomePage: ${categoriasFirebase.length}');
      
      // Validar que todas las categorías tengan datos válidos
      for (var cat in categoriasFirebase) {
        print('  - ID: ${cat.id}, Nombre: ${cat.nombre}, Imagen: ${cat.imagenUrl}');
      }
      
      setState(() {
        categorias = categoriasFirebase;
      });
      
    } catch (e, stackTrace) {
      print('❌ Error cargando categorías: $e');
      print('StackTrace: $stackTrace');
      // En caso de error, mantener lista vacía
      setState(() {
        categorias = [];
      });
    }
  }

  Future<void> _cargarProductos() async {
    try {
      // Usar el método del modelo Producto para obtener productos
      final List<Producto> productosFirebase = await Producto.obtenerProductos();
      
      setState(() {
        productos = productosFirebase;
      });
      // Reaplicar filtro vigente (si hay) con los datos nuevos
      _aplicarFiltro();
      
    } catch (e) {
      print('Error cargando productos: $e');
      // En caso de error, mantener lista vacía
      setState(() {
        productos = [];
      });
      _aplicarFiltro();
    }
  }

  void _aplicarFiltro() {
    final query = _searchQuery.trim().toLowerCase();
    if (query.isEmpty) {
      setState(() {
        _productosFiltrados = List<Producto>.from(productos);
      });
      return;
    }

    final filtrados = productos.where((p) {
      final nombre = p.nombre.toLowerCase();
      return nombre.contains(query);
    }).toList();

    setState(() {
      _productosFiltrados = filtrados;
    });
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
                  _searchQuery = value;
                  _aplicarFiltro();
                },
              ),
              const SizedBox(height: 15),

              // Categorías como carrusel con imágenes
              if (categorias.isNotEmpty)
                CategoriesCarousel(
                  categorias: categorias.map((categoria) {
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

              // Título productos
              const PageTitle(
                title: "Nuestros Productos",
                fontSize: 24,
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 15),

              // Grid de productos
              ProductGrid(
                productos: (_productosFiltrados.isEmpty && _searchQuery.isEmpty
                        ? productos
                        : _productosFiltrados)
                    .map((producto) => {
                  'id': producto.id, // Agregar el ID del producto
                  'nombre': producto.nombre,
                  'precio': '\$${producto.precio.toStringAsFixed(0)}',
                  'precioNumerico': producto.precio, // Agregar precio numérico
                  'img': producto.imagenUrl.isNotEmpty 
                      ? producto.imagenUrl 
                      : 'lib/resources/temp/image.png',
                  'stock': producto.stock,
                  'disponible': producto.disponible,
                }).toList(),
                onAddToCart: (producto) async {
                  // Guardar el producto en el carrito usando CarritoService
                  final carritoService = CarritoService();
                  
                  await carritoService.agregarProducto(
                    idProducto: producto['id'] as String,
                    nombre: producto['nombre'] as String,
                    precio: producto['precioNumerico'] as double,
                    imagenUrl: producto['img'] as String,
                    cantidad: 1,
                  );
                  
                  // Mostrar confirmación
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
          ),
        ),
      ),
      bottomNavigationBar: const HomeBottomNavigation(
        currentIndex: 0,
      ),
    );
  }
}
