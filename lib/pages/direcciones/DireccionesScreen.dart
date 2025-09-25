import 'package:flutter/material.dart';
import '../homepage/widgets/HomeBottomNavigation.dart';
import 'widgets/widgets.dart';
import 'widgets/AgregarDireccionModal.dart';
import 'widgets/EditarDireccionModal.dart';
import 'widgets/EliminarDireccionModal.dart';
import 'models/direccion.dart';

class DireccionesScreen extends StatefulWidget {
  const DireccionesScreen({super.key});

  @override
  State<DireccionesScreen> createState() => _DireccionesScreenState();
}

class _DireccionesScreenState extends State<DireccionesScreen> {
  // Lista de direcciones - en una app real, esto vendría de un servicio o estado global
  List<Direccion> direcciones = [
    Direccion(
      id: '1',
      nombre: 'Casa',
      direccion: 'Carrera 15 #123-45, Chapinero',
      ciudad: 'Bogotá',
      telefono: '+57 300 123 4567',
      referencia: 'Frente al parque principal',
      esPrincipal: true,
    ),
    Direccion(
      id: '2',
      nombre: 'Oficina',
      direccion: 'Calle 100 #67-89, Zona Rosa',
      ciudad: 'Bogotá',
      telefono: '+57 310 987 6543',
      esPrincipal: false,
    ),
  ];

  void _mostrarModalAgregar() {
    showDialog(
      context: context,
      builder: (context) => AgregarDireccionModal(
        onDireccionAgregada: _agregarDireccion,
      ),
    );
  }

  void _mostrarModalEditar(Direccion direccion) {
    showDialog(
      context: context,
      builder: (context) => EditarDireccionModal(
        direccion: direccion,
        onDireccionEditada: _editarDireccion,
      ),
    );
  }

  void _mostrarModalEliminar(Direccion direccion) {
    showDialog(
      context: context,
      builder: (context) => EliminarDireccionModal(
        direccion: direccion,
        onDireccionEliminada: _eliminarDireccion,
      ),
    );
  }

  void _agregarDireccion(Direccion nuevaDireccion) {
    setState(() {
      // Si es principal, quitar principal a las demás
      if (nuevaDireccion.esPrincipal) {
        direcciones = direcciones.map((d) => d.copyWith(esPrincipal: false)).toList();
      }
      direcciones.add(nuevaDireccion);
    });

    // Mostrar mensaje de éxito
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Dirección "${nuevaDireccion.nombre}" agregada exitosamente'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _editarDireccion(Direccion direccionEditada) {
    setState(() {
      final index = direcciones.indexWhere((d) => d.id == direccionEditada.id);
      if (index != -1) {
        // Si es principal, quitar principal a las demás
        if (direccionEditada.esPrincipal) {
          direcciones = direcciones.map((d) => d.copyWith(esPrincipal: false)).toList();
        }
        direcciones[index] = direccionEditada;
      }
    });

    // Mostrar mensaje de éxito
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Dirección "${direccionEditada.nombre}" actualizada exitosamente'),
        backgroundColor: Colors.blue,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _eliminarDireccion(Direccion direccion) {
    setState(() {
      direcciones.removeWhere((d) => d.id == direccion.id);
    });

    // Mostrar mensaje de éxito
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Dirección "${direccion.nombre}" eliminada exitosamente'),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'Deshacer',
          textColor: Colors.white,
          onPressed: () {
            setState(() {
              direcciones.add(direccion);
            });
          },
        ),
      ),
    );
  }

  void _seleccionarDireccion(Direccion direccion) {
    // Lógica para seleccionar dirección (por ejemplo, para un pedido)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Dirección "${direccion.nombre}" seleccionada'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: DireccionesAppBar(
        onAddPressed: _mostrarModalAgregar,
      ),
      body: direcciones.isEmpty
          ? _buildEmptyState()
          : DireccionesList(
              direcciones: direcciones,
              onEditDireccion: _mostrarModalEditar,
              onDeleteDireccion: _mostrarModalEliminar,
              onTapDireccion: _seleccionarDireccion,
            ),
      bottomNavigationBar: const HomeBottomNavigation(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.location_off,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'No tienes direcciones guardadas',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Agrega tu primera dirección para comenzar',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _mostrarModalAgregar,
            icon: const Icon(Icons.add),
            label: const Text('Agregar Dirección'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}