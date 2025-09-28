import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../shared/widgets/navigation/BackButton.dart';
import '../../shared/widgets/text/PageTitle.dart';
import 'widgets/widgets.dart';

class CategoriaScreen extends StatefulWidget {
  const CategoriaScreen({super.key});

  @override
  State<CategoriaScreen> createState() => _CategoriaScreenState();
}

class _CategoriaScreenState extends State<CategoriaScreen> {
  final FirebaseFirestore firebase = FirebaseFirestore.instance;
  List<Map<String, dynamic>> productos = [];
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

      // Buscar productos solo por ID (sin referencia)
      final QuerySnapshot snapshot = await firebase
          .collection('productos')
          .where('id_categoria', isEqualTo: categoriaId)
          .get();

      print('🔍 Productos encontrados: ${snapshot.docs.length}');

      // Si no encontramos productos, hagamos una consulta de debug
      if (snapshot.docs.isEmpty) {
        print('⚠️ No se encontraron productos. Haciendo consulta de debug...');
        final allProductsSnapshot = await firebase.collection('productos').get();
        print('📊 Total productos en BD: ${allProductsSnapshot.docs.length}');
        
        for (var doc in allProductsSnapshot.docs) {
          final data = doc.data() as Map<String, dynamic>;
          print('🔍 Producto: ${data['nombre']} - id_categoria: ${data['id_categoria']}');
        }
      }

      final List<Map<String, dynamic>> productosFirebase = [];

      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        print('✅ Producto encontrado: ${data['nombre']} - ${data['id_categoria']}');
        
        productosFirebase.add({
          'id': doc.id,
          'nombre': data['nombre'] ?? 'Producto sin nombre',
          'precio': '${data['precio'] ?? 0} \$',
          'img': 'lib/resources/temp/image.png', // Usar imagen fija
          'categoria': data['id_categoria'] ?? '',
        });
      }

      setState(() {
        productos = productosFirebase;
        isLoading = false;
      });

    } catch (e) {
      print('Error cargando productos de categoría: $e');
      setState(() {
        isLoading = false;
        // Productos de ejemplo en caso de error
        productos = [
          {
            "id": "ejemplo1",
            "nombre": "Producto de ejemplo",
            "precio": "5.000 \$",
            "img": "lib/resources/temp/image.png"
          },
        ];
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
                  productos: productos,
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
