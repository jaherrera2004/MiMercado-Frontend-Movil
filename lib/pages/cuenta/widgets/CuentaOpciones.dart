import 'package:flutter/material.dart';
import 'opcion.dart';
import '../../../models/Persona.dart';

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
              onPressed: () async {
                Navigator.of(context).pop(); // Cerrar diálogo
                
                try {
                  // Llamar al método cerrarSesion de Persona
                  await Persona.cerrarSesion();
                  
                  // Mostrar mensaje de éxito
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Sesión cerrada exitosamente'),
                        backgroundColor: Color(0xFF58E181),
                        duration: Duration(seconds: 2),
                      ),
                    );
                    
                    // Navegar al splash screen y limpiar el stack de navegación
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/',
                      (route) => false,
                    );
                  }
                } catch (e) {
                  // Mostrar mensaje de error
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(e.toString().replaceAll('Exception: ', '')),
                        backgroundColor: Colors.red,
                        duration: const Duration(seconds: 3),
                      ),
                    );
                  }
                }
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