import 'package:flutter/material.dart';
import '../../shared/widgets/widgets.dart';
import 'widgets/widgets.dart';

class DatosPedidosScreen extends StatelessWidget {
  const DatosPedidosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtener argumentos del pedido (en una app real, esto vendría del routing)
    final Map<String, dynamic>? pedidoArgs = 
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    
    // Datos por defecto si no se pasan argumentos
    final Map<String, dynamic> pedido = pedidoArgs ?? {
      'numero': 1,
      'direccion': 'Carrera 15 #123-45, Chapinero',
      'fecha': '2024-03-15',
      'estado': 'Entregado',
      'total': 58000,
      'subtotal': 50000,
      'domicilio': 5000,
      'servicio': 3000,
    };

    final List<Map<String, dynamic>> productos = [
      {
        'nombre': 'Bimbo Pan Blanco',
        'precio': 6000,
        'cantidad': 1,
        'imagen': 'lib/resources/temp/panbimbo.png',
      },
      {
        'nombre': 'Corona 6 pack',
        'precio': 18000,
        'cantidad': 2,
        'imagen': 'lib/resources/temp/coronitasixpack.png',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0),
              child: CustomBackButton(
                iconPath: 'lib/resources/go_back_icon.png',
                size: 40,
              ),
            ),
        title: PageTitle(title: "Pedido #${pedido['numero']}"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Información del pedido
            PedidoInfo(
              numeroPedido: pedido['numero'].toString(),
              direccion: pedido['direccion'] ?? 'Dirección no disponible',
              fecha: pedido['fecha'],
              estado: pedido['estado'],
            ),
            
            const SizedBox(height: 24),
            
            // Resumen de costos
            PedidoResumen(
              subtotal: pedido['subtotal']?.toDouble(),
              domicilio: pedido['domicilio']?.toDouble(),
              servicio: pedido['servicio']?.toDouble(),
              total: pedido['total']?.toDouble() ?? 0.0,
            ),
            
            const SizedBox(height: 24),
            
            // Lista de productos
            PedidoProductos(productos: productos),
          ],
        ),
      ),
    );
  }
}
