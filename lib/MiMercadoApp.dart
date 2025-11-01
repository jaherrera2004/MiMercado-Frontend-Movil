import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mi_mercado/SplashScreen.dart';


import 'package:mi_mercado/features/auth/presentation/pages/RegisterScreen.dart';
import 'package:mi_mercado/features/usuario/cuenta/presentation/pages/mi_cuenta_screen.dart';
import 'package:mi_mercado/features/usuario/cuenta/presentation/pages/datos_perfil_screen.dart';
import 'package:mi_mercado/features/usuario/cuenta/presentation/pages/seguridad_screen.dart';
import 'package:mi_mercado/features/usuario/cuenta/presentation/pages/editar_contrasena_screen.dart';
import 'package:mi_mercado/features/usuario/productos/presentation/pages/carrito_screen.dart';
import 'package:mi_mercado/features/usuario/productos/presentation/pages/homepage_screen.dart';
import 'package:mi_mercado/pages/auth/IniciarSesionScreen.dart';


import 'package:mi_mercado/features/usuario/productos/presentation/pages/productos_filtrados_screen.dart';
import 'package:mi_mercado/pages/pago/PagoScreen.dart';
import 'package:mi_mercado/pages/pedidos/PedidosScreen.dart';
import 'package:mi_mercado/pages/pedidos/PedidoDetalleScreen.dart';
import 'package:mi_mercado/features/usuario/direcciones/presentation/pages/direccion_screen.dart';
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