import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ConfirmarPedidoDialog extends StatelessWidget {
  final VoidCallback onConfirmar;

  const ConfirmarPedidoDialog({
    super.key,
    required this.onConfirmar,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Confirmar pedido',
        style: GoogleFonts.inter(fontWeight: FontWeight.w600),
      ),
      content: Text(
        '¿Estás seguro de que quieres tomar este pedido?',
        style: GoogleFonts.inter(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Cancelar',
            style: GoogleFonts.inter(color: Colors.grey[600]),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            onConfirmar();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF58E181),
          ),
          child: Text(
            'Tomar pedido',
            style: GoogleFonts.inter(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  static void mostrar(BuildContext context, VoidCallback onConfirmar) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmarPedidoDialog(onConfirmar: onConfirmar);
      },
    );
  }
}