import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'historial_pedido_model.dart';

class HistorialCard extends StatelessWidget {
  final HistorialPedido pedido;

  const HistorialCard({
    super.key,
    required this.pedido,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con ID, estado y total
            _buildHeader(),
            
            const SizedBox(height: 12),
            
            // Cliente y dirección
            _buildClienteInfo(),
            
            const SizedBox(height: 12),
            
            // Footer con fecha, tiempo y distancia
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              pedido.id,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: pedido.colorEstado.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                pedido.textoEstado,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: pedido.colorEstado,
                ),
              ),
            ),
          ],
        ),
        Text(
          '\$${pedido.total}',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF58E181),
          ),
        ),
      ],
    );
  }

  Widget _buildClienteInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          pedido.cliente,
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(
              Icons.location_on,
              size: 14,
              color: Colors.grey[500],
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                pedido.direccion,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          pedido.fecha,
          style: GoogleFonts.inter(
            fontSize: 12,
            color: Colors.grey[500],
          ),
        ),
      
      ],
    );
  }
}