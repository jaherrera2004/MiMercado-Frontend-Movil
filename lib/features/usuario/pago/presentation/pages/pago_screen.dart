import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mi_mercado/features/usuario/pago/presentation/controllers/pago_controller.dart';
import 'widgets/widgets.dart';
import 'package:mi_mercado/core/widgets/common/SnackBarMessage.dart';

class PagoScreen extends StatefulWidget {
  const PagoScreen({super.key});

  @override
  State<PagoScreen> createState() => _PagoScreenState();
}

class _PagoScreenState extends State<PagoScreen> {
  late PagoController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<PagoController>();
    // Recargar direcciones cuando se crea la pantalla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.cargarDirecciones();
    });
  }

  @override
  Widget build(BuildContext context) {
    print('PagoScreen: Building, carritoVacioObs: ${controller.carritoVacioObs.value}');
    controller.debugPagoScreen();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const PagoAppBar(),
      body: Obx(() {
        if (controller.carritoVacioObs.value) {
          return const _EmptyCartView();
        }
        return const _PaymentFormView();
      }),
    );
  }
}

class _EmptyCartView extends StatelessWidget {
  const _EmptyCartView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Tu carrito está vacío',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            'Agrega productos para realizar un pedido',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF58E181),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            child: const Text('Ir a comprar'),
          ),
        ],
      ),
    );
  }
}

class _PaymentFormView extends StatelessWidget {
  const _PaymentFormView();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título de dirección de envío
          Text(
            "Dirección de envío",
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),

          // Select de dirección de envío
          const _AddressSelector(),

          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 24),

          // Resumen del pedido con datos reales del carrito
          const _PaymentSummary(),

          const SizedBox(height: 32),

          // Botón realizar pedido
          const _PaymentButton(),
        ],
      ),
    );
  }
}

class _AddressSelector extends StatelessWidget {
  const _AddressSelector();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PagoController>();
    return Obx(() {
      if (controller.cargandoDirecciones.value) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(child: CircularProgressIndicator()),
        );
      } else if (controller.direcciones.isEmpty) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.orange[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.orange, width: 1),
          ),
          child: Column(
            children: [
              const Icon(Icons.location_off, color: Colors.orange, size: 40),
              const SizedBox(height: 8),
              Text(
                'No tienes direcciones guardadas',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.orange[900],
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () async {
                  await Navigator.pushNamed(context, '/direcciones');
                  // Recargar direcciones cuando regresa de agregar una
                  controller.cargarDirecciones();
                },
                child: const Text('Agregar dirección'),
              ),
            ],
          ),
        );
      } else {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF58E181).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFF58E181).withOpacity(0.3),
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: controller.direccionSeleccionada.value,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF58E181)),
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.black87,
              ),
              items: controller.direcciones.map((direccion) {
                return DropdownMenuItem<String>(
                  value: direccion.direccion,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        direccion.nombre,
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        direccion.direccion,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                controller.seleccionarDireccion(newValue);
              },
            ),
          ),
        );
      }
    });
  }
}

class _PaymentSummary extends StatelessWidget {
  const _PaymentSummary();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PagoController>();
    return Obx(() => PagoResumen(
      subtotal: controller.subtotal,
      domicilio: controller.valorDomicilio,
      servicio: controller.valorServicio,
      total: controller.total,
    ));
  }
}

class _PaymentButton extends StatelessWidget {
  const _PaymentButton();

  Future<void> _realizarPedido(BuildContext context) async {
    final controller = Get.find<PagoController>();
    final success = await controller.realizarPedido();

    if (success) {
      // Mostrar mensaje de éxito
      SnackBarMessage.showSuccess(context, '¡Pedido realizado con éxito!');

      // Navegar a la pantalla de pedidos
      Navigator.pushReplacementNamed(context, '/pedidos');
    } else {
      // Mostrar mensaje de error
      SnackBarMessage.showError(context, 'Error al procesar el pedido. Verifica tu dirección y conexión.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PagoController>();
    return Obx(() => PagoBotonPedido(
      isLoading: controller.isLoading.value,
      onPressed: () => _realizarPedido(context),
    ));
  }
}
