import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'widgets/repartidorPage/disponibilidad_selector.dart';
import 'widgets/repartidorPage/estado_indicator.dart';
import 'widgets/repartidorPage/pedidos_navigation.dart';

class RepartidorPage extends StatefulWidget {
  const RepartidorPage({super.key});

  @override
  State<RepartidorPage> createState() => _RepartidorPageState();
}

class _RepartidorPageState extends State<RepartidorPage> {
  String _estadoActual = 'Desconectado';
  
  void _cambiarEstado(String nuevoEstado) {
    setState(() {
      _estadoActual = nuevoEstado;
    });
  }

  void _mostrarDialogoCerrarSesion() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                Icons.logout,
                color: Colors.red[600],
                size: 28,
              ),
              const SizedBox(width: 12),
              Text(
                'Cerrar sesión',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: Text(
            '¿Estás seguro de que quieres cerrar sesión? Se perderá tu estado actual de conexión.',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancelar',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _cerrarSesion();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[600],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Cerrar sesión',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _cerrarSesion() {
    // Resetear estado antes de cerrar sesión
    setState(() {
      _estadoActual = 'Desconectado';
    });
    
    // Mostrar mensaje de confirmación
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Sesión cerrada exitosamente',
              style: GoogleFonts.inter(color: Colors.white),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF58E181),
        duration: const Duration(seconds: 2),
      ),
    );
    
    // Navegar de vuelta al login o pantalla principal
    Navigator.of(context).pushNamedAndRemoveUntil(
      '/', // Ruta del login o pantalla principal
      (Route<dynamic> route) => false,
    );
  }

  Widget _buildBotonCerrarSesion() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: OutlinedButton.icon(
        onPressed: _mostrarDialogoCerrarSesion,
        icon: Icon(
          Icons.logout,
          color: Colors.red[600],
        ),
        label: Text(
          'Cerrar sesión',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.red[600],
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.red[600]!),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Panel Repartidor',
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
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: _mostrarDialogoCerrarSesion,
            tooltip: 'Cerrar sesión',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Estado actual
            EstadoIndicator(estado: _estadoActual),
            
            const SizedBox(height: 24),
            
            // Selector de disponibilidad
            DisponibilidadSelector(
              estadoActual: _estadoActual,
              onEstadoChanged: _cambiarEstado,
            ),
            
            const SizedBox(height: 24),
            
            // Navegación a pedidos
            const PedidosNavigation(),
            
            const SizedBox(height: 24),
            
            // Botón de cerrar sesión
            _buildBotonCerrarSesion(),
          ],
        ),
      ),
    );
  }
}