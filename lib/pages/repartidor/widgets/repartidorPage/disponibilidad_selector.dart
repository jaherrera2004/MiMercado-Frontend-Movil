import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DisponibilidadSelector extends StatefulWidget {
  final String estadoActual;
  final Function(String) onEstadoChanged;

  const DisponibilidadSelector({
    super.key,
    required this.estadoActual,
    required this.onEstadoChanged,
  });

  @override
  State<DisponibilidadSelector> createState() => _DisponibilidadSelectorState();
}

class _DisponibilidadSelectorState extends State<DisponibilidadSelector> {
  @override
  Widget build(BuildContext context) {
    final bool estaConectado = widget.estadoActual != 'Desconectado';
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Estado de conexión',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 20),
          
          // Toggle de conexión principal
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      estaConectado ? 'Conectado' : 'Desconectado',
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: estaConectado ? const Color(0xFF58E181) : Colors.red,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      estaConectado 
                          ? 'Puedes recibir pedidos' 
                          : 'No recibirás pedidos',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Switch toggle
              Transform.scale(
                scale: 1.2,
                child: Switch(
                  value: estaConectado,
                  onChanged: (bool value) {
                    _cambiarEstadoConexion(value);
                  },
                  activeColor: const Color(0xFF58E181),
                  activeTrackColor: const Color(0xFF58E181).withOpacity(0.3),
                  inactiveThumbColor: Colors.red,
                  inactiveTrackColor: Colors.red.withOpacity(0.3),
                ),
              ),
            ],
          ),
          
          // Indicador de estado cuando está conectado
          if (estaConectado) ...[
            const SizedBox(height: 24),
            Divider(color: Colors.grey[200]),
            const SizedBox(height: 16),
            
            Text(
              'Estado actual',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 16),
            
            // Indicador de estado actual (solo lectura)
            _buildEstadoIndicator(),
          ],
          
          const SizedBox(height: 16),
          
          // Botón de acción rápida
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _cambiarEstadoConexion(!estaConectado),
              icon: Icon(
                estaConectado ? Icons.power_settings_new : Icons.power,
                color: Colors.white,
              ),
              label: Text(
                estaConectado ? 'Desconectarse' : 'Conectarse',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: estaConectado ? Colors.red : const Color(0xFF58E181),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEstadoIndicator() {
    final bool estaOcupado = widget.estadoActual == 'Ocupado';
    final String estado = estaOcupado ? 'Ocupado' : 'Disponible';
    final String descripcion = estaOcupado ? 'Entregando un pedido' : 'Listo para recibir pedidos';
    final IconData icon = estaOcupado ? Icons.delivery_dining : Icons.check_circle;
    final Color color = estaOcupado ? Colors.orange : const Color(0xFF58E181);
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color,
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(
              icon,
              color: color,
              size: 32,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            estado,
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            descripcion,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          if (estaOcupado) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'No se pueden recibir nuevos pedidos',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.orange[700],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _cambiarEstadoConexion(bool conectar) {
    // Si está Ocupado, no permitir desconectarse
    if (!conectar && widget.estadoActual == 'Ocupado') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'No puedes desconectarte mientras estás Ocupado. Finaliza o libera el pedido actual.',
            style: GoogleFonts.inter(color: Colors.white),
          ),
          backgroundColor: Colors.orange[700],
          duration: const Duration(seconds: 3),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(
              conectar ? Icons.power : Icons.power_settings_new,
              color: conectar ? const Color(0xFF58E181) : Colors.red,
              size: 28,
            ),
            const SizedBox(width: 12),
            Text(
              conectar ? 'Conectarse' : 'Desconectarse',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        content: Text(
          conectar 
              ? '¿Estás listo para recibir pedidos?' 
              : '¿Estás seguro de que quieres desconectarte? No recibirás más pedidos.',
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
              final nuevoEstado = conectar ? 'Disponible' : 'Desconectado';
              widget.onEstadoChanged(nuevoEstado);
              
              // Mostrar mensaje de confirmación
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      Icon(
                        conectar ? Icons.check_circle : Icons.power_settings_new,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        conectar ? 'Conectado - Listo para recibir pedidos' : 'Te has desconectado',
                        style: GoogleFonts.inter(color: Colors.white),
                      ),
                    ],
                  ),
                  backgroundColor: conectar ? const Color(0xFF58E181) : Colors.red,
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: conectar ? const Color(0xFF58E181) : Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              conectar ? 'Conectarse' : 'Desconectarse',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}