import 'package:flutter/material.dart';
import 'widgets/widgets.dart';

/// Pantalla de datos de perfil del usuario
class DatosScreen extends StatefulWidget {
  const DatosScreen({super.key});

  @override
  State<DatosScreen> createState() => _DatosScreenState();
}

class _DatosScreenState extends State<DatosScreen> {
  final GlobalKey<DatosListaState> _datosListaKey = GlobalKey<DatosListaState>();

  void _onUsuarioEditado() {
    // Refresca los datos en la lista
    _datosListaKey.currentState?.refrescarDatos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      
      // AppBar modular con botón de editar
      appBar: DatosAppBar(
        onUsuarioEditado: _onUsuarioEditado,
      ),
      
      // Lista de datos del perfil
      body: DatosLista(key: _datosListaKey),
    );
  }
}
