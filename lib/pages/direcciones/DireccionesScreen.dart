import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../homepage/widgets/HomeBottomNavigation.dart';
import 'widgets/widgets.dart';
import 'widgets/AgregarDireccionModal.dart';
import 'widgets/EditarDireccionModal.dart';
import 'widgets/EliminarDireccionModal.dart';
import 'models/direccion.dart';
import '../../models/Usuario.dart';

class DireccionesScreen extends StatefulWidget {
  const DireccionesScreen({super.key});

  @override
  State<DireccionesScreen> createState() => _DireccionesScreenState();
}

class _DireccionesScreenState extends State<DireccionesScreen> {
  final FirebaseFirestore firebase = FirebaseFirestore.instance;
  List<Direccion> direcciones = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // Usar el nuevo método de Usuario para cargar direcciones
    _cargarDireccionesActuales();
  }

  Future<void> _cargarDireccionesActuales() async {
    try {
      setState(() {
        isLoading = true;
      });

      print('🔍 Cargando direcciones usando Usuario.obtenerDireccionesActuales()');

      // Usar el método estático de Usuario para obtener direcciones
      final List<Map<String, dynamic>> direccionesData = await Usuario.obtenerDireccionesActuales();
      
      // Convertir los datos a objetos Direccion
      final List<Direccion> direccionesFirebase = [];

      for (final direccionData in direccionesData) {
        final direccion = Direccion(
          id: direccionData['id']?.toString(),
          nombre: direccionData['nombre'] ?? 'Sin nombre',
          direccion: direccionData['direccion'] ?? 'Sin dirección',
          referencia: direccionData['referencias'] ?? '',
          esPrincipal: direccionData['principal'] ?? false,
        );

        direccionesFirebase.add(direccion);
        print('✅ Dirección cargada: ${direccion.nombre} - ${direccion.direccion}');
      }

      setState(() {
        direcciones = direccionesFirebase;
        isLoading = false;
      });

    } catch (e) {
      print('❌ Error cargando direcciones: $e');
      setState(() {
        isLoading = false;
        // Direcciones de ejemplo en caso de error
        direcciones = [
          Direccion(
            id: '1',
            nombre: 'Casa',
            direccion: 'Dirección de ejemplo',
            referencia: 'Sin referencia',
            esPrincipal: true,
          ),
        ];
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al cargar direcciones: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _mostrarModalAgregar() {
    showDialog(
      context: context,
      builder: (context) => AgregarDireccionModal(
        onDireccionAgregada: _handleAgregarDireccion,
      ),
    );
  }

  void _mostrarModalEditar(Direccion direccion) {
    showDialog(
      context: context,
      builder: (context) => EditarDireccionModal(
        direccion: direccion,
        onDireccionEditada: _handleEditarDireccion,
      ),
    );
  }

  void _mostrarModalEliminar(Direccion direccion) {
    showDialog(
      context: context,
      builder: (context) => EliminarDireccionModal(
        direccion: direccion,
        onDireccionEliminada: _handleEliminarDireccion,
      ),
    );
  }

  Future<void> _handleAgregarDireccion(Direccion nuevaDireccion) async {
    try {
      print('💾 Agregando nueva dirección usando Usuario.agregarDireccion()...');
      
      // Usar el método estático de Usuario para agregar la dirección
      await Usuario.agregarDireccion(
        nombre: nuevaDireccion.nombre,
        direccion: nuevaDireccion.direccion,
        referencia: nuevaDireccion.referencia,
        esPrincipal: nuevaDireccion.esPrincipal,
      );

      print('✅ Dirección agregada exitosamente usando Usuario.agregarDireccion()');

      // Recargar las direcciones desde Firebase para asegurar consistencia
      await _cargarDireccionesActuales();

      // Mostrar mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Dirección "${nuevaDireccion.nombre}" agregada exitosamente'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );

    } catch (e) {
      print('❌ Error al agregar dirección: $e');
      
      // Mostrar mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al agregar la dirección: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> _handleEditarDireccion(Direccion direccionEditada) async {
    try {
      print('✏️ Editando dirección usando Usuario.editarDireccion()...');
      
      // Validar que la dirección tenga un ID válido
      if (direccionEditada.id == null || direccionEditada.id!.isEmpty) {
        throw Exception('ID de dirección no válido');
      }
      
      // Usar el método estático de Usuario para editar la dirección
      await Usuario.editarDireccion(
        direccionId: direccionEditada.id!,
        nombre: direccionEditada.nombre,
        direccion: direccionEditada.direccion,
        referencia: direccionEditada.referencia,
        esPrincipal: direccionEditada.esPrincipal,
      );

      print('✅ Dirección editada exitosamente usando Usuario.editarDireccion()');

      // Recargar las direcciones desde Firebase para asegurar consistencia
      await _cargarDireccionesActuales();

      // Mostrar mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Dirección "${direccionEditada.nombre}" actualizada exitosamente'),
          backgroundColor: Colors.blue,
          duration: const Duration(seconds: 2),
        ),
      );

    } catch (e) {
      print('❌ Error al editar dirección: $e');
      
      // Mostrar mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al actualizar la dirección: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> _handleEliminarDireccion(Direccion direccion) async {
    try {
      print('🗑️ Eliminando dirección usando Usuario.eliminarDireccion()...');
      
      // Validar que la dirección tenga un ID válido
      if (direccion.id == null || direccion.id!.isEmpty) {
        throw Exception('ID de dirección no válido');
      }
      
      // Usar el método estático de Usuario para eliminar la dirección
      await Usuario.eliminarDireccion(
        direccionId: direccion.id!,
      );

      print('✅ Dirección eliminada exitosamente usando Usuario.eliminarDireccion()');

      // Recargar las direcciones desde Firebase para asegurar consistencia
      await _cargarDireccionesActuales();

      // Mostrar mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Dirección "${direccion.nombre}" eliminada exitosamente'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );

    } catch (e) {
      print('❌ Error al eliminar dirección: $e');
      
      // Mostrar mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al eliminar la dirección: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
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
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: DireccionesAppBar(
          onAddPressed: _mostrarModalAgregar,
        ),
        body: _buildBody(),
        bottomNavigationBar: const HomeBottomNavigation(),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    // Al presionar el botón 'back' del sistema, navegar a la pantalla Home
    // y limpiar la pila para evitar regresar al login.
    Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    return false; // evitar el pop por defecto
  }

  Widget _buildBody() {
    if (isLoading) {
      return _buildLoadingState();
    } else if (direcciones.isEmpty) {
      return _buildEmptyState();
    } else {
      return DireccionesList(
        direcciones: direcciones,
        onEditDireccion: _mostrarModalEditar,
        onDeleteDireccion: _mostrarModalEliminar,
        onTapDireccion: _seleccionarDireccion,
      );
    }
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text(
            'Cargando direcciones...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
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