import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mi_mercado/core/di/injection.dart';
import 'package:mi_mercado/features/pedidos/domain/entities/Pedido.dart';
import 'package:mi_mercado/features/repartidor/pedidos/presentation/controllers/productos_pedido_controller.dart';
import 'package:mi_mercado/features/usuario/productos/domain/entities/Producto.dart';

class ProductosPedidoModal {
  static void mostrar(List<ProductoPedido> productosPedido) {
    Get.dialog(
      _ProductosPedidoModalContent(productosPedido: productosPedido),
      barrierDismissible: true,
    );
  }
}

class _ProductosPedidoModalContent extends StatefulWidget {
  final List<ProductoPedido> productosPedido;

  const _ProductosPedidoModalContent({
    required this.productosPedido,
  });

  @override
  State<_ProductosPedidoModalContent> createState() => _ProductosPedidoModalContentState();
}

class _ProductosPedidoModalContentState extends State<_ProductosPedidoModalContent> {
  late ProductosPedidoController controller;
  late String tag;

  @override
  void initState() {
    super.initState();
    // Crear una instancia específica del controlador para este modal
    controller = ProductosPedidoController(
      obtenerProductosPedido: getIt(),
    );
    tag = 'modal_${controller.hashCode}';
    Get.put(controller, tag: tag);

    // Cargar productos cuando se abre el modal
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final productoIds = widget.productosPedido.map((p) => p.idProducto).toList();
      controller.cargarProductosPedido(productoIds);
    });
  }

  @override
  void dispose() {
    // Limpiar el controlador cuando se cierra el modal
    Get.delete<ProductosPedidoController>(tag: tag);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
          maxWidth: MediaQuery.of(context).size.width * 0.9,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF58E181),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.shopping_bag,
                    color: Colors.white,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Productos del Pedido',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Flexible(
              child: Obx(() {
                final ctrl = Get.find<ProductosPedidoController>(tag: tag);
                if (ctrl.isLoading.value) {
                  return Container(
                    padding: const EdgeInsets.all(40),
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF58E181)),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Cargando productos...',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (ctrl.errorMessage.value != null) {
                  return Container(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 48,
                          color: Colors.red[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error al cargar productos',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          ctrl.errorMessage.value!,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () {
                            final productoIds = widget.productosPedido.map((p) => p.idProducto).toList();
                            ctrl.cargarProductosPedido(productoIds);
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text('Reintentar'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF58E181),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final productos = ctrl.productos;

                if (productos.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(40),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.inventory_2_outlined,
                          size: 48,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No hay productos',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(16),
                  itemCount: productos.length,
                  separatorBuilder: (_, __) => const Divider(height: 16),
                  itemBuilder: (context, index) {
                    final producto = productos[index];
                    final productoPedido = widget.productosPedido.firstWhere(
                      (pp) => pp.idProducto == producto.id,
                      orElse: () => ProductoPedido(idProducto: producto.id, cantidad: 0),
                    );
                    return _buildProductoItem(producto, productoPedido.cantidad);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductoItem(Producto producto, int cantidad) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen del producto (placeholder por ahora)
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: producto.imagenUrl.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      producto.imagenUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Icon(
                        Icons.image_not_supported,
                        color: Colors.grey[400],
                        size: 24,
                      ),
                    ),
                  )
                : Icon(
                    Icons.inventory_2,
                    color: Colors.grey[400],
                    size: 24,
                  ),
          ),

          const SizedBox(width: 12),

          // Información del producto
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  producto.nombre,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  producto.descripcion,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: Colors.grey[600],
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${producto.precio.toStringAsFixed(0)}',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF58E181),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF58E181).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Cantidad: $cantidad',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF58E181),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}