import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_mercado/core/di/injection.dart';
import 'package:mi_mercado/features/usuario/cuenta/presentation/controllers/datos_perfil_controller.dart';
import 'widgets/widgets.dart';

class DatosPerfilScreen extends StatelessWidget {
  const DatosPerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Inicializar el controller
    final controller = Get.put(getIt<DatosPerfilController>());

    return Scaffold(
      appBar: DatosAppBar(
        onUsuarioEditado: () => controller.cargarDatosPerfil(),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Lista de datos
              const DatosLista(),

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

              // Botones
              const EditarPerfilBotones(),
            ],
          ),
        );
      }),
    );
  }
}
