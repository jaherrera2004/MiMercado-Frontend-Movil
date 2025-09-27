import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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

  @override
  void initState() {
    super.initState();
    _cargarHistorial();
  }

  Future<void> _cargarHistorial() async {
    setState(() {
      _isLoading = true;
    });
    
    // Simular carga de datos
    await Future.delayed(const Duration(seconds: 1));
    
    setState(() {
      _historialPedidos = HistorialPedido.historialEjemplo;
      _isLoading = false;
    });
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
    final cancelados = _historialPedidos.length - entregados;

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
          _buildEstadisticaItem(
            'Cancelados',
            cancelados.toString(),
            Colors.red,
            Icons.cancel,
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
}