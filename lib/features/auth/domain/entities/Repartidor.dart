import 'Persona.dart';

class Repartidor extends Persona {
  String cedula;
  String estadoActual;
  List<dynamic> historialPedidos;
  String pedidoActual;

  Repartidor({
    super.id,
    super.nombre,
    super.apellido,
    required super.email,
    required super.password,
    required super.telefono,
    required this.cedula,
    required this.estadoActual,
    required this.historialPedidos,
    required this.pedidoActual,
  });

   // Método para crear un Repartidor desde un Map (como el que se obtiene de Firebase)
  factory Repartidor.fromMap(Map<String, dynamic> map) {
    return Repartidor(
      id: map['id'] ?? '',
      nombre: map['nombre'] ?? '',
      apellido: map['apellido'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      telefono: map['telefono'] ?? '',
      cedula: map['cedula'] ?? '',
      estadoActual: map['estadoActual'] ?? '',
      historialPedidos: List<dynamic>.from(map['historialPedidos'] ?? []),
      pedidoActual: map['pedidoActual'] ?? '',
    );
  }
}

enum EstadoRepartidor {
  conectado('Disponible'),
  ocupado('Ocupado'),
  desconectado('Desconectado');

  const EstadoRepartidor(this.displayName);
  final String displayName;

  // Método para obtener el enum desde un string
  static EstadoRepartidor fromString(String estado) {
    switch (estado.toLowerCase()) {
      case 'disponible':
        return EstadoRepartidor.conectado;
      case 'ocupado':
        return EstadoRepartidor.ocupado;
      case 'desconectado':
        return EstadoRepartidor.desconectado;
      default:
        return EstadoRepartidor.desconectado;
    }
  }
}