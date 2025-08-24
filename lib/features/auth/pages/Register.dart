import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/CustomTextField.dart';

class RegistroScreen extends StatelessWidget {
  const RegistroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Stack(
            children: [
              // Flecha fija
              Positioned(
                top: 10,
                left: 10,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Image.asset(
                    'lib/resources/go_back_icon.png',
                    width: 40,
                    height: 40,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Título
                      Center(
                        child: Text(
                          "Registro",
                          style: GoogleFonts.inter(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Padding específico para el formulario
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Campos de texto
                            CustomTextField(
                              label: "Nombre",
                              hint: "Ingresar Nombre",
                              primaryColor: primaryColor,
                            ),
                            const SizedBox(height: 15),
                            CustomTextField(
                              label: "Apellido",
                              hint: "Ingresar Apellido",
                              primaryColor: primaryColor,
                            ),
                            const SizedBox(height: 15),
                            CustomTextField(
                              label: "Teléfono",
                              hint: "Ingresar Teléfono",
                              primaryColor: primaryColor,
                              keyboardType: TextInputType.phone,
                            ),
                            const SizedBox(height: 15),
                            CustomTextField(
                              label: "Email",
                              hint: "Ingresar Email",
                              primaryColor: primaryColor,
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 15),
                            CustomTextField(
                              label: "Contraseña",
                              hint: "Ingresar Contraseña",
                              primaryColor: primaryColor,
                              obscureText: true,
                            ),

                            const SizedBox(height: 50),

                            // Botón Registrarse
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () {
                                  // Acción de registro
                                },
                                child: Text(
                                  "Registrarse",
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Texto de iniciar sesión
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "¿Ya tienes cuenta? Inicia Sesión ",
                                  style: GoogleFonts.inter(
                                    color: const Color(0xFF878383),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushReplacementNamed(context, '/iniciar-sesion');
                                  },
                                  child: Text(
                                    "aquí",
                                    style: GoogleFonts.inter(
                                      color: primaryColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

