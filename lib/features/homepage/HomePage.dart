import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class HomePage extends StatelessWidget {
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
      appBar: AppBar(
        automaticallyImplyLeading: false, // Removed the back arrow
        elevation: 0,
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Image.asset(
              'lib/resources/address_icon.png', // Path to the custom location icon
              height: 40,
              width: 40,
            ),
            SizedBox(width: 10), // Increased spacing between the icon and 'Dirección'
            Text(
              "Dirección",
              style: GoogleFonts.inter(
                color: Colors.black,
                fontWeight: FontWeight.bold, // Made the text bold
              ),
            ),
            Spacer(),
          ],
        ),
        actions: [
          IconButton(
            icon: Image.asset(
              'lib/resources/carrito_icon.png',
              height: 40,
              width: 40,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/carrito');
            },
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

              // Categorías como carrusel con imágenes
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: categorias
                      .map((cat) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/categoria'); // Navigate to CategoriaScreen
                              },
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.grey[200],
                                    radius: 30,
                                    backgroundImage: AssetImage(cat["img"]),
                                  ),
                                  SizedBox(height: 5),
                                  Text(cat["label"]),
                                ],
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ),
              SizedBox(height: 20),

              // Título productos
              Text(
                "Nuestros Productos",
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
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.black,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Inicio"),
          BottomNavigationBarItem(
              icon: Icon(Icons.location_on), label: "Direcciones"),
          BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long), label: "Pedidos"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Cuenta"),
        ],
      ),
    );
  }
}
