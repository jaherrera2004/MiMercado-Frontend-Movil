import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mi_mercado/core/utils/shared_preferences_utils.dart';

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
  String? _userName;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    try {
      final name = await SharedPreferencesUtils.getUserName();
      if (mounted) {
        setState(() {
          _userName = name;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _userName = null;
          _isLoading = false;
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
              _isLoading
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
                      _userName ?? "Usuario",
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