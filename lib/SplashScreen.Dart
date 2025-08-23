import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Espacio superior para imágenes decorativas
            Container(
              height: 480,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/homescreen_background_image.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Espacio para que quede centrado el logo
            Spacer(),

            // Botones
            Padding(
              padding: const EdgeInsets.only(bottom: 50.0),
              child: Column(
                children: [
                  SizedBox(
                    width: 250,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF58E181),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        // Acción Iniciar sesión
                      },
                      child: Text(
                        "Iniciar sesión",
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w600, // SemiBold
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: 250,
                    height: 50,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Color(0xFF58E181), width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        // Acción Registrarse
                      },
                      child: Text(
                        "Regístrate",
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w600, // SemiBold
                          color: Color(0xFF58E181),
                        ),
                      ), 
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
