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
      child: ListView(
        children: [
          const SizedBox(height: 50), // Espacio debajo del AppBar
          
          if (isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: CircularProgressIndicator(),
              ),
            )
          else if (error != null)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error al cargar los datos',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Por favor, inténtalo de nuevo',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
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
              final index = datosUsuario.keys.toList().indexOf(entry.key);
              final campo = entry.key;
              final valor = entry.value;
              
              return Column(
                children: [
                  CamposDatos(
                    label: campo,
                    value: valor,
                  ),
                  if (index < datosUsuario.length - 1) const Divider(),
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
    return const DatosLista();
  }
}