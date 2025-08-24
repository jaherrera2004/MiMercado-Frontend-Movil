import 'package:flutter/material.dart';

class pedido extends StatelessWidget {
  final String direccion;
  final String fecha;

  const pedido({super.key, required this.direccion, required this.fecha});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.asset('lib/resources/order.png', width: 30, height: 30,),
      title: Text(
        direccion,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(fecha),
      trailing: Image.asset(
        'lib/resources/arrow_right.png', width: 20, height: 20, // tu archivo en assets
      ),

      onTap: () {},
    );
  }
}
