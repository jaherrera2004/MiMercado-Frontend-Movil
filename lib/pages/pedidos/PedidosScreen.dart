import 'package:flutter/material.dart';
import '../homepage/widgets/HomeBottomNavigation.dart';
import '../../models/Pedidos.dart';
import 'widgets/widgets.dart';

class PedidosScreen extends StatefulWidget {
  const PedidosScreen({super.key});

  @override
  State<PedidosScreen> createState() => _PedidosScreenState();
}

class _PedidosScreenState extends State<PedidosScreen> {
  List<Map<String, dynamic>> pedidosEjemplo = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _cargarPedidos();
  }

  Future<void> _cargarPedidos() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      // Obtener los pedidos del usuario desde Firebase
      final List<Pedido> pedidos = await Pedido.obtenerPedidosPorUsuario();

      // Convertir los pedidos a formato Map con índice como número
      final List<Map<String, dynamic>> pedidosFormateados = [];
      for (int i = 0; i < pedidos.length; i++) {
        final pedido = pedidos[i];
        // Formatear fecha manualmente (YYYY-MM-DD)
        final fecha = pedido.fecha;
        final fechaFormateada = '${fecha.year}-${fecha.month.toString().padLeft(2, '0')}-${fecha.day.toString().padLeft(2, '0')}';
        
        pedidosFormateados.add({
          'numero': i + 1, // Usar el índice + 1 como número de pedido
          'direccion': pedido.direccion,
          'fecha': fechaFormateada,
          'estado': pedido.estado,
          'total': pedido.costoTotal,
          'id': pedido.id, // Incluir el ID real para navegación
          'pedidoCompleto': pedido, // Guardar el objeto completo por si se necesita
        });
      }

      setState(() {
        pedidosEjemplo = pedidosFormateados;
        isLoading = false;
      });

    } catch (e) {
      print('Error cargando pedidos: $e');
      setState(() {
        errorMessage = 'Error al cargar los pedidos: ${e.toString()}';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: const PedidosAppBar(),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : errorMessage != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 64, color: Colors.red),
                        const SizedBox(height: 16),
                        Text(
                          errorMessage!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _cargarPedidos,
                          child: const Text('Reintentar'),
                        ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _cargarPedidos,
                    child: PedidosList(
                      pedidos: pedidosEjemplo,
                      onTapPedido: (pedido) {
                        Navigator.pushNamed(
                          context,
                          '/detalle-pedido',
                          arguments: pedido,
                        );
                      },
                    ),
                  ),
        bottomNavigationBar: const HomeBottomNavigation(currentIndex: 2),
      ),
    );
  }
}
