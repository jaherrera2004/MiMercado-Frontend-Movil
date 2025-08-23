import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mi_mercado/SplashScreen.dart';
import 'package:mi_mercado/features/auth/pages/Register.dart';
import 'package:mi_mercado/features/auth/pages/IniciarSesion.dart';
import 'package:mi_mercado/features/homepage/HomePage.dart';
import 'package:mi_mercado/features/categoria/CategoriaScreen.dart'; // Imported CategoriaScreen

class MiMercadoApp extends StatelessWidget {
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
        '/categoria': (context) => CategoriaScreen(), // Registered CategoriaScreen route
      },
    );
  }
}