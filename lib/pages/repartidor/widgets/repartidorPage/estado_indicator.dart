import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EstadoIndicator extends StatelessWidget {
  final String estado;

  const EstadoIndicator({
    super.key,
    required this.estado,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: _getStatusColor().withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: _getStatusColor().withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getStatusIcon(),
              size: 40,
              color: _getStatusColor(),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Estado actual',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            estado,
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: _getStatusColor(),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _getStatusDescription(),
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Color _getStatusColor() {
    switch (estado.toLowerCase()) {
      case 'disponible':
        return const Color(0xFF58E181);
      case 'ocupado':
        return Colors.orange;
      case 'desconectado':
      default:
        return Colors.red;
    }
  }

  Color _getBackgroundColor() {
    switch (estado.toLowerCase()) {
      case 'disponible':
        return const Color(0xFF58E181).withOpacity(0.05);
      case 'ocupado':
        return Colors.orange.withOpacity(0.05);
      case 'desconectado':
      default:
        return Colors.red.withOpacity(0.05);
    }
  }

  IconData _getStatusIcon() {
    switch (estado.toLowerCase()) {
      case 'disponible':
        return Icons.check_circle;
      case 'ocupado':
        return Icons.delivery_dining;
      case 'desconectado':
      default:
        return Icons.power_settings_new;
    }
  }

  String _getStatusDescription() {
    switch (estado.toLowerCase()) {
      case 'disponible':
        return 'Listo para recibir pedidos';
      case 'ocupado':
        return 'Actualmente no disponible';
      case 'desconectado':
      default:
        return 'No estás recibiendo pedidos';
    }
  }
}