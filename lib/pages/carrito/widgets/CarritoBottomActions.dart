import 'package:flutter/material.dart';
import '../../../shared/widgets/buttons/PrimaryButton.dart';

class CarritoBottomActions extends StatelessWidget {
  final VoidCallback onContinuarPago;

  const CarritoBottomActions({
    Key? key,
    required this.onContinuarPago,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        PrimaryButton(
          text: "Continuar pago",
          onPressed: onContinuarPago,
          backgroundColor: Theme.of(context).primaryColor,
          height: 50,
          borderRadius: 12,
          fontWeight: FontWeight.bold,
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}