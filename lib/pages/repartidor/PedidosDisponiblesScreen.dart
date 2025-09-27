import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'widgets/pedidosDisponibles/pedido_model.dart';
import 'widgets/pedidosDisponibles/pedido_card.dart';
import 'widgets/pedidosDisponibles/confirmar_pedido_dialog.dart';

class PedidosDisponiblesScreen extends StatefulWidget {
  const PedidosDisponiblesScreen({super.key});

  @override
  State<PedidosDisponiblesScreen> createState() => _PedidosDisponiblesScreenState();
}

class _PedidosDisponiblesScreenState extends State<PedidosDisponiblesScreen> {
  bool _isLoading = true;
  List<Pedido> _pedidos = [];

  @override
  void initState() {
    super.initState();
    _cargarPedidos();
  }

  Future<void> _cargarPedidos() async {
    setState(() {
      _isLoading = true;
    });
    
    // Simular carga de datos
    await Future.delayed(const Duration(seconds: 1));
    
    setState(() {
      _pedidos = Pedido.pedidosEjemplo;
      _isLoading = false;
    });
  }

  void _tomarPedido(int index) {
    ConfirmarPedidoDialog.mostrar(
      context,
      () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Pedido tomado exitosamente',
              style: GoogleFonts.inter(),
            ),
            backgroundColor: const Color(0xFF58E181),
          ),
        );
        
        // Remover el pedido de la lista
        setState(() {
          _pedidos.removeAt(index);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Pedidos Disponibles',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF58E181),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _cargarPedidos,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF58E181),
              ),
            )
          : _pedidos.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                  onRefresh: _cargarPedidos,
                  color: const Color(0xFF58E181),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _pedidos.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: PedidoCard(
                          pedido: _pedidos[index],
                          onTomarPedido: () => _tomarPedido(index),
                        ),
                      );
                    },
                  ),
                ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No hay pedidos disponibles',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Revisa nuevamente en unos minutos',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _cargarPedidos,
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