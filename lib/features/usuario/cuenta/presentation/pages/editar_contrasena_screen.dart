import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_mercado/core/di/injection.dart';
import 'package:mi_mercado/features/usuario/cuenta/presentation/controllers/editar_contrasena_controller.dart';
import 'widgets/widgets.dart';

class EditarContrasenaScreen extends StatefulWidget {
  const EditarContrasenaScreen({super.key});

  @override
  State<EditarContrasenaScreen> createState() => _EditarContrasenaScreenState();
}

class _EditarContrasenaScreenState extends State<EditarContrasenaScreen> {
  late final EditarContrasenaController controller;
  late final TextEditingController contrasenaActualController;
  late final TextEditingController nuevaContrasenaController;
  late final TextEditingController confirmarContrasenaController;

  @override
  void initState() {
    super.initState();
    controller = Get.put(getIt<EditarContrasenaController>());
    
    contrasenaActualController = TextEditingController(text: controller.contrasenaActualController.value);
    nuevaContrasenaController = TextEditingController(text: controller.nuevaContrasenaController.value);
    confirmarContrasenaController = TextEditingController(text: controller.confirmarContrasenaController.value);

    // Vincular los controllers con los observables
    contrasenaActualController.addListener(() {
      controller.contrasenaActualController.value = contrasenaActualController.text;
    });
    nuevaContrasenaController.addListener(() {
      controller.nuevaContrasenaController.value = nuevaContrasenaController.text;
    });
    confirmarContrasenaController.addListener(() {
      controller.confirmarContrasenaController.value = confirmarContrasenaController.text;
    });
  }

  @override
  void dispose() {
    contrasenaActualController.dispose();
    nuevaContrasenaController.dispose();
    confirmarContrasenaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const EditarContrasenaAppBar(),
      body: Obx(() {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Formulario de cambio de contraseña
              EditarContrasenaForm(
                contrasenaActualController: contrasenaActualController,
                nuevaContrasenaController: nuevaContrasenaController,
                confirmarContrasenaController: confirmarContrasenaController,
              ),

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

              // Botones
              EditarContrasenaBotones(
                onCambiar: controller.cambiarContrasena,
                isLoading: controller.isLoading.value,
              ),
            ],
          ),
        );
      }),
    );
  }
}
