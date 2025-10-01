import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/Repartidor.dart';
import '../../models/Pedidos.dart';
import 'widgets/historialPedidos/historial_pedido_model.dart';
import 'widgets/historialPedidos/historial_card.dart';

class HistorialPedidosScreen extends StatefulWidget {
  const HistorialPedidosScreen({super.key});

  @override
  State<HistorialPedidosScreen> createState() => _HistorialPedidosScreenState();
}

class _HistorialPedidosScreenState extends State<HistorialPedidosScreen> {
  bool _isLoading = true;
  List<HistorialPedido> _historialPedidos = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    _cargarHistorial();
  }

  Future<void> _cargarHistorial() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    
    try {
      // Obtener IDs del historial desde Firebase
      final List<String> historialIds = await Repartidor.obtenerHistorialPedidos();
      
      if (historialIds.isEmpty) {
        setState(() {
          _historialPedidos = [];
          _isLoading = false;
        });
        return;
      }

      // Cargar detalles de cada pedido
      final List<Pedido> pedidosCompletos = [];
      final List<HistorialPedido> historialCompleto = [];

      for (String pedidoId in historialIds) {
        try {
          final Pedido? pedido = await Pedido.obtenerPedidoPorId(pedidoId);
          if (pedido != null) {
            pedidosCompletos.add(pedido);
            
            // Convertir Pedido a HistorialPedido para la UI
            final historialPedido = HistorialPedido(
              id: pedido.id.substring(0, 8) + '...',
              cliente: pedido.idUsuario.substring(0, 8) + '...',
              direccion: pedido.direccion,
              total: pedido.costoTotal.toInt(),
              fecha: _formatearFecha(pedido.fecha),
              estado: pedido.estado == Pedido.estadoEntregado 
                  ? EstadoPedido.entregado 
                  : EstadoPedido.cancelado,
              tiempo: _calcularTiempoEntrega(pedido.fecha),
              distancia: '2.5 km', // Placeholder - se puede calcular después
            );
            
            historialCompleto.add(historialPedido);
          }
        } catch (e) {
          print('Error cargando pedido $pedidoId: $e');
          // Continuar con los demás pedidos
        }
      }

      // Ordenar por fecha (más recientes primero)
      historialCompleto.sort((a, b) => b.fecha.compareTo(a.fecha));
      
      setState(() {
        _historialPedidos = historialCompleto;
        _isLoading = false;
      });
      
    } catch (e) {
      print('Error cargando historial: $e');
      setState(() {
        _error = 'Error al cargar el historial: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Historial de Pedidos',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF58E181),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _cargarHistorial,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF58E181),
              ),
            )
          : _error != null
              ? _buildErrorState()
              : _historialPedidos.isEmpty
                  ? _buildEmptyState()
                  : Column(
                  children: [
                    // Estadísticas rápidas
                    _buildEstadisticas(),
                    
                    // Lista de pedidos
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: _cargarHistorial,
                        color: const Color(0xFF58E181),
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _historialPedidos.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: HistorialCard(
                                pedido: _historialPedidos[index],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildEstadisticas() {
    final entregados = _historialPedidos.where((p) => p.fueEntregado).length;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildEstadisticaItem(
            'Entregados',
            entregados.toString(),
            Colors.green,
            Icons.check_circle,
          ),
        ],
      ),
    );
  }

  Widget _buildEstadisticaItem(String titulo, String valor, Color color, IconData icono) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icono,
            color: color,
            size: 20,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          valor,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        Text(
          titulo,
          style: GoogleFonts.inter(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No hay historial de pedidos',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tus pedidos completados aparecerán aquí',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _cargarHistorial,
            icon: const Icon(Icons.refresh),
            label: Text(
              'Actualizar',
              style: GoogleFonts.inter(fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF58E181),
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Error al cargar historial',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              _error ?? 'Ha ocurrido un error inesperado',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _cargarHistorial,
            icon: const Icon(Icons.refresh),
            label: Text(
              'Reintentar',
              style: GoogleFonts.inter(fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF58E181),
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  /// Formatear fecha para mostrar en el historial
  String _formatearFecha(DateTime fecha) {
    final now = DateTime.now();
    final difference = now.difference(fecha);

    if (difference.inDays == 0) {
      // Hoy
      return 'Hoy ${fecha.hour.toString().padLeft(2, '0')}:${fecha.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      // Ayer
      return 'Ayer ${fecha.hour.toString().padLeft(2, '0')}:${fecha.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays < 7) {
      // Esta semana
      const dias = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];
      return '${dias[fecha.weekday - 1]} ${fecha.hour.toString().padLeft(2, '0')}:${fecha.minute.toString().padLeft(2, '0')}';
    } else {
      // Fecha completa
      return '${fecha.day.toString().padLeft(2, '0')}/${fecha.month.toString().padLeft(2, '0')}/${fecha.year}';
    }
  }

  /// Calcular tiempo estimado de entrega basado en la fecha del pedido
  String _calcularTiempoEntrega(DateTime fechaPedido) {
    final now = DateTime.now();
    final difference = now.difference(fechaPedido);

    if (difference.inHours < 1) {
      return '${difference.inMinutes} min';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ${difference.inMinutes % 60}min';
    } else {
      return '${difference.inDays} días';
    }
  }
}