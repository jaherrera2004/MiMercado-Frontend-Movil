import 'package:flutter/material.dart';
import 'DireccionItem.dart';

class DireccionesList extends StatelessWidget {
  final List<Map<String, String>> direcciones;
  final Function(Map<String, String>)? onEditDireccion;
  final Function(Map<String, String>)? onDeleteDireccion;
  final Function(Map<String, String>)? onTapDireccion;

  const DireccionesList({
    super.key,
    required this.direcciones,
    this.onEditDireccion,
    this.onDeleteDireccion,
    this.onTapDireccion,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: direcciones.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final direccion = direcciones[index];
        return DireccionItem(
          nombre: direccion['nombre'] ?? '',
          ubicacion: direccion['ubicacion'] ?? '',
          onEdit: () => onEditDireccion?.call(direccion),
          onDelete: () => onDeleteDireccion?.call(direccion),
          onTap: () => onTapDireccion?.call(direccion),
        );
      },
    );
  }
}