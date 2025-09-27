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
          
          // Selector de estado cuando está conectado
          if (estaConectado) ...[
            const SizedBox(height: 24),
            Divider(color: Colors.grey[200]),
            const SizedBox(height: 16),
            
            Text(
              'Estado de disponibilidad',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 16),
            
            // Opciones de disponibilidad
            Row(
              children: [
                Expanded(
                  child: _buildEstadoOption(
                    'Disponible',
                    'Listo para pedidos',
                    Icons.check_circle,
                    const Color(0xFF58E181),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildEstadoOption(
                    'Ocupado',
                    'No disponible',
                    Icons.delivery_dining,
                    Colors.orange,
                  ),
                ),
              ],
            ),
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

  Widget _buildEstadoOption(
    String estado,
    String descripcion,
    IconData icon,
    Color color,
  ) {
    final bool isSelected = widget.estadoActual == estado;
    
    return GestureDetector(
      onTap: () {
        if (!isSelected) {
          widget.onEstadoChanged(estado);
          
          // Mostrar confirmación
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(
                    icon,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Estado cambiado a $estado',
                    style: GoogleFonts.inter(color: Colors.white),
                  ),
                ],
              ),
              backgroundColor: color,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.grey[200]!,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected ? color.withOpacity(0.2) : Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: isSelected ? color : Colors.grey[600],
                size: 24,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              estado,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? color : Colors.grey[800],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              descripcion,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _cambiarEstadoConexion(bool conectar) {
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
                        conectar ? 'Conectado - Estado: Disponible' : 'Te has desconectado',
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