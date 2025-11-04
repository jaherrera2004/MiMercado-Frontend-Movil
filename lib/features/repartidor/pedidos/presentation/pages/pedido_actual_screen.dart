import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mi_mercado/features/repartidor/pedidos/presentation/controllers/pedido_actual_controller.dart';
import 'package:mi_mercado/features/repartidor/pedidos/presentation/pages/widgets/productos_pedido_modal.dart';
import 'package:mi_mercado/features/repartidor/home/presentation/controllers/repartidor_home_controller.dart';
import 'package:mi_mercado/features/pedidos/domain/entities/Pedido.dart';

class PedidoActualScreen extends GetView<PedidoActualController> {
  const PedidoActualScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Mi Pedido Actual',
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
            onPressed: controller.refrescarPedido,
            tooltip: 'Actualizar',
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
                  'Cargando pedido...',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          );
        }

        if (controller.errorMessage.value != null && controller.errorMessage.value!.isNotEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error al cargar el pedido',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    controller.errorMessage.value!,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: controller.refrescarPedido,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reintentar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF58E181),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final pedido = controller.pedidoActual.value;

        if (pedido == null) {
          return RefreshIndicator(
            onRefresh: controller.refrescarPedido,
            color: const Color(0xFF58E181),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                Icon(
                  Icons.delivery_dining,
                  size: 80,
                  color: Colors.grey[300],
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    'No tienes pedido activo',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    'Toma un pedido desde la lista de disponibles',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.refrescarPedido,
          color: const Color(0xFF58E181),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Estado del pedido destacado
                _buildEstadoCard(pedido),
                
                const SizedBox(height: 16),
                
                // Información del pedido
                _buildInfoCard(pedido),
                
                const SizedBox(height: 16),
                
                // Dirección de entrega
                _buildDireccionCard(pedido),
                
                const SizedBox(height: 16),
                
                // Información del cliente
                _buildClienteCard(pedido),
                
                const SizedBox(height: 16),
                
                // Productos del pedido
                _buildProductosCard(pedido),
                
                const SizedBox(height: 16),
                
                // Resumen de costos
                _buildResumenCostosCard(pedido),
                
                const SizedBox(height: 24),
                
                // Botones de acción
                _buildBotonesAccion(context, pedido),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildEstadoCard(Pedido pedido) {
    Color estadoColor;
    IconData estadoIcon;
    
    switch (pedido.estado.toLowerCase()) {
      case 'pendiente':
        estadoColor = Colors.orange;
        estadoIcon = Icons.schedule;
        break;
      case 'en camino':
        estadoColor = Colors.blue;
        estadoIcon = Icons.local_shipping;
        break;
      case 'entregado':
        estadoColor = Colors.green;
        estadoIcon = Icons.check_circle;
        break;
      default:
        estadoColor = Colors.grey;
        estadoIcon = Icons.info;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [estadoColor, estadoColor.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: estadoColor.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              estadoIcon,
              size: 32,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Estado del pedido',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  pedido.estado,
                  style: GoogleFonts.inter(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(Pedido pedido) {
    final fecha = pedido.fecha;
    final fechaFormateada = '${fecha.day.toString().padLeft(2, '0')}/${fecha.month.toString().padLeft(2, '0')}/${fecha.year}';
    final horaFormateada = '${fecha.hour.toString().padLeft(2, '0')}:${fecha.minute.toString().padLeft(2, '0')}';

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Información del Pedido',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              icon: Icons.receipt,
              label: 'ID del Pedido',
              value: '#${pedido.id.substring(0, 8)}...',
              iconColor: Colors.blue,
            ),
            const Divider(height: 24),
            _buildInfoRow(
              icon: Icons.calendar_today,
              label: 'Fecha',
              value: fechaFormateada,
              iconColor: Colors.purple,
            ),
            const Divider(height: 24),
            _buildInfoRow(
              icon: Icons.access_time,
              label: 'Hora',
              value: horaFormateada,
              iconColor: Colors.orange,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDireccionCard(Pedido pedido) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.location_on,
                    color: Colors.red[400],
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Dirección de Entrega',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                pedido.direccion,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.grey[800],
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClienteCard(Pedido pedido) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.person,
                    color: Colors.blue[400],
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Información del Cliente',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Obx(() {
              final usuario = controller.usuarioCliente.value;
              if (usuario != null) {
                return Column(
                  children: [
                    _buildInfoRow(
                      icon: Icons.person_outline,
                      label: 'Nombre',
                      value: '${usuario.nombre ?? ''} ${usuario.apellido ?? ''}'.trim().isNotEmpty
                          ? '${usuario.nombre ?? ''} ${usuario.apellido ?? ''}'.trim()
                          : 'No disponible',
                      iconColor: Colors.blue,
                    ),
                    const Divider(height: 24),
                    _buildInfoRow(
                      icon: Icons.phone,
                      label: 'Teléfono',
                      value: usuario.telefono,
                      iconColor: Colors.green,
                    ),
                    const Divider(height: 24),
                    _buildInfoRow(
                      icon: Icons.email,
                      label: 'Email',
                      value: usuario.email,
                      iconColor: Colors.purple,
                    ),
                  ],
                );
              } else {
                return Column(
                  children: [
                    _buildInfoRow(
                      icon: Icons.person_outline,
                      label: 'Nombre',
                      value: 'Cargando...',
                      iconColor: Colors.blue,
                    ),
                    const Divider(height: 24),
                    _buildInfoRow(
                      icon: Icons.phone,
                      label: 'Teléfono',
                      value: 'Cargando...',
                      iconColor: Colors.green,
                    ),
                  ],
                );
              }
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildProductosCard(Pedido pedido) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF58E181).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.shopping_bag,
                    color: Color(0xFF58E181),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Productos',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  ProductosPedidoModal.mostrar(pedido.listaProductos);
                },
                icon: const Icon(Icons.visibility),
                label: const Text('Ver Productos'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF58E181),
                  side: const BorderSide(color: Color(0xFF58E181)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResumenCostosCard(Pedido pedido) {
    // Calcular costos
    const double valorDomicilio = 5000;
    const double valorServicio = 2000;
    final double costoProductos = pedido.costoTotal - valorDomicilio - valorServicio;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Resumen de Costos',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF58E181).withOpacity(0.1),
                    const Color(0xFF58E181).withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  // Costo de productos
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Productos',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                      Text(
                        '\$${costoProductos.toStringAsFixed(0)}',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Costo de domicilio
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Domicilio',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                      Text(
                        '\$${valorDomicilio.toStringAsFixed(0)}',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Costo de servicio
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Servicio',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                      Text(
                        '\$${valorServicio.toStringAsFixed(0)}',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 16),
                  // Total
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total a Cobrar',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800],
                        ),
                      ),
                      Text(
                        '\$${pedido.costoTotal.toStringAsFixed(0)}',
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF58E181),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBotonesAccion(BuildContext context, Pedido pedido) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _confirmarEntrega(context, pedido),
        icon: const Icon(Icons.check_circle),
        label: const Text('Confirmar Entrega'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green[600],
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required Color iconColor,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 20,
            color: iconColor,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _confirmarEntrega(BuildContext context, Pedido pedido) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.green[600],
              size: 28,
            ),
            const SizedBox(width: 12),
            Text(
              'Confirmar Entrega',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '¿Confirmas que el pedido ha sido entregado exitosamente?',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green, width: 1),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: Colors.green, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Esta acción no se puede deshacer',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.green[800],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
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
            onPressed: () async {
              Get.back(); // Cerrar el diálogo

              // Mostrar indicador de carga
              Get.dialog(
                const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF58E181)),
                  ),
                ),
                barrierDismissible: false,
              );

              // Llamar al método del controller para marcar como entregado
              final exito = await controller.marcarComoEntregado();

              Get.back(); // Cerrar indicador de carga

              if (exito) {
                Get.snackbar(
                  '¡Entrega confirmada!',
                  'El pedido ha sido marcado como entregado exitosamente',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.green[600],
                  colorText: Colors.white,
                  icon: const Icon(Icons.check_circle, color: Colors.white),
                  duration: const Duration(seconds: 3),
                );
                
                // Actualizar el estado del repartidor y volver al home
                final repartidorController = Get.find<RepartidorHomeController>();
                await repartidorController.cargarEstadoRepartidor();
                Get.back();
              } else {
                Get.snackbar(
                  'Error',
                  controller.errorMessage.value ?? 'No se pudo marcar el pedido como entregado',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red[600],
                  colorText: Colors.white,
                  icon: const Icon(Icons.error, color: Colors.white),
                  duration: const Duration(seconds: 4),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[600],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Confirmar',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
