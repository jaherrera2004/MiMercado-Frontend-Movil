class RepartidorData {
  final String nombre;
  final String cedula;
  final String telefono;
  final String email;
  final String fechaIngreso;
  final String vehiculo;
  final String placa;
  final String licencia;
  final double calificacion;
  final int totalPedidos;
  final String estado;
  final String zona;
  final String banco;
  final String numeroCuenta;
  final String direccion;

  const RepartidorData({
    required this.nombre,
    required this.cedula,
    required this.telefono,
    required this.email,
    required this.fechaIngreso,
    required this.vehiculo,
    required this.placa,
    required this.licencia,
    required this.calificacion,
    required this.totalPedidos,
    required this.estado,
    required this.zona,
    required this.banco,
    required this.numeroCuenta,
    required this.direccion,
  });

  bool get estaActivo => estado == 'Activo';

  // Datos de ejemplo
  static RepartidorData get ejemplo => const RepartidorData(
    nombre: 'Juan Carlos Pérez',
    cedula: '1.234.567.890',
    telefono: '+57 300 123 4567',
    email: 'juan.perez@mimercado.com',
    fechaIngreso: '15 de Marzo, 2024',
    vehiculo: 'Motocicleta',
    placa: 'ABC-123',
    licencia: 'A2 - Vigente',
    calificacion: 4.7,
    totalPedidos: 156,
    estado: 'Activo',
    zona: 'Norte - Centro',
    banco: 'Bancolombia',
    numeroCuenta: '****-****-**45',
    direccion: 'Calle 45 #67-89, Barrio Los Pinos',
  );
}