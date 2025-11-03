import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mi_mercado/SplashScreen.dart';
import 'package:mi_mercado/features/auth/presentation/pages/login_screen.dart';


import 'package:mi_mercado/features/auth/presentation/pages/register_screen.dart';
import 'package:mi_mercado/features/pedidos/presentation/pages/pedidos_screen.dart';
import 'package:mi_mercado/features/repartidor/pedidos/presentation/pages/pedido_actual_screen.dart';
import 'package:mi_mercado/features/usuario/cuenta/presentation/pages/mi_cuenta_screen.dart';
import 'package:mi_mercado/features/usuario/cuenta/presentation/pages/datos_perfil_screen.dart';
import 'package:mi_mercado/features/usuario/cuenta/presentation/pages/seguridad_screen.dart';
import 'package:mi_mercado/features/usuario/cuenta/presentation/pages/editar_contrasena_screen.dart';
import 'package:mi_mercado/features/usuario/pago/presentation/pages/pago_screen.dart';
import 'package:mi_mercado/features/usuario/productos/presentation/pages/carrito_screen.dart';
import 'package:mi_mercado/features/usuario/productos/presentation/pages/homepage_screen.dart';


import 'package:mi_mercado/features/usuario/productos/presentation/pages/productos_filtrados_screen.dart';
import 'package:mi_mercado/features/pedidos/presentation/pages/pedidos_detalle_screen.dart';
import 'package:mi_mercado/features/usuario/direcciones/presentation/pages/direccion_screen.dart';

import 'package:mi_mercado/features/repartidor/home/presentation/pages/repartidor_home_screen.dart';
import 'package:mi_mercado/features/repartidor/pedidos/presentation/pages/pedidos_disponibles_screen.dart';

class MiMercadoApp extends StatelessWidget {
  const MiMercadoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
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
        '/categoria': (context) => const CategoriaScreen(),
        '/carrito': (context) => CarritoScreen(),
        '/pago': (context) => PagoScreen(),
        '/pedidos': (context) => const PedidosScreen(),
        '/detalle-pedido': (context) => const DatosPedidosScreen(),
        '/direcciones': (context) => const DireccionesScreen(),
        '/cuenta': (context) => const CuentaScreen(),
        '/datos-perfil': (context) => const DatosPerfilScreen(),
        '/seguridad': (context) => const SeguridadScreen(),
        '/editar-seguridad': (context) => const EditarContrasenaScreen(),
        '/repartidor': (context) => const RepartidorHomeScreen(),
        '/pedidos-disponibles': (context) => const PedidosDisponiblesScreen(),
        '/pedido-actual': (context) => const PedidoActualScreen(),
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