import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../shared/widgets/forms/CustomTextField.dart';
import '../../../shared/widgets/buttons/PrimaryButton.dart';
import '../models/direccion.dart';

/// Modal para agregar una nueva dirección
class AgregarDireccionModal extends StatefulWidget {
  final Future<void> Function(Direccion) onDireccionAgregada;

  const AgregarDireccionModal({
    super.key,
    required this.onDireccionAgregada,
  });

  @override
  State<AgregarDireccionModal> createState() => _AgregarDireccionModalState();
}

class _AgregarDireccionModalState extends State<AgregarDireccionModal> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _direccionController = TextEditingController();
  final _referenciaController = TextEditingController();
  
  bool _esPrincipal = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _nombreController.dispose();
    _direccionController.dispose();
    _referenciaController.dispose();
    super.dispose();
  }

  void _guardarDireccion() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final nuevaDireccion = Direccion(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          nombre: _nombreController.text.trim(),
          direccion: _direccionController.text.trim(),
          referencia: _referenciaController.text.trim().isEmpty 
              ? null 
              : _referenciaController.text.trim(),
          esPrincipal: _esPrincipal,
        );

        // Llamar al callback que manejará el guardado en Firebase
        await widget.onDireccionAgregada(nuevaDireccion);
        
        setState(() {
          _isLoading = false;
        });

        Navigator.of(context).pop();
        
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        
        // El error ya se maneja en el método padre, no necesitamos hacer nada aquí
        print('Error en modal: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 600),
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Título del modal
              Row(
                children: [
                  Icon(
                    Icons.add_location_alt,
                    color: primaryColor,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Agregar Dirección',
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close, color: Colors.grey),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Formulario scrollable
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Campo nombre
                      CustomTextField(
                        label: "Nombre de la dirección",
                        hint: "Ej: Casa, Oficina, Apartamento",
                        primaryColor: primaryColor,
                        controller: _nombreController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'El nombre es requerido';
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Campo dirección
                      CustomTextField(
                        label: "Dirección completa",
                        hint: "Ej: Carrera 15 #123-45",
                        primaryColor: primaryColor,
                        controller: _direccionController,
                        maxLines: 2,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'La dirección es requerida';
                          }
                          return null;
                        },
                      ),
                      

                      
                      const SizedBox(height: 16),
                      
                      // Campo referencia (opcional)
                      CustomTextField(
                        label: "Referencia (opcional)",
                        hint: "Ej: Frente al parque, edificio verde",
                        primaryColor: primaryColor,
                        controller: _referenciaController,
                        maxLines: 2,
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Checkbox dirección principal
                      Row(
                        children: [
                          Checkbox(
                            value: _esPrincipal,
                            onChanged: (value) {
                              setState(() {
                                _esPrincipal = value ?? false;
                              });
                            },
                            activeColor: primaryColor,
                          ),
                          Expanded(
                            child: Text(
                              'Establecer como dirección principal',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Botones de acción
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        side: BorderSide(color: Colors.grey.shade400),
                      ),
                      child: Text(
                        'Cancelar',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: PrimaryButton(
                      text: "Guardar",
                      onPressed: _guardarDireccion,
                      backgroundColor: primaryColor,
                      isLoading: _isLoading,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}