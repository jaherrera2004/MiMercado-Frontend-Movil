import 'package:flutter/material.dart';

enum EstadoPedido { entregado, cancelado }

class HistorialPedido {
  final String id;
  final String cliente;
  final String direccion;
  final int total;
  final String fecha;
  final EstadoPedido estado;
  final String tiempo;
  final String distancia;

  const HistorialPedido({
    required this.id,
    required this.cliente,
    required this.direccion,
    required this.total,
    required this.fecha,
    required this.estado,
    required this.tiempo,
    required this.distancia,
  });

  Color get colorEstado {
    switch (estado) {
      case EstadoPedido.entregado:
        return Colors.green;
      case EstadoPedido.cancelado:
        return Colors.red;
    }
  }

  String get textoEstado {
    switch (estado) {
      case EstadoPedido.entregado:
        return 'Entregado';
      case EstadoPedido.cancelado:
        return 'Cancelado';
    }
  }

  bool get fueEntregado => estado == EstadoPedido.entregado;

  // Datos de ejemplo para testing
  static List<HistorialPedido> get historialEjemplo => [
    const HistorialPedido(
      id: '#001',
      cliente: 'María González',
      direccion: 'Calle 45 #23-12',
      total: 14000,
      fecha: 'Hoy, 2:30 PM',
      estado: EstadoPedido.entregado,
      tiempo: '18 min',
      distancia: '2.5 km',
    ),
    const HistorialPedido(
      id: '#002',
      cliente: 'Carlos Rodríguez',
      direccion: 'Carrera 15 #67-89',
      total: 20500,
      fecha: 'Hoy, 11:45 AM',
      estado: EstadoPedido.entregado,
      tiempo: '12 min',
      distancia: '1.2 km',
    ),
    const HistorialPedido(
      id: '#003',
      cliente: 'Ana Patricia',
      direccion: 'Avenida 80 #12-34',
      total: 31000,
      fecha: 'Ayer, 4:20 PM',
      estado: EstadoPedido.entregado,
      tiempo: '25 min',
      distancia: '4.1 km',
    ),
    const HistorialPedido(
      id: '#004',
      cliente: 'Luis Martínez',
      direccion: 'Calle 12 #45-67',
      total: 8900,
      fecha: 'Ayer, 1:15 PM',
      estado: EstadoPedido.cancelado,
      tiempo: '0 min',
      distancia: '3.2 km',
    ),
    const HistorialPedido(
      id: '#005',
      cliente: 'Sandra López',
      direccion: 'Carrera 25 #89-12',
      total: 17800,
      fecha: '2 días atrás',
      estado: EstadoPedido.entregado,
      tiempo: '15 min',
      distancia: '1.8 km',
    ),
  ];
}