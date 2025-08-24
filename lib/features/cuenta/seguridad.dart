import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'widgets/camposDatos.dart';

class PasswordScreen extends StatelessWidget {
  const PasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
        title: Text(
          "Seguridad",
          style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: ListView(
          children: [
            const SizedBox(height: 50), // espacio debajo del AppBar
            const CamposDatos(dato: "Contraseña"),
            const Divider(),
            const SizedBox(height: 30), // separación antes del botón
            // 👇 Botón cambiar contraseña
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/editar-seguridad');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(
                  0xFF58E181,
                ), // ✅ tu color personalizado
                foregroundColor: Colors.white, // color del texto
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // bordes redondeados
                ),
              ),
              child: Text(
                "Cambiar contraseña",
                style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
