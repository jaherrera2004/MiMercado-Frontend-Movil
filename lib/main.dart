import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mi_mercado/MiMercadoApp.dart';
import 'package:mi_mercado/firebase_options.dart';
import 'package:mi_mercado/core/di/injection.dart';
import 'package:mi_mercado/models/CarritoService.dart';
import 'package:get/get.dart';
import 'package:mi_mercado/features/usuario/productos/presentation/controllers/carrito_controller.dart';
import 'package:mi_mercado/features/usuario/direcciones/presentation/controllers/direccion_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Inicializar GetStorage para el carrito
  await CarritoService.init();
  
  // Inicializar el service locator (GetIt)
  setupLocator();

  // Registrar la instancia de CarritoController en Get para que Get.find() funcione
  // Esto crea la instancia usando GetIt (factory) y la pone en Getx dependency system.
  Get.put(getIt<CarritoController>());
  Get.put(getIt<DireccionController>());
  
  runApp(const MiMercadoApp());
}

  

