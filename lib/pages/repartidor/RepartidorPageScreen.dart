import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/Repartidor.dart';
import '../../models/Pedidos.dart';
import '../../models/SharedPreferences.dart';
import 'widgets/repartidorPage/disponibilidad_selector.dart';
import 'widgets/repartidorPage/estado_indicator.dart';
import 'widgets/repartidorPage/pedidos_navigation.dart';
import 'DetallePedidoActualScreen.dart';

class RepartidorPage extends StatefulWidget {
  const RepartidorPage({super.key});

  @override
  State<RepartidorPage> createState() => _RepartidorPageState();
}

class _RepartidorPageState extends State<RepartidorPage> {
  String _estadoActual = 'Desconectado';
  bool _isLoading = true;
  String? _pedidoActualId;
  bool _tienePedidoActivo = false;
  
  @override
  void initState() {
    super.initState();
    _cargarEstadoInicial();
  }

  /// Carga el estado inicial del repartidor desde Firebase
  Future<void> _cargarEstadoInicial() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final EstadoRepartidor? estadoActual = await Repartidor.obtenerEstadoActual();
      final String? pedidoActual = await Repartidor.obtenerPedidoActual();
      
      if (estadoActual != null) {
        setState(() {
          _estadoActual = estadoActual.displayName;
          _pedidoActualId = pedidoActual;
          _tienePedidoActivo = pedidoActual != null && pedidoActual.isNotEmpty;
          _isLoading = false;
        });
      } else {
        // Si no se puede obtener el estado, usar el de SharedPreferences como fallback
        final String? estadoLocal = await SharedPreferencesService.getCurrentEstadoActual();
        final String? pedidoLocal = await SharedPreferencesService.getCurrentPedidoActual();
        setState(() {
          _estadoActual = estadoLocal ?? 'Desconectado';
          _pedidoActualId = pedidoLocal;
          _tienePedidoActivo = pedidoLocal != null && pedidoLocal.isNotEmpty;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error cargando estado inicial: $e');
      setState(() {
        _estadoActual = 'Desconectado';
        _pedidoActualId = null;
        _tienePedidoActivo = false;
        _isLoading = false;
      });
      _mostrarMensajeError('Error al cargar el estado del repartidor');
    }
  }
  
  /// Cambia el estado del repartidor usando Firebase
  Future<void> _cambiarEstado(String nuevoEstado) async {
    try {
      // Mostrar indicador de carga
      _mostrarMensajeCarga('Actualizando estado...');
      
      // Convertir string a enum
      final EstadoRepartidor estadoEnum = EstadoRepartidor.fromString(nuevoEstado);
      
      // Cambiar estado en Firebase
      final bool exitoso = await Repartidor.cambiarEstado(estadoEnum);
      
      if (exitoso) {
        setState(() {
          _estadoActual = nuevoEstado;
        });
        _mostrarMensajeExito('Estado actualizado exitosamente');
      } else {
        _mostrarMensajeError('Error al actualizar el estado');
      }
    } catch (e) {
      print('Error al cambiar estado: $e');
      _mostrarMensajeError('Error al actualizar el estado');
    }
  }



  /// Ver detalles del pedido actual del repartidor
  Future<void> _verPedidoActual() async {
    if (!_tienePedidoActivo || _pedidoActualId == null) {
      _mostrarMensajeError('No tienes un pedido activo');
      return;
    }

    try {
      _mostrarMensajeCarga('Cargando detalles del pedido...');
      
      final Pedido? pedido = await Pedido.obtenerPedidoPorId(_pedidoActualId!);
      
      Navigator.of(context).pop(); // Cerrar el mensaje de carga
      
      if (pedido != null) {
        // Navegar directamente a la pantalla de detalles
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => DetallePedidoActualScreen(
              pedido: pedido,
            ),
          ),
        );
      } else {
        _mostrarMensajeError('No se encontró el pedido');
      }
    } catch (e) {
      Navigator.of(context).pop(); // Cerrar el mensaje de carga
      print('Error obteniendo pedido actual: $e');
      _mostrarMensajeError('Error al cargar el pedido');
    }
  }

  void _mostrarDialogoCerrarSesion() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                Icons.logout,
                color: Colors.red[600],
                size: 28,
              ),
              const SizedBox(width: 12),
              Text(
                'Cerrar sesión',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: Text(
            '¿Estás seguro de que quieres cerrar sesión? Se perderá tu estado actual de conexión.',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancelar',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _cerrarSesion();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[600],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Cerrar sesión',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Muestra un mensaje de carga
  void _mostrarMensajeCarga(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              mensaje,
              style: GoogleFonts.inter(color: Colors.white),
            ),
          ],
        ),
        backgroundColor: Colors.blue[600],
        duration: const Duration(seconds: 1),
      ),
    );
  }

  /// Muestra un mensaje de éxito
  void _mostrarMensajeExito(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              mensaje,
              style: GoogleFonts.inter(color: Colors.white),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF58E181),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Muestra un mensaje de error
  void _mostrarMensajeError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.error,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              mensaje,
              style: GoogleFonts.inter(color: Colors.white),
            ),
          ],
        ),
        backgroundColor: Colors.red[600],
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _cerrarSesion() async {
    try {
      // Cambiar estado a desconectado antes de cerrar sesión
      await Repartidor.cambiarEstado(EstadoRepartidor.desconectado);
      
      // Limpiar datos de sesión
      await SharedPreferencesService.clearSessionData();
      
      setState(() {
        _estadoActual = 'Desconectado';
      });
    } catch (e) {
      print('Error al cerrar sesión: $e');
      // Continuar con el cierre de sesión aunque falle la actualización del estado
    }
    
    // Mostrar mensaje de confirmación
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Sesión cerrada exitosamente',
              style: GoogleFonts.inter(color: Colors.white),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF58E181),
        duration: const Duration(seconds: 2),
      ),
    );
    
    // Navegar de vuelta al login o pantalla principal
    Navigator.of(context).pushNamedAndRemoveUntil(
      '/', // Ruta del login o pantalla principal
      (Route<dynamic> route) => false,
    );
  }

  Widget _buildBotonPedidoActual() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ElevatedButton.icon(
        onPressed: _tienePedidoActivo ? _verPedidoActual : null,
        icon: Icon(
          _tienePedidoActivo ? Icons.delivery_dining : Icons.assignment_outlined,
          color: Colors.white,
        ),
        label: Text(
          _tienePedidoActivo ? 'Ver Pedido Actual' : 'Sin Pedido Asignado',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: _tienePedidoActivo 
              ? const Color(0xFF58E181)
              : Colors.grey[400],
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget _buildBotonCerrarSesion() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: OutlinedButton.icon(
        onPressed: _mostrarDialogoCerrarSesion,
        icon: Icon(
          Icons.logout,
          color: Colors.red[600],
        ),
        label: Text(
          'Cerrar sesión',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.red[600],
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.red[600]!),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Panel Repartidor',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF58E181),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _cargarEstadoInicial,
            tooltip: 'Actualizar estado',
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: _mostrarDialogoCerrarSesion,
            tooltip: 'Cerrar sesión',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF58E181)),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Cargando estado del repartidor...',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _cargarEstadoInicial,
              color: const Color(0xFF58E181),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Estado actual
                    EstadoIndicator(estado: _estadoActual),
                    
                    const SizedBox(height: 24),
                    
                    // Selector de disponibilidad
                    DisponibilidadSelector(
                      estadoActual: _estadoActual,
                      onEstadoChanged: _cambiarEstado,
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Navegación a pedidos
                    const PedidosNavigation(),
                    
                    const SizedBox(height: 24),
                    
                    // Botón para ver pedido actual
                    _buildBotonPedidoActual(),
                    
                    const SizedBox(height: 24),
                    
                    // Botón de cerrar sesión
                    _buildBotonCerrarSesion(),
                  ],
                ),
              ),
            ),
    );
  }
}