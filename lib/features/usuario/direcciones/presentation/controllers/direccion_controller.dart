import 'package:get/get.dart';
import 'package:mi_mercado/core/utils/shared_preferences_utils.dart';
import '../../domain/entities/Direccion.dart';
import '../../domain/useCases/agregar_direccion.dart';
import '../../domain/useCases/obtener_direcciones.dart';
import '../../domain/useCases/editar_direccion.dart';
import '../../domain/useCases/eliminar_direccion.dart';


class DireccionController extends GetxController {
  final AgregarDireccionUseCase agregarDireccionUseCase;
  final ObtenerDireccionesUseCase obtenerDireccionesUseCase;
  final EditarDireccionUseCase editarDireccionUseCase;
  final EliminarDireccionUseCase eliminarDireccionUseCase;

  var direcciones = <Direccion>[].obs;
  var isLoading = false.obs;

  // Flag para evitar cargar direcciones múltiples veces
  bool _direccionesCargadas = false;

  // Método para resetear el flag de direcciones cargadas
  void _resetDireccionesCargadas() {
    _direccionesCargadas = false;
  }

  DireccionController({
    required this.agregarDireccionUseCase,
    required this.obtenerDireccionesUseCase,
    required this.editarDireccionUseCase,
    required this.eliminarDireccionUseCase,
  }) {
    print('DireccionController: Constructor llamado');
  }

  @override
  void onInit() {
    super.onInit();
    print('DireccionController: onInit llamado - controller inicializado pero sin cargar direcciones aún');
    // No cargar direcciones automáticamente aquí
  }

  Future<void> cargarDireccionesUsuario() async {
    // Evitar cargar direcciones múltiples veces
    if (_direccionesCargadas) {
      print('DireccionController: Direcciones ya cargadas, omitiendo carga');
      return;
    }

    print('DireccionController: cargarDireccionesUsuario llamado');
    try {
      final userId = await SharedPreferencesUtils.getUserId();
      print('DireccionController: userId obtenido: $userId');

      if (userId != null) {
        print('DireccionController: Cargando direcciones para userId: $userId');
        await cargarDirecciones(userId);
        _direccionesCargadas = true; // Marcar como cargadas
      } else {
        print('DireccionController: userId es null, no se pueden cargar direcciones');
        isLoading.value = false;
      }
    } catch (e) {
      print('DireccionController: Error en cargarDireccionesUsuario: $e');
      isLoading.value = false;
    }
  }

  Future<void> cargarDirecciones(String idUsuario) async {
    isLoading.value = true;
    final result = await obtenerDireccionesUseCase.call(idUsuario);
    result.fold(
      (failure) => print('direccion_controller.dart: error al cargar direcciones: $failure'),
      (data) {
        direcciones.value = data;
        print('direccion_controller.dart: direcciones cargadas (${data.length})');
      },
    );
    isLoading.value = false;
  }

  Future<void> agregarDireccion(Direccion direccion) async {
    print('DireccionController: agregarDireccion llamado con dirección: ${direccion.nombre}');
    final idUsuario = await SharedPreferencesUtils.getUserId();
    print('DireccionController: idUsuario obtenido para agregar: $idUsuario');

    if (idUsuario != null) {
      print('DireccionController: Llamando al use case agregarDireccionUseCase');
      final result = await agregarDireccionUseCase.call(direccion);
      result.fold(
        (failure) {
          print('DireccionController: Error al agregar dirección: $failure');
        },
        (_) {
          print('DireccionController: Dirección agregada exitosamente: ${direccion.nombre}');
          _resetDireccionesCargadas(); // Resetear flag para recargar en la próxima apertura
          cargarDirecciones(idUsuario);
        },
      );
    } else {
      print('DireccionController: ERROR - idUsuario es null, no se puede agregar dirección');
    }
  }

  Future<void> editarDireccion(Direccion direccion) async {
    final idUsuario = await SharedPreferencesUtils.getUserId();
    if (idUsuario != null) {
      final result = await editarDireccionUseCase.call(direccion);
      result.fold(
        (failure) => print('direccion_controller.dart: error al editar dirección: $failure'),
        (_) {
          print('direccion_controller.dart: dirección editada (${direccion.nombre})');
          _resetDireccionesCargadas(); // Resetear flag para recargar en la próxima apertura
          cargarDirecciones(idUsuario);
        },
      );
    }
  }

  Future<void> eliminarDireccion(String id) async {
    final idUsuario = await SharedPreferencesUtils.getUserId();
    if (idUsuario != null) {
      final result = await eliminarDireccionUseCase.call(EliminarDireccionParams(id: id, idUsuario: idUsuario));
      result.fold(
        (failure) => print('direccion_controller.dart: error al eliminar dirección: $failure'),
        (_) {
          print('direccion_controller.dart: dirección eliminada ($id)');
          _resetDireccionesCargadas(); // Resetear flag para recargar en la próxima apertura
          cargarDirecciones(idUsuario);
        },
      );
    }
  }
}