import 'package:get_storage/get_storage.dart';


/// Servicio para manejar el carrito de compras usando GetStorage
class CarritoService {
  static const String _keyCarrito = 'carrito_items';
  static const String _keyFechaActualizacion = 'carrito_fecha';
  
  final GetStorage _storage = GetStorage();

  // Singleton pattern
  static final CarritoService _instance = CarritoService._internal();
  factory CarritoService() => _instance;
  CarritoService._internal();

  /// Inicializa GetStorage (llamar al inicio de la app)
  static Future<void> init() async {
    await GetStorage.init();
    print('✅ GetStorage inicializado para CarritoService');
  }

  // ==================== MÉTODOS BÁSICOS ====================

  /// Obtiene todos los items del carrito
  List<CarritoItem> obtenerItems() {
    try {
      final itemsList = _storage.read<List>(_keyCarrito);
      if (itemsList != null) {
        return itemsList
            .map((item) => CarritoItem.fromMap(Map<String, dynamic>.from(item)))
            .toList();
      }
      return [];
    } catch (e) {
      print('❌ Error obteniendo items del carrito: $e');
      return [];
    }
  }

  /// Guarda los items en el carrito
  Future<void> _guardarItems(List<CarritoItem> items) async {
    try {
      final itemsMap = items.map((item) => item.toMap()).toList();
      await _storage.write(_keyCarrito, itemsMap);
      await _storage.write(_keyFechaActualizacion, DateTime.now().toIso8601String());
      print('💾 Carrito guardado: ${items.length} items');
    } catch (e) {
      print('❌ Error guardando carrito: $e');
    }
  }

  // ==================== OPERACIONES DEL CARRITO ====================

  /// Agrega un producto al carrito
  Future<void> agregarProducto({
    required String idProducto,
    required String nombre,
    required double precio,
    String? imagenUrl,
    int cantidad = 1,
  }) async {
    final items = obtenerItems();
    
    // Verificar si el producto ya existe
    final index = items.indexWhere((item) => item.idProducto == idProducto);
    
    if (index != -1) {
      // Si existe, aumentar la cantidad
      items[index].cantidad += cantidad;
      print('➕ Cantidad incrementada: ${items[index].nombre} -> ${items[index].cantidad}');
    } else {
      // Si no existe, agregar nuevo item
      items.add(CarritoItem(
        idProducto: idProducto,
        cantidad: cantidad,
        precio: precio,
        nombre: nombre,
        imagenUrl: imagenUrl,
      ));
      print('✅ Producto agregado al carrito: $nombre (cantidad: $cantidad)');
    }
    
    await _guardarItems(items);
  }

  /// Incrementa la cantidad de un producto en 1
  Future<void> incrementarCantidad(String idProducto) async {
    final items = obtenerItems();
    final index = items.indexWhere((item) => item.idProducto == idProducto);
    
    if (index != -1) {
      items[index].cantidad++;
      await _guardarItems(items);
      print('➕ Cantidad incrementada: ${items[index].nombre} -> ${items[index].cantidad}');
    }
  }

  /// Decrementa la cantidad de un producto en 1
  Future<void> decrementarCantidad(String idProducto) async {
    final items = obtenerItems();
    final index = items.indexWhere((item) => item.idProducto == idProducto);
    
    if (index != -1) {
      if (items[index].cantidad > 1) {
        items[index].cantidad--;
        await _guardarItems(items);
        print('➖ Cantidad decrementada: ${items[index].nombre} -> ${items[index].cantidad}');
      } else {
        // Si la cantidad es 1, eliminar el producto
        await eliminarProducto(idProducto);
      }
    }
  }

  /// Elimina un producto del carrito
  Future<void> eliminarProducto(String idProducto) async {
    final items = obtenerItems();
    final itemEliminado = items.firstWhere(
      (item) => item.idProducto == idProducto,
      orElse: () => CarritoItem(
        idProducto: '',
        cantidad: 0,
        precio: 0,
        nombre: '',
      ),
    );
    
    items.removeWhere((item) => item.idProducto == idProducto);
    await _guardarItems(items);
    
    if (itemEliminado.idProducto.isNotEmpty) {
      print('🗑️ Producto eliminado del carrito: ${itemEliminado.nombre}');
    }
  }

  /// Vacía todo el carrito
  Future<void> vaciarCarrito() async {
    await _storage.remove(_keyCarrito);
    await _storage.remove(_keyFechaActualizacion);
    print('🗑️ Carrito vaciado completamente');
  }

  // ==================== CONSULTAS ====================

  /// Calcula el subtotal del carrito
  double get subtotal {
    final items = obtenerItems();
    return items.fold(0.0, (sum, item) => sum + item.subtotal);
  }

}

/// Clase que representa un item en el carrito
class CarritoItem {
  String idProducto;
  int cantidad;
  double precio;
  String nombre;
  String? imagenUrl;

  CarritoItem({
    required this.idProducto,
    required this.cantidad,
    required this.precio,
    required this.nombre,
    this.imagenUrl,
  });

  /// Constructor desde Map
  factory CarritoItem.fromMap(Map<String, dynamic> map) {
    return CarritoItem(
      idProducto: map['id_producto'] ?? '',
      cantidad: map['cantidad'] ?? 0,
      precio: (map['precio'] ?? 0).toDouble(),
      nombre: map['nombre'] ?? '',
      imagenUrl: map['imagen_url'],
    );
  }

  /// Convierte a Map
  Map<String, dynamic> toMap() {
    return {
      'id_producto': idProducto,
      'cantidad': cantidad,
      'precio': precio,
      'nombre': nombre,
      'imagen_url': imagenUrl,
    };
  }

  /// Calcula el subtotal del item
  double get subtotal => precio * cantidad;

  @override
  String toString() {
    return 'CarritoItem(producto: $nombre, cantidad: $cantidad, precio: \$${precio.toStringAsFixed(2)})';
  }
}
