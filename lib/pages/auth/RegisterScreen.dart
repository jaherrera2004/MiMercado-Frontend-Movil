import 'package:flutter/material.dart';
import '../shared/widgets/navigation/BackButton.dart';
import '../shared/widgets/text/PageTitle.dart';
import 'widgets/RegisterForm.dart';

/// Pantalla de registro de usuario
class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Stack(
            children: [
              // Botón de retroceso fijo
              Positioned(
                top: 10,
                left: 10,
                child: CustomBackButton(
                  iconPath: 'lib/resources/go_back_icon.png',
                ),
              ),
              
              // Contenido principal
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Título
                      const Center(
                        child: PageTitle(title: "Registro"),
                      ),

                      const SizedBox(height: 30),

                      // Formulario de registro
                      const RegisterForm(),
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

