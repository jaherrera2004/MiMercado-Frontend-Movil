import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_mercado/features/usuario/cuenta/presentation/controllers/seguridad_controller.dart';
import 'widgets/widgets.dart';

class SeguridadScreen extends StatelessWidget {
  const SeguridadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Inicializar el controllerz
    final controller = Get.find<SeguridadController>();

    return Scaffold(
      appBar: const SeguridadAppBar(),
      body: Obx(() {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Información de seguridad
              const SeguridadInfo(),

              const SizedBox(height: 20),

              // Mostrar mensaje de error si existe
              if (controller.errorMessage.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Text(
                    controller.errorMessage.value,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),

              // Mostrar mensaje de éxito si existe
              if (controller.successMessage.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green.shade200),
                  ),
                  child: Text(
                    controller.successMessage.value,
                    style: const TextStyle(color: Colors.green),
                  ),
                ),

              // Botón de cambio de contraseña
              const SeguridadBoton(),
            ],
          ),
        );
      }),
    );
  }
}
