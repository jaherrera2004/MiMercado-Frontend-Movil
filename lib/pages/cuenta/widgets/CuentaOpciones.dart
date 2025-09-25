import 'package:flutter/material.dart';
import 'opcion.dart';

/// Widget que contiene todas las opciones del menú de cuenta
class CuentaOpciones extends StatelessWidget {
  const CuentaOpciones({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Información personal
        Opcion(
          nombre: "Información personal",
          iconPath: "lib/resources/cedula.png",
          onTap: () {
            Navigator.pushNamed(context, '/datos-perfil');
          },
        ),
        
        // Seguridad
        Opcion(
          nombre: "Seguridad",
          iconPath: "lib/resources/seguridad.png",
          onTap: () {
            Navigator.pushNamed(context, '/seguridad');
          },
        ),
        
        // Cerrar sesión
        Opcion(
          nombre: "Cerrar sesión",
          iconPath: "lib/resources/logout.png",
          onTap: () {
            _mostrarDialogoCerrarSesion(context);
          },
        ),
      ],
    );
  }

  /// Muestra un diálogo de confirmación para cerrar sesión
  void _mostrarDialogoCerrarSesion(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cerrar sesión'),
          content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar diálogo
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar diálogo
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/',
                  (route) => false,
                ); // Ir al splash screen
              },
              child: const Text(
                'Cerrar sesión',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}