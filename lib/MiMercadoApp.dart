import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mi_mercado/SplashScreen.dart';
import 'package:mi_mercado/pages/auth/RegisterScreen.dart';
import 'package:mi_mercado/pages/auth/IniciarSesionScreen.dart';
import 'package:mi_mercado/pages/homepage/HomePageScreen.dart';
import 'package:mi_mercado/pages/categoria/CategoriaScreen.dart';
import 'package:mi_mercado/pages/carrito/CarritoScreen.dart';
import 'package:mi_mercado/pages/pago/PagoScreen.dart';
import 'package:mi_mercado/pages/pedidos/PedidosScreen.dart';
import 'package:mi_mercado/pages/pedidos/PedidoDetalleScreen.dart';
import 'package:mi_mercado/pages/direcciones/DireccionesScreen.dart';
import 'package:mi_mercado/pages/cuenta/MiCuentaScreen.dart';
import 'package:mi_mercado/pages/cuenta/DatosPerfilScreen.dart';
import 'package:mi_mercado/pages/cuenta/SeguridadScreen.dart';
import 'package:mi_mercado/pages/cuenta/EditarPerfilScreen.dart';
import 'package:mi_mercado/pages/cuenta/EditarContrase%C3%B1aScreen.dart';
import 'package:mi_mercado/pages/repartidor/RepartidorPageScreen.dart';

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
        '/registro': (context) => const RegisterScreen(),
        '/iniciar-sesion': (context) => const IniciarSesionScreen(),
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
        '/repartidor': (context) => const RepartidorPage(),
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