import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mi_mercado/core/utils/shared_preferences_utils.dart';
import 'package:mi_mercado/features/repartidor/home/presentation/controllers/repartidor_home_controller.dart';

class RepartidorHomeScreen extends GetView<RepartidorHomeController> {
  const RepartidorHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Panel Repartidor',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF58E181),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: controller.refrescarEstado,
            tooltip: 'Actualizar estado',
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF58E181)),
                ),
                SizedBox(height: 16),
                Text(
                  'Cargando estado del repartidor...',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.refrescarEstado,
          color: const Color(0xFF58E181),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tarjeta de estado actual
                _buildEstadoCard(),

                const SizedBox(height: 24),

                // Sección de acciones principales
                Text(
                  'Acciones Principales',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey[800],
                  ),
                ),

                const SizedBox(height: 16),

                // Grid de botones principales
                _buildGridBotones(),

                const SizedBox(height: 24),

                // Botón de cerrar sesión
                _buildBotonCerrarSesion(),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildEstadoCard() {
    return Obx(() {
      final estado = controller.estadoActual.value;
      final tienePedido = controller.pedidoActual.value != null;
      final Color estadoColor = estado.toLowerCase() == 'disponible' 
          ? const Color(0xFF58E181) 
          : Colors.orange;
      final IconData estadoIcon = estado.toLowerCase() == 'disponible'
          ? Icons.check_circle
          : Icons.delivery_dining;

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [estadoColor.withOpacity(0.1), estadoColor.withOpacity(0.05)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: estadoColor,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: estadoColor.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: estadoColor.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                estadoIcon,
                color: estadoColor,
                size: 48,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Estado Actual',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              estado,
              style: GoogleFonts.inter(
                fontSize: 28,
                color: estadoColor,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (tienePedido) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.blue, width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.assignment, size: 16, color: Colors.blue),
                    const SizedBox(width: 6),
                    Text(
                      'Pedido Activo',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.blue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      );
    });
  }

  Widget _buildGridBotones() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.1,
      children: [
        _buildBotonOpcion(
          icon: Icons.person,
          titulo: 'Datos\nPersonales',
          color: Colors.blue,
          onTap: _verDatosPersonales,
        ),
        _buildBotonOpcion(
          icon: Icons.history,
          titulo: 'Historial de\nPedidos',
          color: Colors.purple,
          onTap: _verHistorialPedidos,
        ),
        Obx(() {
          final estaOcupado = controller.estadoActual.value == 'Ocupado';
          return _buildBotonOpcion(
            icon: Icons.list_alt,
            titulo: 'Pedidos\nDisponibles',
            color: estaOcupado ? Colors.grey : const Color(0xFF58E181),
            onTap: estaOcupado ? null : _verPedidosDisponibles,
          );
        }),
        Obx(() {
          final tienePedido = controller.pedidoActual.value != null;
          return _buildBotonOpcion(
            icon: Icons.delivery_dining,
            titulo: 'Pedido\nActual',
            color: tienePedido ? Colors.orange : Colors.grey,
            onTap: tienePedido ? _verPedidoActual : null,
          );
        }),
      ],
    );
  }

  Widget _buildBotonOpcion({
    required IconData icon,
    required String titulo,
    required Color color,
    required VoidCallback? onTap,
  }) {
    final isEnabled = onTap != null;
    final effectiveColor = isEnabled ? color : Colors.grey;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: effectiveColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: effectiveColor.withOpacity(0.3),
              width: 2,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: effectiveColor.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: effectiveColor,
                  size: 32,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                titulo,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isEnabled ? Colors.grey[800] : Colors.grey[500],
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBotonCerrarSesion() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: _mostrarDialogoCerrarSesion,
        icon: Icon(
          Icons.logout,
          color: Colors.red[600],
        ),
        label: Text(
          'Cerrar sesión',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.red[600],
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.red[600]!, width: 2),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  void _mostrarDialogoCerrarSesion() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(
              Icons.logout,
              color: Colors.red[600],
              size: 28,
            ),
            const SizedBox(width: 12),
            Text(
              'Cerrar sesión',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        content: Text(
          '¿Estás seguro de que quieres cerrar sesión?',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancelar',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              _cerrarSesion();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[600],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Cerrar sesión',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _mostrarMensaje(String titulo, String mensaje, {bool esError = false}) {
    Get.snackbar(
      titulo,
      mensaje,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: esError ? Colors.red[600] : const Color(0xFF58E181),
      colorText: Colors.white,
      icon: Icon(
        esError ? Icons.error : Icons.info,
        color: Colors.white,
      ),
      duration: const Duration(seconds: 3),
    );
  }

  Future<void> _cerrarSesion() async {
    try {
      await SharedPreferencesUtils.clearAll();
    } catch (e) {
      print('Error al cerrar sesión: $e');
    }

    _mostrarMensaje('Sesión cerrada', 'Sesión cerrada exitosamente');
    Get.offAllNamed('/');
  }

  void _verDatosPersonales() {
    // TODO: Implementar navegación a datos personales
    _mostrarMensaje('Próximamente', 'Funcionalidad de datos personales próximamente', esError: false);
  }

  void _verHistorialPedidos() {
    // TODO: Implementar navegación a historial
    _mostrarMensaje('Próximamente', 'Funcionalidad de historial próximamente', esError: false);
  }

  void _verPedidosDisponibles() {
    if (controller.estadoActual.value == 'Ocupado') {
      _mostrarMensaje(
        'No disponible',
        'No puedes ver pedidos disponibles mientras tienes un pedido activo',
        esError: true
      );
      return;
    }
    
    Get.toNamed('/pedidos-disponibles');
  }

  void _verPedidoActual() {
    final pedido = controller.pedidoActual.value;
    if (pedido == null) {
      _mostrarMensaje('Error', 'No tienes un pedido activo', esError: true);
      return;
    }

    Get.toNamed('/pedido-actual');
  }
}
