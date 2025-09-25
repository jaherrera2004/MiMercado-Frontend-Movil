import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../shared/widgets/forms/CustomTextField.dart';
import '../../../shared/widgets/buttons/PrimaryButton.dart';
import '../models/direccion.dart';

/// Modal para agregar una nueva dirección
class AgregarDireccionModal extends StatefulWidget {
  final Function(Direccion) onDireccionAgregada;

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
  final _ciudadController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _referenciaController = TextEditingController();
  
  bool _esPrincipal = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _nombreController.dispose();
    _direccionController.dispose();
    _ciudadController.dispose();
    _telefonoController.dispose();
    _referenciaController.dispose();
    super.dispose();
  }

  void _guardarDireccion() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simular guardado (en una app real, aquí iría la llamada a la API)
      await Future.delayed(const Duration(seconds: 1));

      final nuevaDireccion = Direccion(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        nombre: _nombreController.text.trim(),
        direccion: _direccionController.text.trim(),
        ciudad: _ciudadController.text.trim(),
        telefono: _telefonoController.text.trim(),
        referencia: _referenciaController.text.trim().isEmpty 
            ? null 
            : _referenciaController.text.trim(),
        esPrincipal: _esPrincipal,
      );

      setState(() {
        _isLoading = false;
      });

      widget.onDireccionAgregada(nuevaDireccion);
      Navigator.of(context).pop();
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
                      
                      // Campo ciudad
                      CustomTextField(
                        label: "Ciudad",
                        hint: "Ej: Bogotá, Medellín, Cali",
                        primaryColor: primaryColor,
                        controller: _ciudadController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'La ciudad es requerida';
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Campo teléfono
                      CustomTextField(
                        label: "Teléfono de contacto",
                        hint: "Ej: +57 300 123 4567",
                        primaryColor: primaryColor,
                        controller: _telefonoController,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'El teléfono es requerido';
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