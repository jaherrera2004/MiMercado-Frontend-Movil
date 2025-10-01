import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/CarritoService.dart' as carrito_service;
import '../../models/Pedidos.dart';
import '../../models/Usuario.dart';
import '../../models/SharedPreferences.dart';
import 'widgets/widgets.dart';

class PagoScreen extends StatefulWidget {
  const PagoScreen({super.key});

  @override
  State<PagoScreen> createState() => _PagoScreenState();
}

class _PagoScreenState extends State<PagoScreen> {
  bool _isLoading = false;
  late final carrito_service.CarritoService _carritoService;
  
  // Direcciones
  List<Map<String, dynamic>> _direcciones = [];
  String? _direccionSeleccionada;
  bool _cargandoDirecciones = true;
  
  // Valores de costos
  late final double _valorDomicilio;
  final double _valorServicio = 2000;

  @override
  void initState() {
    super.initState();
    _carritoService = carrito_service.CarritoService();
    _valorDomicilio = ProductoPedido.valorDomicilio;
    _cargarDirecciones();
  }

  Future<void> _cargarDirecciones() async {
    try {
      final direcciones = await Usuario.obtenerDireccionesActuales();
      setState(() {
        _direcciones = direcciones;
        _cargandoDirecciones = false;
        
        // Seleccionar la dirección principal por defecto
        if (direcciones.isNotEmpty) {
          final principal = direcciones.firstWhere(
            (dir) => dir['principal'] == true,
            orElse: () => direcciones.first,
          );
          _direccionSeleccionada = principal['direccion'];
        }
      });
    } catch (e) {
      print('Error cargando direcciones: $e');
      setState(() {
        _cargandoDirecciones = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Obtener datos del carrito de forma segura
    List<carrito_service.CarritoItem> itemsCarrito = [];
    double subtotal = 0.0;
    double total = 0.0;
    
    try {
      itemsCarrito = _carritoService.obtenerItems();
      subtotal = _carritoService.subtotal;
      total = subtotal + _valorDomicilio + _valorServicio;
    } catch (e) {
      print('Error obteniendo datos del carrito: $e');
    }
    
    // Verificar si el carrito está vacío
    if (itemsCarrito.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: const PagoAppBar(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                'Tu carrito está vacío',
                style: TextStyle(fontSize: 18, color: Colors.grey[600]),
              ),
              const SizedBox(height: 8),
              Text(
                'Agrega productos para realizar un pedido',
                style: TextStyle(fontSize: 14, color: Colors.grey[500]),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF58E181),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: const Text('Ir a comprar'),
              ),
            ],
          ),
        ),
      );
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const PagoAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título de dirección de envío
            Text(
              "Dirección de envío",
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            
            // Select de dirección de envío
            if (_cargandoDirecciones)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(child: CircularProgressIndicator()),
              )
            else if (_direcciones.isEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange, width: 1),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.location_off, color: Colors.orange, size: 40),
                    const SizedBox(height: 8),
                    Text(
                      'No tienes direcciones guardadas',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.orange[900],
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () => Navigator.pushNamed(context, '/direcciones'),
                      child: const Text('Agregar dirección'),
                    ),
                  ],
                ),
              )
            else
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF58E181).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF58E181).withOpacity(0.3),
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _direccionSeleccionada,
                    isExpanded: true,
                    icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF58E181)),
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                    items: _direcciones.map((direccion) {
                      return DropdownMenuItem<String>(
                        value: direccion['direccion'],
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              direccion['nombre'] ?? 'Sin nombre',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              direccion['direccion'],
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _direccionSeleccionada = newValue;
                      });
                    },
                  ),
                ),
              ),
            
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 24),

            // Resumen del pedido con datos reales del carrito
            PagoResumen(
              subtotal: subtotal,
              domicilio: _valorDomicilio,
              servicio: _valorServicio,
              total: total,
            ),
            
            const SizedBox(height: 32),

            // Botón realizar pedido
            PagoBotonPedido(
              isLoading: _isLoading,
              onPressed: () => _realizarPedido(itemsCarrito, total),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _realizarPedido(List<carrito_service.CarritoItem> items, double total) async {
    // Validar que haya una dirección seleccionada
    if (_direccionSeleccionada == null || _direccionSeleccionada!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor selecciona una dirección de envío'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Obtener el ID del usuario actual
      final String? userId = await SharedPreferencesService.getCurrentUserId();
      
      if (userId == null) {
        throw Exception('No hay usuario autenticado');
      }

      // Convertir items del carrito a ProductoPedido
      final List<ProductoPedido> listaProductos = items.map((item) {
        return ProductoPedido(
          idProducto: item.idProducto,
          cantidad: item.cantidad,
        );
      }).toList();

      // Crear el pedido
      final pedido = Pedido(
        id: '', // Se asignará por Firebase
        costoTotal: total,
        direccion: _direccionSeleccionada!,
        estado: 'En Proceso',
        fecha: DateTime.now(),
        idRepartidor: '', // Se asignará después
        idUsuario: userId,
        listaProductos: listaProductos,
      );

      // Guardar el pedido en Firebase
      final pedidoId = await Pedido.crearPedido(pedido);
      print('✅ Pedido creado con ID: $pedidoId');

      // Vaciar el carrito después de crear el pedido
      await _carritoService.vaciarCarrito();
      
      if (mounted) {
        // Mostrar mensaje de éxito
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Pedido realizado con éxito!'),
            backgroundColor: Color(0xFF58E181),
            duration: Duration(seconds: 2),
          ),
        );
        
        // Navegar a la pantalla de pedidos
        Navigator.pushReplacementNamed(context, '/pedidos');
      }
    } catch (e) {
      print('❌ Error al realizar pedido: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al procesar el pedido: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
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
