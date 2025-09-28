import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../homepage/widgets/HomeBottomNavigation.dart';
import 'widgets/widgets.dart';
import 'widgets/AgregarDireccionModal.dart';
import 'widgets/EditarDireccionModal.dart';
import 'widgets/EliminarDireccionModal.dart';
import 'models/direccion.dart';

class DireccionesScreen extends StatefulWidget {
  const DireccionesScreen({super.key});

  @override
  State<DireccionesScreen> createState() => _DireccionesScreenState();
}

class _DireccionesScreenState extends State<DireccionesScreen> {
  final FirebaseFirestore firebase = FirebaseFirestore.instance;
  List<Direccion> direcciones = [];
  bool isLoading = true;
  String currentUserId = ''; // En una app real, esto vendría del sistema de autenticación

  @override
  void initState() {
    super.initState();
    // Por ahora, usar un email de ejemplo para buscar el usuario
    // En una app real, esto vendría del usuario autenticado
    _cargarDirecciones('dayro@gmail.com');
  }

  Future<void> _cargarDirecciones(String userEmail) async {
    try {
      setState(() {
        isLoading = true;
      });

      print('🔍 Buscando usuario con email: $userEmail');

      // Buscar el usuario por email
      final QuerySnapshot userQuery = await firebase
          .collection('usuarios')
          .where('email', isEqualTo: userEmail)
          .limit(1)
          .get();

      if (userQuery.docs.isEmpty) {
        print('❌ Usuario no encontrado');
        setState(() {
          isLoading = false;
        });
        return;
      }

      final userData = userQuery.docs.first.data() as Map<String, dynamic>;
      currentUserId = userQuery.docs.first.id;
      
      print('✅ Usuario encontrado: ${userData['nombre']}');

      // Obtener las direcciones del array
      final List<dynamic> direccionesData = userData['direcciones'] ?? [];
      print('📍 Direcciones encontradas: ${direccionesData.length}');

      final List<Direccion> direccionesFirebase = [];

      for (int i = 0; i < direccionesData.length; i++) {
        final direccionData = direccionesData[i] as Map<String, dynamic>;
        
        final direccion = Direccion(
          id: i.toString(), // Usar índice como ID temporal
          nombre: direccionData['nombre'] ?? 'Sin nombre',
          direccion: direccionData['direccion'] ?? 'Sin dirección',
          referencia: direccionData['referencias'] ?? '',
          esPrincipal: direccionData['principal'] ?? false,
        );

        direccionesFirebase.add(direccion);
        print('✅ Dirección cargada: ${direccion.nombre} - ${direccion.direccion}');
      }

      setState(() {
        direcciones = direccionesFirebase;
        isLoading = false;
      });

    } catch (e) {
      print('❌ Error cargando direcciones: $e');
      setState(() {
        isLoading = false;
        // Direcciones de ejemplo en caso de error
        direcciones = [
          Direccion(
            id: '1',
            nombre: 'Casa',
            direccion: 'Dirección de ejemplo',
            referencia: 'Sin referencia',
            esPrincipal: true,
          ),
        ];
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al cargar direcciones: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _mostrarModalAgregar() {
    showDialog(
      context: context,
      builder: (context) => AgregarDireccionModal(
        onDireccionAgregada: _agregarDireccion,
      ),
    );
  }

  void _mostrarModalEditar(Direccion direccion) {
    showDialog(
      context: context,
      builder: (context) => EditarDireccionModal(
        direccion: direccion,
        onDireccionEditada: _editarDireccion,
      ),
    );
  }

  void _mostrarModalEliminar(Direccion direccion) {
    showDialog(
      context: context,
      builder: (context) => EliminarDireccionModal(
        direccion: direccion,
        onDireccionEliminada: _eliminarDireccion,
      ),
    );
  }

  Future<void> _agregarDireccion(Direccion nuevaDireccion) async {
    try {
      print('💾 Guardando nueva dirección en Firebase...');
      
      if (currentUserId.isEmpty) {
        throw Exception('Usuario no identificado');
      }

      // Obtener el documento del usuario
      final userDoc = firebase.collection('usuarios').doc(currentUserId);
      final userData = await userDoc.get();
      
      if (!userData.exists) {
        throw Exception('Usuario no encontrado');
      }

      // Obtener direcciones actuales
      final Map<String, dynamic> currentData = userData.data() as Map<String, dynamic>;
      List<dynamic> direccionesActuales = List.from(currentData['direcciones'] ?? []);

      // Si la nueva dirección es principal, marcar las demás como no principales
      if (nuevaDireccion.esPrincipal) {
        for (int i = 0; i < direccionesActuales.length; i++) {
          direccionesActuales[i]['principal'] = false;
        }
      }

      // Agregar la nueva dirección
      final nuevaDireccionMap = {
        'nombre': nuevaDireccion.nombre,
        'direccion': nuevaDireccion.direccion,
        'referencias': nuevaDireccion.referencia ?? '',
        'principal': nuevaDireccion.esPrincipal,
      };

      direccionesActuales.add(nuevaDireccionMap);

      // Actualizar en Firebase
      await userDoc.update({
        'direcciones': direccionesActuales,
      });

      print('✅ Dirección guardada exitosamente');

      // Actualizar la UI
      setState(() {
        // Si es principal, quitar principal a las demás
        if (nuevaDireccion.esPrincipal) {
          direcciones = direcciones.map((d) => d.copyWith(esPrincipal: false)).toList();
        }
        direcciones.add(nuevaDireccion);
      });

      // Mostrar mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Dirección "${nuevaDireccion.nombre}" agregada exitosamente'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );

    } catch (e) {
      print('❌ Error al guardar dirección: $e');
      
      // Mostrar mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al guardar la dirección: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> _editarDireccion(Direccion direccionEditada) async {
    try {
      print('✏️ Actualizando dirección en Firebase...');
      
      if (currentUserId.isEmpty) {
        throw Exception('Usuario no identificado');
      }

      // Obtener el documento del usuario
      final userDoc = firebase.collection('usuarios').doc(currentUserId);
      final userData = await userDoc.get();
      
      if (!userData.exists) {
        throw Exception('Usuario no encontrado');
      }

      // Obtener direcciones actuales
      final Map<String, dynamic> currentData = userData.data() as Map<String, dynamic>;
      List<dynamic> direccionesActuales = List.from(currentData['direcciones'] ?? []);

      // Encontrar el índice de la dirección a editar
      int indexToEdit = -1;
      final direccionIndex = int.tryParse(direccionEditada.id ?? '-1') ?? -1;
      
      if (direccionIndex >= 0 && direccionIndex < direccionesActuales.length) {
        indexToEdit = direccionIndex;
      } else {
        // Buscar por coincidencia si no se encontró por índice
        final direccionOriginal = direcciones.firstWhere((d) => d.id == direccionEditada.id);
        for (int i = 0; i < direccionesActuales.length; i++) {
          final dir = direccionesActuales[i];
          if (dir['nombre'] == direccionOriginal.nombre && dir['direccion'] == direccionOriginal.direccion) {
            indexToEdit = i;
            break;
          }
        }
      }

      if (indexToEdit == -1) {
        throw Exception('Dirección no encontrada');
      }

      // Si la dirección editada es principal, marcar las demás como no principales
      if (direccionEditada.esPrincipal) {
        for (int i = 0; i < direccionesActuales.length; i++) {
          direccionesActuales[i]['principal'] = false;
        }
      }

      // Actualizar la dirección específica
      direccionesActuales[indexToEdit] = {
        'nombre': direccionEditada.nombre,
        'direccion': direccionEditada.direccion,
        'referencias': direccionEditada.referencia ?? '',
        'principal': direccionEditada.esPrincipal,
      };

      // Actualizar en Firebase
      await userDoc.update({
        'direcciones': direccionesActuales,
      });

      print('✅ Dirección actualizada exitosamente');

      // Actualizar la UI
      setState(() {
        final index = direcciones.indexWhere((d) => d.id == direccionEditada.id);
        if (index != -1) {
          // Si es principal, quitar principal a las demás
          if (direccionEditada.esPrincipal) {
            direcciones = direcciones.map((d) => d.copyWith(esPrincipal: false)).toList();
          }
          direcciones[index] = direccionEditada;
        }
      });

      // Mostrar mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Dirección "${direccionEditada.nombre}" actualizada exitosamente'),
          backgroundColor: Colors.blue,
          duration: const Duration(seconds: 2),
        ),
      );

    } catch (e) {
      print('❌ Error al actualizar dirección: $e');
      
      // Mostrar mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al actualizar la dirección: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> _eliminarDireccion(Direccion direccion) async {
    try {
      print('🗑️ Eliminando dirección de Firebase...');
      
      if (currentUserId.isEmpty) {
        throw Exception('Usuario no identificado');
      }

      // Obtener el documento del usuario
      final userDoc = firebase.collection('usuarios').doc(currentUserId);
      final userData = await userDoc.get();
      
      if (!userData.exists) {
        throw Exception('Usuario no encontrado');
      }

      // Obtener direcciones actuales
      final Map<String, dynamic> currentData = userData.data() as Map<String, dynamic>;
      List<dynamic> direccionesActuales = List.from(currentData['direcciones'] ?? []);

      // Encontrar el índice de la dirección a eliminar
      int indexToRemove = -1;
      final direccionIndex = int.tryParse(direccion.id ?? '-1') ?? -1;
      
      if (direccionIndex >= 0 && direccionIndex < direccionesActuales.length) {
        // Verificar que es la dirección correcta comparando nombre y dirección
        final direccionFirebase = direccionesActuales[direccionIndex];
        if (direccionFirebase['nombre'] == direccion.nombre && 
            direccionFirebase['direccion'] == direccion.direccion) {
          indexToRemove = direccionIndex;
        }
      }

      if (indexToRemove == -1) {
        // Buscar por coincidencia de nombre y dirección si no se encontró por índice
        for (int i = 0; i < direccionesActuales.length; i++) {
          final dir = direccionesActuales[i];
          if (dir['nombre'] == direccion.nombre && dir['direccion'] == direccion.direccion) {
            indexToRemove = i;
            break;
          }
        }
      }

      if (indexToRemove == -1) {
        throw Exception('Dirección no encontrada');
      }

      // Eliminar la dirección del array
      direccionesActuales.removeAt(indexToRemove);

      // Actualizar en Firebase
      await userDoc.update({
        'direcciones': direccionesActuales,
      });

      print('✅ Dirección eliminada exitosamente');

      // Actualizar la UI
      setState(() {
        direcciones.removeWhere((d) => d.id == direccion.id);
      });

      // Mostrar mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Dirección "${direccion.nombre}" eliminada exitosamente'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );

    } catch (e) {
      print('❌ Error al eliminar dirección: $e');
      
      // Mostrar mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al eliminar la dirección: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _seleccionarDireccion(Direccion direccion) {
    // Lógica para seleccionar dirección (por ejemplo, para un pedido)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Dirección "${direccion.nombre}" seleccionada'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: DireccionesAppBar(
        onAddPressed: _mostrarModalAgregar,
      ),
      body: _buildBody(),
      bottomNavigationBar: const HomeBottomNavigation(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return _buildLoadingState();
    } else if (direcciones.isEmpty) {
      return _buildEmptyState();
    } else {
      return DireccionesList(
        direcciones: direcciones,
        onEditDireccion: _mostrarModalEditar,
        onDeleteDireccion: _mostrarModalEliminar,
        onTapDireccion: _seleccionarDireccion,
      );
    }
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text(
            'Cargando direcciones...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.location_off,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'No tienes direcciones guardadas',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Agrega tu primera dirección para comenzar',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _mostrarModalAgregar,
            icon: const Icon(Icons.add),
            label: const Text('Agregar Dirección'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}