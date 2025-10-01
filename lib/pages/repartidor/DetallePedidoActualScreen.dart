import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/Pedidos.dart';
import '../../models/Repartidor.dart';
import 'RepartidorPageScreen.dart';

class DetallePedidoActualScreen extends StatefulWidget {
  final Pedido pedido;

  const DetallePedidoActualScreen({
    super.key,
    required this.pedido,
  });

  @override
  State<DetallePedidoActualScreen> createState() => _DetallePedidoActualScreenState();
}

class _DetallePedidoActualScreenState extends State<DetallePedidoActualScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Pedido Actual',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF58E181),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: _volverAlPanel,
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF58E181),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Estado del pedido
                  _buildEstadoCard(),
                  
                  const SizedBox(height: 16),
                  
                  // Información del pedido
                  _buildInformacionCard(),
                  
                  const SizedBox(height: 16),
                  
                  // Dirección de entrega
                  _buildDireccionCard(),
                  
                  const SizedBox(height: 16),
                  
                  // Lista de productos
                  _buildProductosCard(),
                  
                  const SizedBox(height: 16),
                  
                  // Resumen de costos
                  _buildResumenCard(),
                  
                  const SizedBox(height: 24),
                  
                  // Botones de acción
                  _buildBotonesAccion(),
                ],
              ),
            ),
    );
  }

  Widget _buildEstadoCard() {
    Color estadoColor = _getColorEstado(widget.pedido.estado);
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [estadoColor.withOpacity(0.1), estadoColor.withOpacity(0.05)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: estadoColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(
                Icons.delivery_dining,
                color: estadoColor,
                size: 32,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              widget.pedido.estado,
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: estadoColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Pedido ID: ${widget.pedido.id.substring(0, 8)}...',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInformacionCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: const Color(0xFF58E181),
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Información del Pedido',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Fecha', _formatearFecha(widget.pedido.fecha)),
            const SizedBox(height: 12),
            _buildInfoRow('Cliente', widget.pedido.idUsuario.substring(0, 8) + '...'),
            const SizedBox(height: 12),
            _buildInfoRow('Total de productos', '${widget.pedido.totalProductos} items'),
          ],
        ),
      ),
    );
  }

  Widget _buildDireccionCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: Colors.red[600],
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Dirección de Entrega',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Text(
                widget.pedido.direccion,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: Colors.grey[800],
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductosCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.shopping_bag,
                  color: Colors.orange[600],
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Productos del Pedido',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (widget.pedido.listaProductos.isEmpty)
              Text(
                'No hay productos en este pedido',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              )
            else
              ...widget.pedido.listaProductos.map((producto) => 
                _buildProductoItem(producto)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildProductoItem(ProductoPedido producto) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF58E181).withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.inventory_2,
              color: Color(0xFF58E181),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Producto ID: ${producto.idProducto.substring(0, 8)}...',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
                Text(
                  'Cantidad: ${producto.cantidad}',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResumenCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.receipt_long,
                  color: const Color(0xFF58E181),
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Resumen de Pago',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildPrecioRow('Subtotal', '\$${(widget.pedido.costoTotal - ProductoPedido.valorDomicilio).toStringAsFixed(0)}'),
            const SizedBox(height: 8),
            _buildPrecioRow('Domicilio', '\$${ProductoPedido.valorDomicilio.toStringAsFixed(0)}'),
            const Divider(height: 24),
            _buildPrecioRow(
              'Total a Cobrar',
              '\$${widget.pedido.costoTotal.toStringAsFixed(0)}',
              isTotal: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBotonesAccion() {
    return Column(
      children: [
        if (widget.pedido.estado == Pedido.estadoEnCamino) ...[
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _marcarComoEntregado,
              icon: const Icon(Icons.check_circle),
              label: Text(
                'Marcar como Entregado',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[600],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => _volverAlPanel(),
            icon: const Icon(Icons.arrow_back),
            label: Text(
              'Volver al Panel',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF58E181),
              side: const BorderSide(color: Color(0xFF58E181)),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            '$label:',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.grey[800],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPrecioRow(String label, String valor, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
            color: isTotal ? Colors.grey[800] : Colors.grey[600],
          ),
        ),
        Text(
          valor,
          style: GoogleFonts.inter(
            fontSize: isTotal ? 18 : 14,
            fontWeight: FontWeight.w700,
            color: isTotal ? const Color(0xFF58E181) : Colors.grey[800],
          ),
        ),
      ],
    );
  }

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

  String _formatearFecha(DateTime fecha) {
    return '${fecha.day.toString().padLeft(2, '0')}/${fecha.month.toString().padLeft(2, '0')}/${fecha.year} ${fecha.hour.toString().padLeft(2, '0')}:${fecha.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _marcarComoEntregado() async {
    try {
      setState(() {
        _isLoading = true;
      });

      // 1. Actualizar el estado del pedido a "Entregado"
      await widget.pedido.actualizarEstado(Pedido.estadoEntregado);

      // 2. Agregar el pedido al historial del repartidor
      final bool historialActualizado = await Repartidor.agregarPedidoAlHistorial(widget.pedido.id);
      
      if (!historialActualizado) {
        print('Advertencia: No se pudo agregar el pedido al historial del repartidor');
      }

      // 3. Liberar el pedido actual del repartidor
      await Repartidor.liberarPedidoActual();

      // 4. Cambiar estado del repartidor a "Disponible"
      final bool estadoCambiado = await Repartidor.cambiarEstado(EstadoRepartidor.conectado);
      
      if (!estadoCambiado) {
        print('Advertencia: No se pudo cambiar el estado del repartidor a disponible');
      }

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  historialActualizado 
                    ? 'Pedido entregado y repartidor disponible'
                    : 'Pedido entregado (verificar historial)',
                  style: GoogleFonts.inter(color: Colors.white),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.green[600],
          duration: const Duration(seconds: 3),
        ),
      );

      // Volver al panel principal
      _volverAlPanel();

    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                'Error al actualizar el pedido',
                style: GoogleFonts.inter(color: Colors.white),
              ),
            ],
          ),
          backgroundColor: Colors.red[600],
        ),
      );
    }
  }

  /// Navegar de vuelta al panel del repartidor
  void _volverAlPanel() {
    // Usar pushReplacement para reemplazar la pantalla actual
    // y evitar que el usuario pueda volver a esta pantalla
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const RepartidorPage(),
      ),
    );
  }
}