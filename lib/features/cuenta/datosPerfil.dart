import 'package:flutter/material.dart';
import 'widgets/camposDatos.dart';

class DatosScreen extends StatelessWidget {
  const DatosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Image.asset(
            'lib/resources/go_back_icon.png',
            width: 40,
            height: 40,
          ),
        ),
        title: const Text(
          "Datos",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: ListView(
          children: const [
            SizedBox(height: 50), // 👈 espacio debajo del AppBar
            CamposDatos(dato: "Nombre"),
            Divider(),
            CamposDatos(dato: "Apellido"),
            Divider(),
            CamposDatos(dato: "Telefono"),
            Divider(),
            CamposDatos(dato: "Email"),
            Divider(),
          ],
        ),
      ),
    );
  }
}
