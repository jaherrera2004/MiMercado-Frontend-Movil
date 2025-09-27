import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'pedido_model.dart';

class PedidoCard extends StatelessWidget {
  final Pedido pedido;
  final VoidCallback onTomarPedido;

  const PedidoCard({
    super.key,
    required this.pedido,
    required this.onTomarPedido,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con info del cliente y total
            _buildHeader(),
            
            const SizedBox(height: 12),
            
            // Dirección
            _buildDireccion(),
            
            // Notas (si existen)
            if (pedido.notas != null) ...[
              const SizedBox(height: 8),
              _buildNotas(),
            ],
            
            const SizedBox(height: 12),
            
            // Info del pedido
            _buildInfoPedido(),
            
            const SizedBox(height: 16),
            
            // Footer con distancia, tiempo y botón
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
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                pedido.cliente,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF58E181).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '\$${pedido.total}',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF58E181),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDireccion() {
    return Row(
      children: [
        Icon(
          Icons.location_on,
          size: 16,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            pedido.direccion,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.grey[700],
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildNotas() {
    return Row(
      children: [
        Icon(
          Icons.note,
          size: 16,
          color: Colors.blue[600],
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            pedido.notas!,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: Colors.blue[700],
              fontStyle: FontStyle.italic,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoPedido() {
    return Row(
      children: [
        Icon(
          Icons.shopping_bag,
          size: 16,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 6),
        Text(
          '${pedido.items} productos',
          style: GoogleFonts.inter(
            fontSize: 13,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            // Distancia
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
              ),
          
            ),
            const SizedBox(width: 8),
            // Tiempo estimado
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8),
              ),
              
            ),
          ],
        ),
        // Botón tomar pedido
        ElevatedButton(
          onPressed: onTomarPedido,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF58E181),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
          child: Text(
            'Tomar',
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}