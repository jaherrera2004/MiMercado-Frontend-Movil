import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PedidoResumen extends StatelessWidget {
  final double? subtotal;
  final double? domicilio;
  final double? servicio;
  final double total;

  const PedidoResumen({
    super.key,
    this.subtotal,
    this.domicilio,
    this.servicio,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Resumen del pedido",
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          
          if (subtotal != null)
            _buildCostRow("Productos", subtotal!),
          
          if (domicilio != null) ...[
            const SizedBox(height: 12),
            _buildCostRow("Domicilio", domicilio!),
          ],
          
          if (servicio != null) ...[
            const SizedBox(height: 12),
            _buildCostRow("Servicio", servicio!),
          ],
          
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 12),
          
          _buildTotalRow("Total", total),
        ],
      ),
    );
  }

  Widget _buildCostRow(String label, double amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
        Text(
          '\$${amount.toStringAsFixed(0)}',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildTotalRow(String label, double amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Text(
          '\$${amount.toStringAsFixed(0)}',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF58E181),
          ),
        ),
      ],
    );
  }
}