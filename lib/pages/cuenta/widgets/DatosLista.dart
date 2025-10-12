import 'package:flutter/material.dart';
import 'camposDatos.dart';
import '../../../models/Usuario.dart';

/// Widget que contiene la lista de datos del perfil
class DatosLista extends StatefulWidget {
  final EdgeInsets? padding;

  const DatosLista({
    super.key,
    this.padding = const EdgeInsets.symmetric(horizontal: 30.0),
  });

  @override
  State<DatosLista> createState() => DatosListaState();
}

class DatosListaState extends State<DatosLista> {
  Map<String, String> datosUsuario = {};
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _cargarDatosUsuario();
  }

  Future<void> _cargarDatosUsuario() async {
    try {
      final Map<String, dynamic>? datos = await Usuario.obtenerDatosUsuarioActual();
      
      if (datos != null) {
        if (mounted) {
          setState(() {
            datosUsuario = {
              'Nombre': datos['nombre'] ?? '',
              'Apellido': datos['apellido'] ?? '',
              'Teléfono': datos['telefono'] ?? '',
              'Email': datos['email'] ?? '',
            };
            isLoading = false;
          });
        }
      } else {
        throw Exception('No se pudieron cargar los datos del usuario');
      }
    } catch (e) {
      print('Error cargando datos del usuario: $e');
      if (mounted) {
        setState(() {
          error = e.toString();
          isLoading = false;
        });
      }
    }
  }

  /// Método público para refrescar los datos desde el padre
  void refrescarDatos() {
    setState(() {
      isLoading = true;
      error = null;
    });
    _cargarDatosUsuario();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isLoading)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: Column(
                  children: [
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          const Color(0xFF58E181),
                        ),
                        strokeWidth: 3,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Cargando información...',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else if (error != null)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: const Icon(
                        Icons.error_outline,
                        size: 40,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error al cargar los datos',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Por favor, inténtalo de nuevo',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF58E181),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          isLoading = true;
                          error = null;
                        });
                        _cargarDatosUsuario();
                      },
                      child: Text('Reintentar'),
                    ),
                  ],
                ),
              ),
            )
          else
            // Generar campos dinámicamente con datos reales
            ...datosUsuario.entries.map((entry) {
              final campo = entry.key;
              final valor = entry.value;
              
              return CamposDatos(
                label: campo,
                value: valor,
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
    return const DatosLista();
  }
}