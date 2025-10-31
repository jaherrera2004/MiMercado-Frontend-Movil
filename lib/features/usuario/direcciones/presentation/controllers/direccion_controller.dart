import 'package:get/get.dart';
import '../../domain/entities/Direccion.dart';
import '../../domain/useCases/agregar_direccion.dart';
import '../../domain/useCases/obtener_direcciones.dart';
import '../../domain/useCases/editar_direccion.dart';
import '../../domain/useCases/eliminar_direccion.dart';
import 'package:mi_mercado/models/SharedPreferences.dart';

class DireccionController extends GetxController {
  final AgregarDireccionUseCase agregarDireccionUseCase;
  final ObtenerDireccionesUseCase obtenerDireccionesUseCase;
  final EditarDireccionUseCase editarDireccionUseCase;
  final EliminarDireccionUseCase eliminarDireccionUseCase;

  var direcciones = <Direccion>[].obs;
  var isLoading = false.obs;

  DireccionController({
    required this.agregarDireccionUseCase,
    required this.obtenerDireccionesUseCase,
    required this.editarDireccionUseCase,
    required this.eliminarDireccionUseCase,
  });

  @override
  void onInit() {
    super.onInit();
    _cargarDireccionesIniciales();
  }

  Future<void> _cargarDireccionesIniciales() async {
    final idUsuario = await SharedPreferencesService.getCurrentUserId();
    if (idUsuario != null) {
      await cargarDirecciones(idUsuario);
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
    final idUsuario = await SharedPreferencesService.getCurrentUserId();
    if (idUsuario != null) {
      final result = await agregarDireccionUseCase.call(direccion);
      result.fold(
        (failure) => print('direccion_controller.dart: error al agregar dirección: $failure'),
        (_) {
          print('direccion_controller.dart: dirección agregada (${direccion.nombre})');
          cargarDirecciones(idUsuario);
        },
      );
    }
  }

  Future<void> editarDireccion(Direccion direccion) async {
    final idUsuario = await SharedPreferencesService.getCurrentUserId();
    if (idUsuario != null) {
      final result = await editarDireccionUseCase.call(direccion);
      result.fold(
        (failure) => print('direccion_controller.dart: error al editar dirección: $failure'),
        (_) {
          print('direccion_controller.dart: dirección editada (${direccion.nombre})');
          cargarDirecciones(idUsuario);
        },
      );
    }
  }

  Future<void> eliminarDireccion(String id) async {
    final idUsuario = await SharedPreferencesService.getCurrentUserId();
    if (idUsuario != null) {
      final result = await eliminarDireccionUseCase.call(EliminarDireccionParams(id: id, idUsuario: idUsuario));
      result.fold(
        (failure) => print('direccion_controller.dart: error al eliminar dirección: $failure'),
        (_) {
          print('direccion_controller.dart: dirección eliminada ($id)');
          cargarDirecciones(idUsuario);
        },
      );
    }
  }
}