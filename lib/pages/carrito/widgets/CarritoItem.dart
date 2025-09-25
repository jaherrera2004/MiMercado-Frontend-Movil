import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CarritoItem extends StatelessWidget {
  final Map<String, dynamic> producto;
  final VoidCallback? onDelete;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;

  const CarritoItem({
    Key? key,
    required this.producto,
    this.onDelete,
    this.onIncrement,
    this.onDecrement,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.green[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.white,
          radius: 25,
          child: ClipOval(
            child: Image.asset(
              producto["img"],
              width: 40,
              height: 40,
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Text(
          producto["nombre"],
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          producto["precio"],
          style: GoogleFonts.inter(fontSize: 14),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: SizedBox(
          width: 120,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: onDelete,
                tooltip: 'Eliminar',
              ),
              GestureDetector(
                onTap: onDecrement,
                child: const Icon(Icons.remove_circle_outline, color: Colors.black),
              ),
              const SizedBox(width: 4),
              Text(
                "${producto["cantidad"]}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 4),
              GestureDetector(
                onTap: onIncrement,
                child: const Icon(Icons.add_circle_outline, color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}