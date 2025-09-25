import 'package:flutter/material.dart';
import '../homepage/widgets/HomeBottomNavigation.dart';
import 'widgets/widgets.dart';

class DireccionesScreen extends StatelessWidget {
  const DireccionesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Datos de ejemplo - en una app real, estos vendrían de un estado o servicio
    final List<Map<String, String>> direccionesEjemplo = [
      {
        'nombre': 'Casa',
        'direccion': 'Carrera 15 #123-45, Chapinero',
        'ciudad': 'Bogotá',
        'telefono': '+57 300 123 4567',
      },
      {
        'nombre': 'Oficina',
        'direccion': 'Calle 100 #67-89, Zona Rosa',
        'ciudad': 'Bogotá',
        'telefono': '+57 310 987 6543',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const DireccionesAppBar(),
      body: DireccionesList(
        direcciones: direccionesEjemplo,
        onEditDireccion: (direccion) {
          // Lógica para editar dirección
          print('Editando dirección: ${direccion['nombre']}');
        },
        onDeleteDireccion: (direccion) {
          // Lógica para eliminar dirección
          print('Eliminando dirección: ${direccion['nombre']}');
        },
        onTapDireccion: (direccion) {
          // Lógica para seleccionar dirección
          print('Seleccionando dirección: ${direccion['nombre']}');
        },
      ),
      bottomNavigationBar: const HomeBottomNavigation(),
    );
  }
}