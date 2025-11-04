import 'package:get/get.dart';
import 'package:mi_mercado/core/utils/shared_preferences_utils.dart';
import 'package:mi_mercado/features/repartidor/datos/domain/useCases/obtener_datos_repartidor.dart';
import 'package:mi_mercado/features/auth/domain/entities/Repartidor.dart';

class DatosRepartidorController extends GetxController {
  final ObtenerDatosRepartidorUseCase obtenerDatosRepartidorUseCase;

  // Estado observable
  final repartidor = Rx<Repartidor?>(null);
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  DatosRepartidorController({
    required this.obtenerDatosRepartidorUseCase,
  });

  @override
  void onInit() {
    super.onInit();
    cargarDatosRepartidor();
  }

  /// Carga los datos del repartidor actual
  Future<void> cargarDatosRepartidor() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Obtener ID del repartidor actual
      final repartidorId = await SharedPreferencesUtils.getUserId();

      if (repartidorId == null) {
        errorMessage.value = 'No se pudo obtener el ID del repartidor';
        print('DatosRepartidorController: Error - ID de repartidor no encontrado');
        return;
      }

      final result = await obtenerDatosRepartidorUseCase.call(repartidorId);

      result.fold(
        (failure) {
          errorMessage.value = failure.message;
          print('DatosRepartidorController: Error al cargar datos: ${failure.message}');
        },
        (repartidorData) {
          repartidor.value = repartidorData;
          print('DatosRepartidorController: Datos del repartidor cargados: ${repartidorData?.nombre ?? "null"}');
        },
      );
    } catch (e) {
      errorMessage.value = e.toString();
      print('DatosRepartidorController: Error inesperado: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Refresca los datos del repartidor
  Future<void> refrescarDatos() async {
    await cargarDatosRepartidor();
  }
}
