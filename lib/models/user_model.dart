/// Modelo de datos para el usuario
class UserModel {
  final String id;
  final String nombre;
  final String apellido;
  final String telefono;
  final String correo; // Cambio de email a correo para coincidir con Firestore
  final List<Map<String, dynamic>> direcciones;
  final List<Map<String, dynamic>> historialPedidos;
  final DateTime? createdAt;

  UserModel({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.telefono,
    required this.correo,
    this.direcciones = const [],
    this.historialPedidos = const [],
    this.createdAt,
  });

  /// Crea un UserModel desde un Map (para Firebase/API)
  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      id: id,
      nombre: map['nombre'] ?? '',
      apellido: map['apellido'] ?? '',
      telefono: map['telefono'] ?? '',
      correo: map['correo'] ?? '',
      direcciones: List<Map<String, dynamic>>.from(map['direcciones'] ?? []),
      historialPedidos: List<Map<String, dynamic>>.from(map['historial_pedidos'] ?? []),
      createdAt: map['createdAt'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'])
          : null,
    );
  }

  /// Convierte el UserModel a Map (para Firebase/API)
  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'apellido': apellido,
      'telefono': telefono,
      'correo': correo,
      'direcciones': direcciones,
      'historial_pedidos': historialPedidos,
      'createdAt': createdAt?.millisecondsSinceEpoch,
    };
  }

  /// Crea un UserModel desde JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      nombre: json['nombre'] ?? '',
      apellido: json['apellido'] ?? '',
      telefono: json['telefono'] ?? '',
      correo: json['correo'] ?? '',
      direcciones: List<Map<String, dynamic>>.from(json['direcciones'] ?? []),
      historialPedidos: List<Map<String, dynamic>>.from(json['historial_pedidos'] ?? []),
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt'])
          : null,
    );
  }

  /// Convierte el UserModel a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'apellido': apellido,
      'telefono': telefono,
      'correo': correo,
      'direcciones': direcciones,
      'historial_pedidos': historialPedidos,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  /// Getter para nombre completo
  String get nombreCompleto => '$nombre $apellido';

  /// Copia el objeto con nuevos valores
  UserModel copyWith({
    String? id,
    String? nombre,
    String? apellido,
    String? telefono,
    String? correo,
    List<Map<String, dynamic>>? direcciones,
    List<Map<String, dynamic>>? historialPedidos,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      apellido: apellido ?? this.apellido,
      telefono: telefono ?? this.telefono,
      correo: correo ?? this.correo,
      direcciones: direcciones ?? this.direcciones,
      historialPedidos: historialPedidos ?? this.historialPedidos,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, nombre: $nombre, apellido: $apellido, correo: $correo)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is UserModel &&
      other.id == id &&
      other.nombre == nombre &&
      other.apellido == apellido &&
      other.telefono == telefono &&
      other.correo == correo;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      nombre.hashCode ^
      apellido.hashCode ^
      telefono.hashCode ^
      correo.hashCode;
  }
}