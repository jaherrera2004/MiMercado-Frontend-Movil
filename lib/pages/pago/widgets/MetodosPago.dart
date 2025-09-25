import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MetodosPago extends StatefulWidget {
  final String? metodoSeleccionado;
  final Function(String)? onMetodoChanged;

  const MetodosPago({
    super.key,
    this.metodoSeleccionado,
    this.onMetodoChanged,
  });

  @override
  State<MetodosPago> createState() => _MetodosPagoState();
}

class _MetodosPagoState extends State<MetodosPago> {
  String? _metodoSeleccionado;

  final List<Map<String, dynamic>> _metodosPago = [
    {
      'id': 'efectivo',
      'nombre': 'Efectivo',
      'icon': Icons.money,
      'descripcion': 'Pago contra entrega',
    },
    {
      'id': 'tarjeta',
      'nombre': 'Tarjeta',
      'icon': Icons.credit_card,
      'descripcion': 'Visa, Mastercard',
    },
    {
      'id': 'nequi',
      'nombre': 'Nequi',
      'icon': Icons.phone_android,
      'descripcion': 'Pago móvil',
    },
    {
      'id': 'daviplata',
      'nombre': 'Daviplata',
      'icon': Icons.account_balance_wallet,
      'descripcion': 'Billetera digital',
    },
  ];

  @override
  void initState() {
    super.initState();
    _metodoSeleccionado = widget.metodoSeleccionado ?? 'efectivo';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Método de pago",
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        
        Column(
          children: _metodosPago.map((metodo) {
            final bool isSelected = _metodoSeleccionado == metodo['id'];
            
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              child: InkWell(
                onTap: () {
                  setState(() {
                    _metodoSeleccionado = metodo['id'];
                  });
                  widget.onMetodoChanged?.call(metodo['id']);
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? const Color(0xFF58E181).withOpacity(0.1)
                        : Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected 
                          ? const Color(0xFF58E181)
                          : Colors.grey[300]!,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isSelected 
                              ? const Color(0xFF58E181)
                              : Colors.grey[400],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          metodo['icon'] as IconData,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 16),
                      
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              metodo['nombre'],
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              metodo['descripcion'],
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      Radio<String>(
                        value: metodo['id'],
                        groupValue: _metodoSeleccionado,
                        onChanged: (value) {
                          setState(() {
                            _metodoSeleccionado = value;
                          });
                          widget.onMetodoChanged?.call(value!);
                        },
                        activeColor: const Color(0xFF58E181),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}