import 'package:flutter/material.dart';
import 'widgets/widgets.dart';

/// Pantalla para editar información del perfil de usuario
class EditarPerfilScreen extends StatefulWidget {
  const EditarPerfilScreen({super.key});

  @override
  State<EditarPerfilScreen> createState() => _EditarPerfilScreenState();
}

class _EditarPerfilScreenState extends State<EditarPerfilScreen> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidoController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Aquí se pueden cargar los datos actuales del usuario
    _cargarDatosActuales();
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidoController.dispose();
    _telefonoController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  /// Carga los datos actuales del usuario (simulado)
  void _cargarDatosActuales() {
    // TODO: Cargar datos reales del usuario desde backend/storage
    _nombreController.text = ""; // Datos actuales
    _apellidoController.text = "";
    _telefonoController.text = "";
    _emailController.text = "";
  }

  /// Guarda los cambios del perfil
  Future<void> _guardarCambios() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Implementar lógica de guardado real
      await Future.delayed(const Duration(seconds: 2)); // Simulación

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Perfil actualizado exitosamente'),
            backgroundColor: Color(0xFF58E181),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error al actualizar el perfil'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      
      // AppBar modular
      appBar: const EditarPerfilAppBar(),
      
      // Contenido principal
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: ListView(
          children: [
            // Formulario de edición
            EditarPerfilForm(
              nombreController: _nombreController,
              apellidoController: _apellidoController,
              telefonoController: _telefonoController,
              emailController: _emailController,
            ),
            
            // Botones de acción
            EditarPerfilBotones(
              onGuardar: _guardarCambios,
              isLoading: _isLoading,
            ),
          ],
        ),
      ),
    );
  }
}
