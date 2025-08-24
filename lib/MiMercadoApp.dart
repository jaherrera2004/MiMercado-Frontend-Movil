import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mi_mercado/SplashScreen.dart';
import 'package:mi_mercado/features/auth/pages/Register.dart';
import 'package:mi_mercado/features/auth/pages/IniciarSesion.dart';
import 'package:mi_mercado/features/pedidos/listaPedidos.dart';
import 'package:mi_mercado/features/direcciones/listaDirecciones.dart';
import 'package:mi_mercado/features/cuenta/perfil.dart';
import 'package:mi_mercado/features/cuenta/datosPerfil.dart';
import 'package:mi_mercado/features/cuenta/seguridad.dart';
import 'package:mi_mercado/features/cuenta/editarPerfil.dart';
import 'package:mi_mercado/features/cuenta/editarSeguridad.dart';

class MiMercadoApp extends StatelessWidget {
  const MiMercadoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MiMercado',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFF58E181),
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF58E181)),
        textTheme: GoogleFonts.interTextTheme(),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => EditarSeguridadScreen(),
        '/registro': (context) => const RegistroScreen(),
        '/iniciar-sesion': (context) => const LoginScreen(),
        '/pedidos': (context) => const PedidosScreen(),
      },
    );
  }
}