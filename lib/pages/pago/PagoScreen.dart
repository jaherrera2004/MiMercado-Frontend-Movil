import 'package:flutter/material.dart';
import 'widgets/widgets.dart';

class PagoScreen extends StatefulWidget {
  const PagoScreen({super.key});

  @override
  State<PagoScreen> createState() => _PagoScreenState();
}

class _PagoScreenState extends State<PagoScreen> {
  String _metodoSeleccionado = 'efectivo';
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const PagoAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dirección de envío
            DireccionEnvio(
              direccion: "Carrera 15 #123-45, Chapinero, Bogotá",
              onTap: () {
                // Navegar a selección de dirección
                Navigator.pushNamed(context, '/direcciones');
              },
            ),
            
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 24),

            const SizedBox(height: 24),

            // Resumen del pedido
            PagoResumen(
              subtotal: 24000,
              domicilio: 2000,
              servicio: 2000,
              total: 28000,
            ),
            
            const SizedBox(height: 32),

            // Botón realizar pedido
            PagoBotonPedido(
              isLoading: _isLoading,
              onPressed: _realizarPedido,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _realizarPedido() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Simular procesamiento del pedido
      await Future.delayed(const Duration(seconds: 2));
      
      if (mounted) {
        // Mostrar mensaje de éxito
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Pedido realizado con éxito!'),
            backgroundColor: Color(0xFF58E181),
          ),
        );
        
        // Navegar a la pantalla de pedidos
        Navigator.pushReplacementNamed(context, '/pedidos');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error al procesar el pedido'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
