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
          width: 160,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: onDelete,
                tooltip: 'Eliminar',
              ),
              // Botón decrementar con diseño mejorado
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.grey.shade300,
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onDecrement,
                    borderRadius: BorderRadius.circular(16),
                    child: const Icon(
                      Icons.remove,
                      size: 18,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              
              // Cantidad con mejor diseño
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.grey.shade300,
                    width: 1,
                  ),
                ),
                child: Text(
                  "${producto["cantidad"]}",
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              
              // Botón incrementar con diseño mejorado
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).primaryColor.withOpacity(0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onIncrement,
                    borderRadius: BorderRadius.circular(16),
                    child: const Icon(
                      Icons.add,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}