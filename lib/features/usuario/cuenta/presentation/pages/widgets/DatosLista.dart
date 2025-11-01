import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'camposDatos.dart';
import 'package:mi_mercado/features/usuario/cuenta/presentation/controllers/datos_perfil_controller.dart';

/// Widget que contiene la lista de datos del perfil
class DatosLista extends StatelessWidget {
  final EdgeInsets? padding;

  const DatosLista({
    super.key,
    this.padding = const EdgeInsets.symmetric(horizontal: 30.0),
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DatosPerfilController>();

    return Padding(
      padding: padding!,
      child: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                children: [
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        const Color(0xFF58E181),
                      ),
                      strokeWidth: 3,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Cargando información...',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        if (controller.usuario.value == null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: const Icon(
                      Icons.error_outline,
                      size: 40,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error al cargar los datos',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    controller.errorMessage.value.isNotEmpty
                        ? controller.errorMessage.value
                        : 'Por favor, inténtalo de nuevo',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF58E181),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => controller.cargarDatosPerfil(),
                    child: Text('Reintentar'),
                  ),
                ],
              ),
            ),
          );
        }

        final usuario = controller.usuario.value!;
        final datosUsuario = {
          'Nombre': usuario.nombre ?? '',
          'Apellido': usuario.apellido ?? '',
          'Teléfono': usuario.telefono,
          'Email': usuario.email,
        };

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: datosUsuario.entries.map((entry) {
            final campo = entry.key;
            final valor = entry.value;

            return CamposDatos(
              label: campo,
              value: valor,
            );
          }).toList(),
        );
      }),
    );
  }
}