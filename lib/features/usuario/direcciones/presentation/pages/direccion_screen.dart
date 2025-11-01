import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_mercado/features/usuario/direcciones/domain/entities/Direccion.dart';
import '../controllers/direccion_controller.dart';
import 'widgets/widgets.dart';
import 'package:mi_mercado/core/utils/shared_preferences_utils.dart';
import 'package:mi_mercado/features/usuario/productos/presentation/pages/widgets/HomeBottomNavigation.dart';

class DireccionesScreen extends GetView<DireccionController> {
  const DireccionesScreen({super.key});

  Future<String?> _getCurrentUserId() async {
    return await SharedPreferencesUtils.getUserId();
  }

  void _mostrarModalAgregar(BuildContext context) async {
    print('DireccionScreen: _mostrarModalAgregar llamado');
    final idUsuario = await _getCurrentUserId();
    print('DireccionScreen: idUsuario obtenido: $idUsuario');

    if (idUsuario != null) {
      print('DireccionScreen: Abriendo modal de agregar dirección');
      showDialog(
        context: context,
        builder: (context) => AgregarDireccionModal(
          idUsuario: idUsuario,
          onDireccionAgregada: (direccion) async {
            print('DireccionScreen: Callback onDireccionAgregada llamado con dirección: ${direccion.nombre}');
            await controller.agregarDireccion(direccion);
          },
        ),
      );
    } else {
      print('DireccionScreen: ERROR - idUsuario es null, no se puede abrir modal');
      Get.snackbar('Error', 'No se pudo obtener el ID del usuario');
    }
  }

  void _mostrarModalEditar(BuildContext context, Direccion direccion) {
    showDialog(
      context: context,
      builder: (context) => EditarDireccionModal(
        direccion: direccion,
        onDireccionEditada: (direccionEditada) => controller.editarDireccion(direccionEditada),
      ),
    );
  }

  void _mostrarModalEliminar(BuildContext context, Direccion direccion) {
    showDialog(
      context: context,
      builder: (context) => EliminarDireccionModal(
        direccion: direccion,
        onDireccionEliminada: (direccion) => controller.eliminarDireccion(direccion.id),
      ),
    );
  }

  void _seleccionarDireccion(Direccion direccion) {
    // Lógica para seleccionar dirección
    Get.snackbar('Dirección seleccionada', 'Dirección "${direccion.nombre}" seleccionada');
  }

  Future<bool> _onWillPop() async {
    Get.offAllNamed('/home');
    return false;
  }

  @override
  Widget build(BuildContext context) {
    // Cargar direcciones cuando se abra la pantalla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.cargarDireccionesUsuario();
    });

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: DireccionesAppBar(
          onAddPressed: () => _mostrarModalAgregar(context),
        ),
        body: _buildBody(context),
        bottomNavigationBar: const HomeBottomNavigation(currentIndex: 1),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return _buildLoadingState();
      } else if (controller.direcciones.isEmpty) {
        return _buildEmptyState(context);
      } else {
        return DireccionesList(
          direcciones: controller.direcciones,
          onEditDireccion: (direccion) => _mostrarModalEditar(context, direccion),
          onDeleteDireccion: (direccion) => _mostrarModalEliminar(context, direccion),
          onTapDireccion: _seleccionarDireccion,
        );
      }
    });
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

  Widget _buildEmptyState(BuildContext context) {
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
            onPressed: () => _mostrarModalAgregar(context),
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