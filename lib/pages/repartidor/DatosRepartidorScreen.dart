import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/Repartidor.dart';
import 'widgets/datosRepartidor/repartidor_data_model.dart';
import 'widgets/datosRepartidor/perfil_header.dart';
import 'widgets/datosRepartidor/seccion_informacion.dart';
import 'widgets/datosRepartidor/info_item.dart';

class DatosPersonalesRepartidorScreen extends StatefulWidget {
  const DatosPersonalesRepartidorScreen({super.key});

  @override
  State<DatosPersonalesRepartidorScreen> createState() => _DatosPersonalesRepartidorScreenState();
}

class _DatosPersonalesRepartidorScreenState extends State<DatosPersonalesRepartidorScreen> {
  bool _isLoading = true;
  RepartidorData? _datosRepartidor;

  @override
  void initState() {
    super.initState();
    _cargarDatosPersonales();
  }

  Future<void> _cargarDatosPersonales() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      // Obtener datos del repartidor desde Firebase
      final Repartidor? repartidor = await Repartidor.obtenerRepartidorActual();
      
      if (repartidor != null) {
        // Convertir datos reales a RepartidorData para la UI
        final repartidorData = RepartidorData(
          nombre: '${repartidor.nombre ?? ''} ${repartidor.apellido ?? ''}'.trim(),
          cedula: repartidor.cedula.isNotEmpty ? repartidor.cedula : 'No especificada',
          telefono: repartidor.telefono?.isNotEmpty == true ? repartidor.telefono! : 'No especificado',
          email: repartidor.email?.isNotEmpty == true ? repartidor.email! : 'No especificado',
          // Campos con valores por defecto ya que no están en Firebase
          fechaIngreso: '', // Campo eliminado
          vehiculo: 'No especificado',
          placa: 'No especificada',
          licencia: 'No especificada',
          calificacion: 0.0,
          totalPedidos: 0,
          estado: 'No especificado',
          zona: 'No especificada',
          banco: 'No especificado',
          numeroCuenta: 'No especificada',
          direccion: '', // Campo eliminado
        );
        
        setState(() {
          _datosRepartidor = repartidorData;
          _isLoading = false;
        });
      } else {
        setState(() {
          _datosRepartidor = null;
          _isLoading = false;
        });
      }
      
    } catch (e) {
      print('Error cargando datos del repartidor: $e');
      setState(() {
        _datosRepartidor = null;
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
          'Información Personal',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF58E181),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF58E181),
              ),
            )
          : _datosRepartidor == null
              ? const Center(child: Text('Error al cargar los datos'))
              : RefreshIndicator(
                  onRefresh: _cargarDatosPersonales,
                  color: const Color(0xFF58E181),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header con foto y datos básicos
                        PerfilHeader(repartidor: _datosRepartidor!),
                        
                        const SizedBox(height: 24),
                        
                        // Información personal
                        SeccionInformacion(
                          titulo: 'Información Personal',
                          items: [
                            InfoItem(icon: Icons.badge, label: 'Cédula', value: _datosRepartidor!.cedula),
                            InfoItem(icon: Icons.phone, label: 'Teléfono', value: _datosRepartidor!.telefono),
                            InfoItem(icon: Icons.email, label: 'Email', value: _datosRepartidor!.email),
                          ],
                        ),
                        
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
    );
  }


}