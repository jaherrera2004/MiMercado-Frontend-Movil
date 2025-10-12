import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../models/Pedidos.dart';
import '../../../../models/Producto.dart';
import '../../../../models/Usuario.dart';

class PedidoCard extends StatelessWidget {
  final Pedido pedido;
  final VoidCallback onTomarPedido;

  const PedidoCard({
    super.key,
    required this.pedido,
    required this.onTomarPedido,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con info del cliente y total
            _buildHeader(),
            
            const SizedBox(height: 12),
            
            // Dirección
            _buildDireccion(),
            
            const SizedBox(height: 12),
            
            // Info del pedido
            _buildInfoPedido(),
            
            const SizedBox(height: 16),
            
            // Footer con estado y botón
              _buildFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pedido #${pedido.id.substring(0, 8)}', // Mostrar ID corto del pedido
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              FutureBuilder<String?>(
                future: Usuario.obtenerNombrePorId(pedido.idUsuario),
                builder: (context, snapshot) {
                  String texto;
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    texto = 'Usuario: cargando...';
                  } else if (snapshot.hasError) {
                    texto = 'Usuario: ${(pedido.idUsuario.length > 8 ? pedido.idUsuario.substring(0, 8) + '...' : pedido.idUsuario)}';
                  } else {
                    final nombre = snapshot.data;
                    if (nombre != null && nombre.isNotEmpty) {
                      texto = 'Cliente: $nombre';
                    } else {
                      texto = 'Usuario: ${(pedido.idUsuario.length > 8 ? pedido.idUsuario.substring(0, 8) + '...' : pedido.idUsuario)}';
                    }
                  }
                  return Text(
                    texto,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                    overflow: TextOverflow.ellipsis,
                  );
                },
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF58E181).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '\$${pedido.costoTotal.toStringAsFixed(0)}',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF58E181),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDireccion() {
    return Row(
      children: [
        Icon(
          Icons.location_on,
          size: 16,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            pedido.direccion,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.grey[700],
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoPedido() {
    return Column(
      children: [
        Row(
          children: [
            Icon(
              Icons.shopping_bag,
              size: 16,
              color: Colors.grey[600],
            ),
            const SizedBox(width: 6),
            Text(
              '${pedido.totalProductos} productos',
              style: GoogleFonts.inter(
                fontSize: 13,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(
              Icons.calendar_today,
              size: 16,
              color: Colors.grey[600],
            ),
            const SizedBox(width: 6),
            Text(
              'Fecha: ${_formatearFecha(pedido.fecha)}',
              style: GoogleFonts.inter(
                fontSize: 13,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(
              Icons.info_outline,
              size: 16,
              color: Colors.grey[600],
            ),
            const SizedBox(width: 6),
            Text(
              'Estado: ${pedido.estado}',
              style: GoogleFonts.inter(
                fontSize: 13,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Estado del pedido
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _getColorEstado(pedido.estado),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            pedido.estado,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
        Row(
          children: [
            // Botón ver productos
            OutlinedButton.icon(
              onPressed: () => _mostrarProductos(context),
              icon: const Icon(Icons.list_alt, size: 18),
              label: Text(
                'Ver productos',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(width: 8),
            // Botón tomar pedido
            ElevatedButton(
              onPressed: onTomarPedido,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF58E181),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: Text(
                'Tomar',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _mostrarProductos(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          minChildSize: 0.35,
          initialChildSize: 0.6,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return Column(
              children: [
                // Header del modal
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Productos del pedido',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${pedido.totalProductos} items',
                          style: GoogleFonts.inter(fontSize: 12, color: Colors.grey[700]),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                const Divider(height: 1),
                Expanded(
                  child: FutureBuilder<List<Producto>>(
                    future: Producto.obtenerProductosPorIdPedido(pedido.id),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Text(
                              'Error al cargar productos',
                              style: GoogleFonts.inter(color: Colors.red[600], fontWeight: FontWeight.w600),
                            ),
                          ),
                        );
                      }
                      final productos = snapshot.data ?? [];

                      // Mapa de cantidades por ID desde el pedido
                      final Map<String, int> cantidades = {
                        for (final it in pedido.listaProductos) it.idProducto: it.cantidad
                      };

                      if (productos.isEmpty) {
                        // Fallback: mostrar por ID si no hubo datos
                        return ListView.separated(
                          controller: scrollController,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          itemCount: pedido.listaProductos.length,
                          separatorBuilder: (_, __) => const Divider(height: 16),
                          itemBuilder: (context, index) {
                            final item = pedido.listaProductos[index];
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(Icons.inventory_2, size: 18, color: Colors.grey),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Producto: ${item.idProducto}',
                                        style: GoogleFonts.inter(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey[800],
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Cantidad: ${item.cantidad}',
                                        style: GoogleFonts.inter(fontSize: 13, color: Colors.grey[700]),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      }

                      return ListView.separated(
                        controller: scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        itemCount: productos.length,
                        separatorBuilder: (_, __) => const Divider(height: 16),
                        itemBuilder: (context, index) {
                          final p = productos[index];
                          final cant = cantidades[p.id] ?? 0;
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: _buildProductImageThumb(p.imagenUrl),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      p.nombre,
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey[800],
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Text(
                                          '\$${p.precio.toStringAsFixed(0)}',
                                          style: GoogleFonts.inter(
                                            fontSize: 13,
                                            color: Colors.grey[800],
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          'Cantidad: $cant',
                                          style: GoogleFonts.inter(fontSize: 13, color: Colors.grey[700]),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total de productos',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                      Text(
                        '${pedido.totalProductos}',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildProductImageThumb(String url) {
    if (url.isNotEmpty && (url.startsWith('http://') || url.startsWith('https://'))) {
      return Image.network(
        url,
        width: 36,
        height: 36,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            'lib/resources/temp/image.png',
            width: 36,
            height: 36,
            fit: BoxFit.cover,
          );
        },
      );
    }
    // Fallback a asset local si no hay URL
    return Image.asset(
      url.isNotEmpty ? url : 'lib/resources/temp/image.png',
      width: 36,
      height: 36,
      fit: BoxFit.cover,
    );
  }

  /// Obtiene el color según el estado del pedido
  Color _getColorEstado(String estado) {
    switch (estado) {
      case 'En Proceso':
        return Colors.orange;
      case 'En Camino':
        return Colors.blue;
      case 'Entregado':
        return Colors.green;
      case 'Cancelado':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  /// Formatea la fecha para mostrar
  String _formatearFecha(DateTime fecha) {
    return '${fecha.day.toString().padLeft(2, '0')}/${fecha.month.toString().padLeft(2, '0')}/${fecha.year} ${fecha.hour.toString().padLeft(2, '0')}:${fecha.minute.toString().padLeft(2, '0')}';
  }
}