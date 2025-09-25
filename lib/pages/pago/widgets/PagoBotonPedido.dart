import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PagoBotonPedido extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;
  final String texto;

  const PagoBotonPedido({
    super.key,
    this.onPressed,
    this.isLoading = false,
    this.texto = "Realizar pedido",
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF58E181),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          side: const BorderSide(
            color: Color(0xFF58E181),
            width: 2,
          ),
          elevation: 2,
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF58E181)),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.shopping_cart_checkout,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    texto,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}