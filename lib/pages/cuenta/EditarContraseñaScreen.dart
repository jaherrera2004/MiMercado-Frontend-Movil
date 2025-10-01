import 'package:flutter/material.dart';
import 'widgets/widgets.dart';
import '../../models/Usuario.dart';

/// Pantalla para cambiar la contraseña del usuario
class EditarSeguridadScreen extends StatefulWidget {
  const EditarSeguridadScreen({super.key});

  @override
  State<EditarSeguridadScreen> createState() => _EditarSeguridadScreenState();
}

class _EditarSeguridadScreenState extends State<EditarSeguridadScreen> {
  final TextEditingController _contrasenaActualController = TextEditingController();
  final TextEditingController _nuevaContrasenaController = TextEditingController();
  final TextEditingController _confirmarContrasenaController = TextEditingController();
  
  bool _isLoading = false;

  @override
  void dispose() {
    _contrasenaActualController.dispose();
    _nuevaContrasenaController.dispose();
    _confirmarContrasenaController.dispose();
    super.dispose();
  }

  /// Valida que las contraseñas cumplan con los requisitos
  bool _validarContrasenas() {
    final contrasenaActual = _contrasenaActualController.text.trim();
    final nuevaContrasena = _nuevaContrasenaController.text.trim();
    final confirmarContrasena = _confirmarContrasenaController.text.trim();

    if (contrasenaActual.isEmpty) {
      _mostrarError('Ingresa tu contraseña actual');
      return false;
    }

    if (nuevaContrasena.isEmpty) {
      _mostrarError('Ingresa una nueva contraseña');
      return false;
    }

    if (nuevaContrasena.length < 6) {
      _mostrarError('La nueva contraseña debe tener al menos 6 caracteres');
      return false;
    }

    if (nuevaContrasena != confirmarContrasena) {
      _mostrarError('Las contraseñas no coinciden');
      return false;
    }

    return true;
  }

  /// Muestra un mensaje de error
  void _mostrarError(String mensaje) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(mensaje),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  /// Cambia la contraseña del usuario
  Future<void> _cambiarContrasena() async {
    if (!_validarContrasenas()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Llamar al método editarContrasena del modelo Usuario
      await Usuario.editarContrasena(
        contrasenaActual: _contrasenaActualController.text.trim(),
        contrasenaNueva: _nuevaContrasenaController.text.trim(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Contraseña cambiada exitosamente'),
            backgroundColor: Color(0xFF58E181),
          ),
        );
        
        // Limpiar los campos
        _contrasenaActualController.clear();
        _nuevaContrasenaController.clear();
        _confirmarContrasenaController.clear();
        
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
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
      appBar: const EditarContrasenaAppBar(),
      
      // Contenido principal
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: ListView(
          children: [
            // Formulario de cambio de contraseña
            EditarContrasenaForm(
              contrasenaActualController: _contrasenaActualController,
              nuevaContrasenaController: _nuevaContrasenaController,
              confirmarContrasenaController: _confirmarContrasenaController,
            ),
            
            // Botones de acción
            EditarContrasenaBotones(
              onCambiar: _cambiarContrasena,
              isLoading: _isLoading,
            ),
          ],
        ),
      ),
    );
  }
}
