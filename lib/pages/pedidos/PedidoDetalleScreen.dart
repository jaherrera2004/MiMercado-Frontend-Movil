import 'package:flutter/material.dart';
import '../../shared/widgets/widgets.dart';
import '../../models/Pedidos.dart';
import '../../models/Producto.dart';
import 'widgets/widgets.dart';

class DatosPedidosScreen extends StatefulWidget {
  const DatosPedidosScreen({super.key});

  @override
  State<DatosPedidosScreen> createState() => _DatosPedidosScreenState();
}

class _DatosPedidosScreenState extends State<DatosPedidosScreen> {
  bool isLoading = true;
  List<Map<String, dynamic>> productosDetalle = [];
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (isLoading) {
      _cargarProductos();
    }
  }

  Future<void> _cargarProductos() async {
    final Map<String, dynamic>? pedidoArgs = 
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    
    if (pedidoArgs != null && pedidoArgs['pedidoCompleto'] != null) {
      final Pedido pedido = pedidoArgs['pedidoCompleto'] as Pedido;
      
      // Cargar información detallada de cada producto
      final List<Map<String, dynamic>> productos = [];
      
      for (var productoPedido in pedido.listaProductos) {
        try {
          // Obtener el producto completo desde Firebase
          final producto = await Producto.obtenerProductoPorId(productoPedido.idProducto);
          
          if (producto != null) {
            productos.add({
              'nombre': producto.nombre,
              'precio': producto.precio,
              'cantidad': productoPedido.cantidad,
              'imagen': producto.imagenUrl.isNotEmpty ? producto.imagenUrl : 'lib/resources/temp/image.png',
            });
          }
        } catch (e) {
          print('Error cargando producto ${productoPedido.idProducto}: $e');
          // Agregar producto con datos mínimos si falla
          productos.add({
            'nombre': 'Producto ${productoPedido.idProducto}',
            'precio': 0.0,
            'cantidad': productoPedido.cantidad,
            'imagen': 'lib/resources/temp/panbimbo.png',
          });
        }
      }
      
      setState(() {
        productosDetalle = productos;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Obtener argumentos del pedido
    final Map<String, dynamic>? pedidoArgs = 
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    
    // Datos por defecto si no se pasan argumentos
    final Map<String, dynamic> pedido = pedidoArgs ?? {
      'numero': 1,
      'direccion': 'Carrera 15 #123-45, Chapinero',
      'fecha': '2024-03-15',
      'estado': 'Entregado',
      'total': 58000,
    };

    // Calcular subtotal, domicilio y servicio
    final double total = pedido['total']?.toDouble() ?? 0.0;
    final double domicilio = 5000.0; // Valor fijo por ahora
    final double servicio = 3000.0; // Valor fijo por ahora
    final double subtotal = total - domicilio - servicio;

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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
                    subtotal: subtotal,
                    domicilio: domicilio,
                    servicio: servicio,
                    total: total,
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Lista de productos
                  PedidoProductos(productos: productosDetalle),
                ],
              ),
            ),
    );
  }
}
