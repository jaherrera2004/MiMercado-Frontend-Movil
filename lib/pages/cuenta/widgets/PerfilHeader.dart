import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/SharedPreferences.dart';

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
  String nombre = "Cargando...";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargarNombreUsuario();
  }

  Future<void> _cargarNombreUsuario() async {
    try {
      final String? nombreUsuario = await SharedPreferencesService.getCurrentUserName();
      
      if (mounted) {
        setState(() {
          nombre = nombreUsuario ?? "Usuario";
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error cargando nombre del usuario: $e');
      if (mounted) {
        setState(() {
          nombre = "Usuario";
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
  }
}