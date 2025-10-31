import 'package:flutter/material.dart';
import 'DireccionItem.dart';
import '../../../domain/entities/Direccion.dart';

class DireccionesList extends StatelessWidget {
  final List<Direccion> direcciones;
  final Function(Direccion)? onEditDireccion;
  final Function(Direccion)? onDeleteDireccion;
  final Function(Direccion)? onTapDireccion;

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
      padding: const EdgeInsets.all(16),
      itemCount: direcciones.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final direccion = direcciones[index];
        return DireccionItem(
          direccion: direccion,
          onEdit: () => onEditDireccion?.call(direccion),
          onDelete: () => onDeleteDireccion?.call(direccion),
          onTap: () => onTapDireccion?.call(direccion),
        );
      },
    );
  }
}