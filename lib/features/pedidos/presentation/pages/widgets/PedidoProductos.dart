import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PedidoProductos extends StatelessWidget {
  final List<Map<String, dynamic>> productos;

  const PedidoProductos({
    super.key,
    required this.productos,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Productos",
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: productos.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final producto = productos[index];
            return _buildProductoItem(producto);
          },
        ),
      ],
    );
  }

  Widget _buildProductoItem(Map<String, dynamic> producto) {
    final String nombre = producto['nombre'] ?? 'Producto';
    final double precio = producto['precio']?.toDouble() ?? 0.0;
    final int cantidad = producto['cantidad'] ?? 1;
    final String? imagen = producto['imagen'];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF58E181).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF58E181).withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          // Imagen del producto
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: imagen != null
                  ? (imagen.toLowerCase().startsWith('http')
                      ? CachedNetworkImage(
                          imageUrl: imagen,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => _buildPlaceholderImage(),
                          errorWidget: (context, url, error) => _buildPlaceholderImage(),
                        )
                      : Image.asset(
                          imagen,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              _buildPlaceholderImage(),
                        ))
                  : _buildPlaceholderImage(),
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Información del producto
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nombre,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${precio.toStringAsFixed(0)}',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          
          // Cantidad
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF58E181),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'x$cantidad',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        Icons.shopping_bag_outlined,
        color: Colors.grey[400],
        size: 24,
      ),
    );
  }
}