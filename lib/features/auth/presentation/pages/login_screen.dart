import 'package:flutter/material.dart';
import '../../../../core/widgets/text/PageTitle.dart';
import 'widgets/LoginForm.dart';
import '../../../../core/widgets/navigation/BackButton.dart';

/// Pantalla de inicio de sesión
class IniciarSesionScreen extends StatelessWidget {
  const IniciarSesionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Botón de retroceso
              Row(
                children: [
                  CustomBackButton(
                    iconPath: 'lib/resources/go_back_icon.png',
                  ),
                ],
              ),
              
              const SizedBox(height: 20),
              
              // Título de la página
              const Padding(
                padding: EdgeInsets.only(left: 20),
                child: PageTitle(
                  title: "Inicio de Sesión",
                  fontSize: 36,
                  textAlign: TextAlign.start,
                ),
              ),
              
              const SizedBox(height: 30),
              
              // Formulario de inicio de sesión
              const Expanded(
                child: LoginForm(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
