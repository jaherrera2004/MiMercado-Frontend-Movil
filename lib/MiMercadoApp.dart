import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mi_mercado/SplashScreen.dart';
import 'package:mi_mercado/features/auth/pages/Register.dart';
import 'package:mi_mercado/features/auth/pages/IniciarSesion.dart';
import 'package:mi_mercado/features/homepage/HomePage.dart';
import 'package:mi_mercado/features/categoria/CategoriaScreen.dart'; // Imported CategoriaScreen
import 'package:mi_mercado/features/carrito/CarritoScreen.dart';
import 'package:mi_mercado/features/pago/PagoScreen.dart';
import 'package:mi_mercado/features/pedidos/listaPedidos.dart';
import 'package:mi_mercado/features/pedidos/datosPedido.dart';
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
        '/': (context) => SplashScreen(),
        '/registro': (context) => const RegistroScreen(),
        '/iniciar-sesion': (context) => const LoginScreen(),
        '/home': (context) => HomePage(),
        '/categoria': (context) => CategoriaScreen(),
        '/carrito': (context) => CarritoScreen(),
        '/pago': (context) => PagoScreen(),
        '/pedidos': (context) => const PedidosScreen(),
        '/detalle-pedido': (context) => const DatosPedidosScreen(),
        '/direcciones': (context) => const DireccionesScreen(),
        '/cuenta': (context) => const CuentaScreen(),
        '/datos-perfil': (context) => const DatosScreen(),
        '/seguridad': (context) => const PasswordScreen(),
        '/editar-perfil': (context) => const EditarPerfilScreen(),
        '/editar-seguridad': (context) => const EditarSeguridadScreen(),
      },
    );
  }

}
//import 'package:mi_mercado/features/direcciones/listaDirecciones.dart';
//import 'package:mi_mercado/features/cuenta/perfil.dart';
//import 'package:mi_mercado/features/cuenta/datosPerfil.dart';
//import 'package:mi_mercado/features/cuenta/seguridad.dart';
//import 'package:mi_mercado/features/cuenta/editarPerfil.dart';
//import 'package:mi_mercado/features/cuenta/editarSeguridad.dart';