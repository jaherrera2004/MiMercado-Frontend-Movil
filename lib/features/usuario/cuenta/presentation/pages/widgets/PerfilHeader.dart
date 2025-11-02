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
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF58E181).withOpacity(0.15),
            Colors.white,
          ],
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 40),

          // Imagen circular y nombre con mejor diseño
          Center(
            child: Column(
              children: [
                // Avatar con borde y sombra
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF58E181).withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 56,
                          backgroundImage: AssetImage(widget.imagenPath!),
                          backgroundColor: Colors.grey.shade200,
                        ),
                      ),
                      // Badge decorativo
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF58E181),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 3,
                            ),
                          ),
                          child: const Icon(
                            Icons.verified_user,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Nombre del usuario
                _isLoading
                    ? Container(
                        width: 120,
                        height: 24,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      )
                    : Text(
                        _userName ?? "Usuario",
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Colors.black87,
                          letterSpacing: -0.5,
                        ),
                      ),
                
                const SizedBox(height: 6),
                
                // Subtítulo o badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF58E181).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFF58E181).withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.shopping_bag_outlined,
                        size: 14,
                        color: const Color(0xFF58E181),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Cliente',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF58E181),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}