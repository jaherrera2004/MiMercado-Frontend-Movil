import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:mi_mercado/features/usuario/cuenta/presentation/controllers/mi_cuenta_controller.dart';

/// Widget que muestra la imagen de perfil y nombre del usuario
class PerfilHeader extends StatefulWidget {
  final String? imagenPath;

  const PerfilHeader({
    super.key,
    this.imagenPath = 'lib/resources/usuarioIMG.png',
  });

  @override
  State<PerfilHeader> createState() => _PerfilHeaderState();
}

class _PerfilHeaderState extends State<PerfilHeader> {
  late final MiCuentaController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<MiCuentaController>();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final nombre = _controller.usuario.value?.nombre ?? "Usuario";
      final isLoading = _controller.isLoading.value;

      return Column(
        children: [
          const SizedBox(height: 50),

          // Imagen circular y nombre
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage(widget.imagenPath!),
                  backgroundColor: Colors.grey.shade200,
                ),
                const SizedBox(height: 10),
                isLoading
                    ? SizedBox(
                        width: 100,
                        height: 20,
                        child: LinearProgressIndicator(
                          backgroundColor: Colors.grey.shade300,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).primaryColor,
                          ),
                        ),
                      )
                    : Text(
                        nombre,
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
              ],
            ),
          ),

          const SizedBox(height: 30),
        ],
      );
    });
  }
}