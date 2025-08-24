import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


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
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Image.asset(
                'lib/resources/go_back_icon.png',
                height: 35,
                width: 35,
              ),
            ),
            Spacer(),
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
              TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: "Buscar...",
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide.none),
                ),
              ),
              SizedBox(height: 15),

              
              SizedBox(height: 20),

              // Título productos
              Text(
                "Categoria",
                style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 15),

              // Grid de productos
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: productos.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemBuilder: (context, index) {
                  final producto = productos[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 5,
                          spreadRadius: 1,
                        )
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Center(
                                child: Image.asset(
                                  producto["img"],
                                  height: 80,
                                ),
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: Image.asset(
                                  'lib/resources/add_icon.png', // Path to the custom add icon
                                  height: 28,
                                  width: 28,
                                ),
                              )
                            ],
                          ),
                        ),
                        Text(
                          producto["nombre"],
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 14),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 5),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(20)),
                          child: Text(
                            producto["precio"],
                            style: GoogleFonts.inter(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(height: 8),
                      ],
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
