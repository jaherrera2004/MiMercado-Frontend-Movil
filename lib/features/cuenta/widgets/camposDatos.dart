import 'package:flutter/material.dart';

class CamposDatos extends StatelessWidget {
  final String dato;

  const CamposDatos({super.key, required this.dato});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(dato, style: const TextStyle(fontWeight: FontWeight.bold)),
      onTap: () {},
    );
  }
}
