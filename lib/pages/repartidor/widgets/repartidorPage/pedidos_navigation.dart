import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'navigation_card.dart';
import '../../PedidosDisponiblesScreen.dart';
import '../../HistorialPedidosScreen.dart';
import '../../DatosRepartidorScreen.dart';
import '../../../../models/Repartidor.dart';

class PedidosNavigation extends StatelessWidget {
  const PedidosNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gestión de Pedidos',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: NavigationCard(
                title: 'Pedidos\nDisponibles',
                subtitle: 'Ver pedidos para tomar',
                icon: Icons.shopping_cart,
                color: const Color(0xFF58E181),
                onTap: () async {
                  // Verificar estado del repartidor antes de navegar
                  final estado = await Repartidor.obtenerEstadoActual();
                  if (estado == null || estado == EstadoRepartidor.desconectado || estado == EstadoRepartidor.ocupado) {
                    final String msg = (estado == EstadoRepartidor.ocupado)
                        ? 'Estás ocupado. No puedes ver pedidos en este momento.'
                        : 'Debes estar Disponible para ver pedidos';
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          msg,
                          style: GoogleFonts.inter(color: Colors.white),
                        ),
                        backgroundColor: Colors.orange[700],
                        duration: const Duration(seconds: 2),
                      ),
                    );
                    return;
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PedidosDisponiblesScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: NavigationCard(
                title: 'Mi\nHistorial',
                subtitle: 'Ver pedidos completados',
                icon: Icons.history,
                color: Colors.blue[600]!,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HistorialPedidosScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Sección para datos personales
        Text(
          'Mi Perfil',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 16),
        NavigationCard(
          title: 'Datos Personales',
          subtitle: 'Ver y editar mi información',
          icon: Icons.person,
          color: Colors.orange[600]!,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const DatosPersonalesRepartidorScreen(),
              ),
            );
          },
        ),
      ],
    );
  }
}