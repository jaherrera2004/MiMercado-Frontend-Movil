import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PedidoInfo extends StatelessWidget {
  final String numeroPedido;
  final String direccion;
  final String? fecha;
  final String? estado;

  const PedidoInfo({
    super.key,
    required this.numeroPedido,
    required this.direccion,
    this.fecha,
    this.estado,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Información del pedido",
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          
          _buildInfoRow(
            Icons.receipt_long,
            "Número de pedido",
            "#$numeroPedido",
          ),
          
          const SizedBox(height: 12),
          _buildInfoRow(
            Icons.location_on_outlined,
            "Dirección",
            direccion,
          ),
          
          if (fecha != null) ...[
            const SizedBox(height: 12),
            _buildInfoRow(
              Icons.access_time,
              "Fecha",
              fecha!,
            ),
          ],
          
          if (estado != null) ...[
            const SizedBox(height: 12),
            _buildEstadoRow(estado!),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: const Color(0xFF58E181),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEstadoRow(String estado) {
    final Color estadoColor = _getEstadoColor(estado);
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.local_shipping_outlined,
          size: 20,
          color: const Color(0xFF58E181),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Estado",
              style: GoogleFonts.inter(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 2),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: estadoColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                estado,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Color _getEstadoColor(String estado) {
    switch (estado.toLowerCase()) {
      case 'entregado':
        return Colors.green;
      case 'en_camino':
      case 'en camino':
        return Colors.orange;
      case 'pendiente':
        return Colors.blue;
      case 'cancelado':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}