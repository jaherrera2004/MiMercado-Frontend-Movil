import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mi_mercado/MiMercadoApp.dart';
import 'package:mi_mercado/firebase_options.dart';
import 'package:mi_mercado/models/CarritoService.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Inicializar GetStorage para el carrito
  await CarritoService.init();
  
  runApp(const MiMercadoApp());
}

  

