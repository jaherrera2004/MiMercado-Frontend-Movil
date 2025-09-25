import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PagoResumen extends StatelessWidget {
  final double? subtotal;
  final double? domicilio;
  final double? servicio;
  final double total;
  final bool showTotal;

  const PagoResumen({
    super.key,
    this.subtotal,
    this.domicilio,
    this.servicio,
    required this.total,
    this.showTotal = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Detalles del pedido",
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        
        // Detalles del pedido
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF58E181).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFF58E181).withOpacity(0.2),
            ),
          ),
          child: Column(
            children: [
              if (subtotal != null)
                _buildFilaDetalle("Productos", subtotal!),
              
              if (domicilio != null) ...[
                const SizedBox(height: 8),
                _buildFilaDetalle("Domicilio", domicilio!),
              ],
              
              if (servicio != null) ...[
                const SizedBox(height: 8),
                _buildFilaDetalle("Servicio", servicio!),
              ],
            ],
          ),
        ),
        
        if (showTotal) ...[
          const SizedBox(height: 16),
          
          // Total
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total",
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '\$${total.toStringAsFixed(0)}',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildFilaDetalle(String titulo, double valor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          titulo,
          style: GoogleFonts.inter(
            fontSize: 15,
            color: Colors.black87,
          ),
        ),
        Text(
          '\$${valor.toStringAsFixed(0)}',
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}