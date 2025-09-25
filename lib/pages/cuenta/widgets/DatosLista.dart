import 'package:flutter/material.dart';
import 'camposDatos.dart';

/// Widget que contiene la lista de datos del perfil
class DatosLista extends StatelessWidget {
  final List<String> campos;
  final EdgeInsets? padding;

  const DatosLista({
    super.key,
    this.campos = const ["Nombre", "Apellido", "Telefono", "Email"],
    this.padding = const EdgeInsets.symmetric(horizontal: 30.0),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding!,
      child: ListView(
        children: [
          const SizedBox(height: 50), // Espacio debajo del AppBar
          
          // Generar campos dinámicamente
          ...campos.asMap().entries.map((entry) {
            final index = entry.key;
            final campo = entry.value;
            
            return Column(
              children: [
                CamposDatos(dato: campo),
                if (index < campos.length - 1) const Divider(),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }
}

/// Widget simplificado para casos específicos con campos predefinidos
class DatosPerfilLista extends StatelessWidget {
  const DatosPerfilLista({super.key});

  @override
  Widget build(BuildContext context) {
    return const DatosLista(
      campos: ["Nombre", "Apellido", "Telefono", "Email"],
    );
  }
}