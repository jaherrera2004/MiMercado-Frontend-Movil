import 'package:flutter/material.dart';

class direccion extends StatelessWidget {
  final String nombre;
  final String ubicacion;

  const direccion({super.key, required this.nombre, required this.ubicacion});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.asset('lib/resources/pin.png', width: 30, height: 30),
      title: Text(nombre, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(ubicacion),
      trailing: Row(
        mainAxisSize:
            MainAxisSize.min,
        children: [
          IconButton(
            icon: Image.asset('lib/resources/edit.png', 
            width: 30, 
            height: 30,
            ),
            onPressed: () {
            },
          ),
          IconButton(
            icon: Image.asset(
              'lib/resources/trashcan.png',
              width: 30,
              height: 30,
            ),
            onPressed: () {
            },
          ),
        ],
      ),

      onTap: () {},
    );
  }
}
