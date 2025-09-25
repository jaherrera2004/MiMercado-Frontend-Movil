import 'package:flutter/material.dart';
import '../../shared/widgets/navigation/BackButton.dart';
import '../../shared/widgets/text/PageTitle.dart';
import 'widgets/widgets.dart';

class CategoriaScreen extends StatelessWidget {
  final List<Map<String, dynamic>> categorias = [
    {"img": "lib/resources/temp/lacteos_icon.png", "label": "Lácteos"},
    {"img": "lib/resources/temp/snacks_icon.png", "label": "Snacks"},
    {"img": "lib/resources/temp/bebidas_icon.png", "label": "Bebidas"},
    {"img": "lib/resources/temp/panaderia_icon.png", "label": "Panadería"},
    {"img": "lib/resources/temp/panaderia_icon.png", "label": "Panadería"},
    {"img": "lib/resources/temp/panaderia_icon.png", "label": "Panadería"},
    {"img": "lib/resources/temp/panaderia_icon.png", "label": "Panadería"},
  ];

  final List<Map<String, dynamic>> productos = [
    {
      "nombre": "Corona 6 pack",
      "precio": "18.000 \$",
      "img": "lib/resources/temp/coronitasixpack.png"
    },
    {
      "nombre": "Bimbo Pan Blanco",
      "precio": "6.000 \$",
      "img": "lib/resources/temp/panbimbo.png"
    },
    {
      "nombre": "Barilla Penne Rigate",
      "precio": "5.000 \$",
      "img": "lib/resources/temp/rigate.png"
    },
    {
      "nombre": "Chocoramo",
      "precio": "3.000 \$",
      "img": "lib/resources/temp/chocorramo.png"
    },
    {
      "nombre": "Chocoramo",
      "precio": "3.000 \$",
      "img": "lib/resources/temp/chocorramo.png"
    },
    
    {
      "nombre": "Chocoramo",
      "precio": "3.000 \$",
      "img": "lib/resources/temp/chocorramo.png"
    },
  ];

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

              // Título productos
              const PageTitle(
                title: "Categoria",
                fontSize: 24,
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 15),

              // Grid de productos
              ProductGrid(
                productos: productos,
                onAddToCart: (producto) {
                  // Lógica para agregar al carrito
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
  // Barra de navegación inferior eliminada
    );
  }
}
