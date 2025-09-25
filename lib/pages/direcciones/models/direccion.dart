/// Modelo para representar una dirección
class Direccion {
  final String? id;
  final String nombre;
  final String direccion;
  final String ciudad;
  final String telefono;
  final String? referencia;
  final bool esPrincipal;

  const Direccion({
    this.id,
    required this.nombre,
    required this.direccion,
    required this.ciudad,
    required this.telefono,
    this.referencia,
    this.esPrincipal = false,
  });

  /// Constructor para crear una copia con campos modificados
  Direccion copyWith({
    String? id,
    String? nombre,
    String? direccion,
    String? ciudad,
    String? telefono,
    String? referencia,
    bool? esPrincipal,
  }) {
    return Direccion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      direccion: direccion ?? this.direccion,
      ciudad: ciudad ?? this.ciudad,
      telefono: telefono ?? this.telefono,
      referencia: referencia ?? this.referencia,
      esPrincipal: esPrincipal ?? this.esPrincipal,
    );
  }

  /// Convertir a Map para almacenamiento/API
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'direccion': direccion,
      'ciudad': ciudad,
      'telefono': telefono,
      'referencia': referencia,
      'esPrincipal': esPrincipal,
    };
  }

  /// Crear desde Map
  factory Direccion.fromMap(Map<String, dynamic> map) {
    return Direccion(
      id: map['id']?.toString(),
      nombre: map['nombre'] ?? '',
      direccion: map['direccion'] ?? '',
      ciudad: map['ciudad'] ?? '',
      telefono: map['telefono'] ?? '',
      referencia: map['referencia'],
      esPrincipal: map['esPrincipal'] ?? false,
    );
  }

  /// Convertir a JSON string
  @override
  String toString() {
    return 'Direccion(id: $id, nombre: $nombre, direccion: $direccion, ciudad: $ciudad, telefono: $telefono, referencia: $referencia, esPrincipal: $esPrincipal)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is Direccion &&
      other.id == id &&
      other.nombre == nombre &&
      other.direccion == direccion &&
      other.ciudad == ciudad &&
      other.telefono == telefono &&
      other.referencia == referencia &&
      other.esPrincipal == esPrincipal;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      nombre.hashCode ^
      direccion.hashCode ^
      ciudad.hashCode ^
      telefono.hashCode ^
      referencia.hashCode ^
      esPrincipal.hashCode;
  }
}