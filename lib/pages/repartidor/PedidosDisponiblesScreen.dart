import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/Pedidos.dart';
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
    
    try {
      // Cargar pedidos en proceso desde Firebase
      final List<Pedido> pedidos = await Pedido.obtenerPedidosEnProceso();
      
      setState(() {
        _pedidos = pedidos;
        _isLoading = false;
      });
      
      // Mostrar mensaje de éxito si se cargaron pedidos
      if (pedidos.isNotEmpty) {
        _mostrarMensaje(
          '${pedidos.length} pedidos disponibles cargados', 
          const Color(0xFF58E181)
        );
      }
      
    } catch (e) {
      print('Error cargando pedidos: $e');
      setState(() {
        _pedidos = [];
        _isLoading = false;
      });
      
      _mostrarMensaje(
        'Error al cargar pedidos: ${e.toString()}', 
        Colors.red[600]!
      );
    }
  }

  Future<void> _tomarPedido(int index) async {
    final Pedido pedido = _pedidos[index];
    
    ConfirmarPedidoDialog.mostrar(
      context,
      () async {
        try {
          // Mostrar indicador de carga
          _mostrarMensaje('Tomando pedido...', Colors.blue[600]!);
          
          // Usar el nuevo método completo para tomar el pedido
          final bool exito = await pedido.serTomadoPorRepartidor();
          
          if (exito) {
            _mostrarMensaje(
              'Pedido tomado exitosamente',
              const Color(0xFF58E181)
            );
            
            // Remover el pedido de la lista local
            setState(() {
              _pedidos.removeAt(index);
            });
          } else {
            _mostrarMensaje(
              'No se pudo tomar el pedido',
              Colors.red[600]!
            );
          }
          
        } catch (e) {
          print('Error tomando pedido: $e');
          String mensajeError = 'Error al tomar el pedido';
          
          // Personalizar mensaje según el tipo de error
          if (e.toString().contains('ya no está disponible')) {
            mensajeError = 'El pedido ya fue tomado por otro repartidor';
          } else if (e.toString().contains('No se pudo obtener el ID del repartidor')) {
            mensajeError = 'Error de sesión. Inicia sesión nuevamente';
          }
          
          _mostrarMensaje(mensajeError, Colors.red[600]!);
          
          // Recargar la lista para mostrar el estado actualizado
          _cargarPedidos();
        }
      },
    );
  }

  /// Muestra un mensaje en la pantalla
  void _mostrarMensaje(String mensaje, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          mensaje,
          style: GoogleFonts.inter(color: Colors.white),
        ),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
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
            'No hay pedidos en proceso',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Los pedidos en proceso aparecerán aquí',
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