import 'package:cloud_firestore/cloud_firestore.dart';

class Categoria {
  
  String id;
  String imagenUrl;
  String nombre;

  String firebaseCollection = 'categorias';

  Categoria({
    required this.id,
    required this.imagenUrl,
    required this.nombre,
  });

  /// Constructor para crear una Categoria desde un Map (Firebase/JSON)
  factory Categoria.fromMap(Map<String, dynamic> map, String documentId) {
    return Categoria(
      id: documentId,
      imagenUrl: map['imagen_url'] ?? '',
      nombre: map['nombre'] ?? '',
    );
  }

  /// Convierte la Categoria a un Map para guardar en Firebase
  Map<String, dynamic> toMap() {
    return {
      'imagen_url': imagenUrl,
      'nombre': nombre,
    };
  }

  /// Método estático para obtener todas las categorías desde Firebase
  static Future<List<Categoria>> obtenerCategorias() async {
    try {
      print('📚 Obteniendo categorías desde Firebase...');
      
      final firebase = FirebaseFirestore.instance;
      
      // Obtener todos los documentos de la colección categorias
      final QuerySnapshot querySnapshot = await firebase
          .collection('categorias')
          .get();

      print('📊 Total de categorías encontradas: ${querySnapshot.docs.length}');

      // Convertir cada documento a un objeto Categoria con manejo de errores
      final List<Categoria> categorias = [];
      
      for (var doc in querySnapshot.docs) {
        try {
          final data = doc.data();
          if (data != null) {
            final categoria = Categoria.fromMap(data as Map<String, dynamic>, doc.id);
            print('  ✓ Categoría procesada: ${categoria.nombre} (ID: ${categoria.id})');
            categorias.add(categoria);
          } else {
            print('  ⚠️ Documento sin datos: ${doc.id}');
          }
        } catch (e) {
          print('  ❌ Error procesando documento ${doc.id}: $e');
          // Continuar con el siguiente documento
        }
      }

      print('✅ Categorías cargadas exitosamente: ${categorias.length}');
      return categorias;
      
    } catch (e, stackTrace) {
      print('❌ Error obteniendo categorías: $e');
      print('StackTrace: $stackTrace');
      throw Exception('Error al obtener categorías: ${e.toString()}');
    }
  }


  @override
  String toString() {
    return 'Categoria(id: $id, nombre: $nombre, imagenUrl: $imagenUrl)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Categoria && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;


}