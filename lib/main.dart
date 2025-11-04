import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mi_mercado/MiMercadoApp.dart';
import 'package:mi_mercado/features/repartidor/pedidos/presentation/controllers/historial_pedidos_controller.dart';
import 'package:mi_mercado/features/repartidor/pedidos/presentation/controllers/pedido_actual_controller.dart';
import 'package:mi_mercado/features/repartidor/pedidos/presentation/controllers/pedidos_disponibles_controller.dart';
import 'package:mi_mercado/firebase_options.dart';
import 'package:mi_mercado/core/di/injection.dart';
import 'package:get/get.dart';
import 'package:mi_mercado/features/usuario/productos/presentation/controllers/carrito_controller.dart';
import 'package:mi_mercado/features/usuario/direcciones/presentation/controllers/direccion_controller.dart';
import 'package:mi_mercado/features/pedidos/presentation/controllers/pedidos_controller.dart';
import 'package:mi_mercado/features/pedidos/presentation/controllers/pedido_detalle_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  
  // Inicializar el service locator (GetIt)
  setupLocator();

  // Registrar la instancia de CarritoController en Get para que Get.find() funcione
  // Esto crea la instancia usando GetIt (factory) y la pone en Getx dependency system.
  Get.put(getIt<CarritoController>());
  Get.put(getIt<DireccionController>());
  Get.put(getIt<PedidosController>());
  Get.put(getIt<PedidoDetalleController>());
  Get.put(getIt<PedidosDisponiblesController>());
  Get.lazyPut(() => getIt<PedidoActualController>());
  Get.lazyPut(() => getIt<HistorialPedidosController>());

  // PagoController se inicializa cuando se abre la pantalla de pago
  
  runApp(const MiMercadoApp());
}



