import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mi_mercado/features/auth/widgets/CustomTextField.dart'; // 👈 importa tu widget

class EditarSeguridadScreen extends StatelessWidget {
  const EditarSeguridadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF58E181);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Image.asset(
          'lib/resources/go_back_icon.png',
          width: 40,
          height: 40,
        ),
        title: const Text(
          "Seguridad",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: ListView(
          children: [
            const SizedBox(height: 40),
            const CustomTextField(
              label: "Contraseña Actual",
              hint: "Ingresar contraseña",
              primaryColor: primaryColor,
            ),
            const SizedBox(height: 20),
            const CustomTextField(
              label: "Nueva Contraseña",
              hint: "Ingresar nueva contraseña",
              primaryColor: primaryColor,
            ),
            const SizedBox(height: 20),
            const CustomTextField(
              label: "Confirmar Nueva Contraseña",
              hint: "Confirmar nueva contraseña",
              primaryColor: primaryColor,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),
            const SizedBox(height: 40),

            // ✅ Botón Guardar cambios
            ElevatedButton(
              onPressed: () {
                // Aquí va la lógica para guardar cambios
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF58E181), // verde
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "Cambiar contraseña",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 15),

            // ✅ Botón Cancelar (rojo)
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // vuelve atrás
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEE6565), // rojo
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "Cancelar",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
