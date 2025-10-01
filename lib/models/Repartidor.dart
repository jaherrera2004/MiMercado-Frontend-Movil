import 'Persona.dart';

class Repartidor extends Persona {
  String cedula;
  String estadoActual;
  List<dynamic> historialPedidos;
  String pedidoActual;

  Repartidor({
    required super.id,
    super.nombre,
    super.apellido,
    super.email,
    super.password,
    super.telefono,
    required this.cedula,
    required this.estadoActual,
    required this.historialPedidos,
    required this.pedidoActual,
  }) : super(firebaseCollection: 'repartidores');

  
}
