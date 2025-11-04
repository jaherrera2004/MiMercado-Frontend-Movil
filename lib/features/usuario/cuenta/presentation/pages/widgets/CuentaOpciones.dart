import 'package:flutter/material.dart';
import 'opcion.dart';
import '../../../../../../core/widgets/common/SnackBarMessage.dart';

/// Widget que contiene todas las opciones del menú de cuenta
class CuentaOpciones extends StatelessWidget {
  const CuentaOpciones({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título de sección
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Text(
              'Configuración',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
                letterSpacing: 0.5,
              ),
            ),
          ),
          
          const SizedBox(height: 8),
          
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
          
          const SizedBox(height: 20),
          
          // Título de sección
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Text(
              'Sesión',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
                letterSpacing: 0.5,
              ),
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Cerrar sesión
          Opcion(
            nombre: "Cerrar sesión",
            iconPath: "lib/resources/logout.png",
            onTap: () {
              _mostrarDialogoCerrarSesion(context);
            },
          ),
          
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  /// Muestra un diálogo de confirmación para cerrar sesión con diseño moderno
  void _mostrarDialogoCerrarSesion(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          contentPadding: const EdgeInsets.all(24),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icono decorativo
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.logout,
                  size: 48,
                  color: Colors.red.shade400,
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Título
              const Text(
                'Cerrar sesión',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              
              const SizedBox(height: 12),
              
              // Mensaje
              Text(
                '¿Estás seguro de que quieres cerrar tu sesión?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey.shade600,
                  height: 1.4,
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Botones
              Row(
                children: [
                  // Botón Cancelar
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(
                          color: Colors.grey.shade300,
                          width: 1.5,
                        ),
                      ),
                      child: Text(
                        'Cancelar',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 12),
                  
                  // Botón Cerrar sesión
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.of(context).pop();
                        
                        try {
                          if (context.mounted) {
                            SnackBarMessage.showSuccess(context, 'Sesión cerrada exitosamente');
                            
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/',
                              (route) => false,
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            SnackBarMessage.showError(context, 'Error: ${e.toString().replaceAll('Exception: ', '')}');
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade400,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Salir',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}