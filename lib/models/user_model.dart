/// Modelo de datos para el usuario
class UserModel {
  final String id;
  final String nombre;
  final String apellido;
  final String telefono;
  final String email;
  final DateTime? createdAt;

  UserModel({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.telefono,
    required this.email,
    this.createdAt,
  });

  /// Crea un UserModel desde un Map (para Firebase/API)
  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      id: id,
      nombre: map['nombre'] ?? '',
      apellido: map['apellido'] ?? '',
      telefono: map['telefono'] ?? '',
      email: map['email'] ?? '',
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
      'email': email,
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
      email: json['email'] ?? '',
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
      'email': email,
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
    String? email,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      apellido: apellido ?? this.apellido,
      telefono: telefono ?? this.telefono,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, nombre: $nombre, apellido: $apellido, email: $email)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is UserModel &&
      other.id == id &&
      other.nombre == nombre &&
      other.apellido == apellido &&
      other.telefono == telefono &&
      other.email == email;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      nombre.hashCode ^
      apellido.hashCode ^
      telefono.hashCode ^
      email.hashCode;
  }
}