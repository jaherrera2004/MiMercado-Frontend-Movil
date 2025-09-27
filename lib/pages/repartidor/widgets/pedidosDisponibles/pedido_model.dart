class Pedido {
  final String cliente;
  final String direccion;
  final int total;
  final int items;
  final double distancia;
  final int tiempo;
  final String? notas;
  final int tiempoTranscurrido;

  const Pedido({
    required this.cliente,
    required this.direccion,
    required this.total,
    required this.items,
    required this.distancia,
    required this.tiempo,
    this.notas,
    required this.tiempoTranscurrido,
  });

  // Datos de ejemplo para testing
  static List<Pedido> get pedidosEjemplo => [
    const Pedido(
      cliente: 'María González',
      direccion: 'Calle 45 #23-12, Barrio Centro',
      total: 14000,
      items: 3,
      distancia: 2.5,
      tiempo: 15,
      notas: 'Casa color amarillo, portón negro',
      tiempoTranscurrido: 15,
    ),
    const Pedido(
      cliente: 'Carlos Rodríguez',
      direccion: 'Carrera 15 #67-89, Barrio Norte',
      total: 20500,
      items: 2,
      distancia: 1.2,
      tiempo: 8,
      tiempoTranscurrido: 8,
    ),
    const Pedido(
      cliente: 'Ana Patricia Jiménez',
      direccion: 'Avenida 80 #12-34, Barrio Sur',
      total: 31000,
      items: 4,
      distancia: 4.1,
      tiempo: 22,
      notas: 'Apartamento 302, edificio Las Flores',
      tiempoTranscurrido: 25,
    ),
  ];
}