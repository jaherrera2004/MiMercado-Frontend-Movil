import 'package:get_storage/get_storage.dart';

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

/// Servicio para manejar el carrito de compras usando GetStorage
class CarritoService {
  static const String _keyCarrito = 'carrito_items';
  static const String _keyUserId = 'carrito_user_id';
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

  /// Obtiene el ID del usuario del carrito
  String? obtenerUserId() {
    return _storage.read<String>(_keyUserId);
  }

  /// Establece el ID del usuario del carrito
  Future<void> establecerUserId(String userId) async {
    await _storage.write(_keyUserId, userId);
  }

  /// Obtiene la fecha de última actualización
  DateTime? obtenerFechaActualizacion() {
    final fecha = _storage.read<String>(_keyFechaActualizacion);
    return fecha != null ? DateTime.parse(fecha) : null;
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

  /// Actualiza la cantidad de un producto
  Future<void> actualizarCantidad(String idProducto, int nuevaCantidad) async {
    final items = obtenerItems();
    final index = items.indexWhere((item) => item.idProducto == idProducto);
    
    if (index != -1) {
      if (nuevaCantidad <= 0) {
        // Si la cantidad es 0 o negativa, eliminar el item
        await eliminarProducto(idProducto);
      } else {
        items[index].cantidad = nuevaCantidad;
        await _guardarItems(items);
        print('✅ Cantidad actualizada: ${items[index].nombre} -> $nuevaCantidad');
      }
    }
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

  /// Elimina todo (carrito + user id)
  Future<void> limpiarTodo() async {
    await _storage.remove(_keyCarrito);
    await _storage.remove(_keyUserId);
    await _storage.remove(_keyFechaActualizacion);
    print('🗑️ Carrito y datos eliminados completamente');
  }

  // ==================== CONSULTAS ====================

  /// Obtiene la cantidad de un producto específico
  int obtenerCantidadProducto(String idProducto) {
    final items = obtenerItems();
    final item = items.firstWhere(
      (item) => item.idProducto == idProducto,
      orElse: () => CarritoItem(
        idProducto: '',
        cantidad: 0,
        precio: 0,
        nombre: '',
      ),
    );
    return item.cantidad;
  }

  /// Verifica si un producto está en el carrito
  bool contieneProducto(String idProducto) {
    final items = obtenerItems();
    return items.any((item) => item.idProducto == idProducto);
  }

  /// Calcula el total de items en el carrito
  int get totalItems {
    final items = obtenerItems();
    return items.fold(0, (sum, item) => sum + item.cantidad);
  }

  /// Calcula el subtotal del carrito
  double get subtotal {
    final items = obtenerItems();
    return items.fold(0.0, (sum, item) => sum + item.subtotal);
  }

  /// Calcula el total con domicilio y servicio
  double calcularTotal({double domicilio = 5000.0, double servicio = 3000.0}) {
    return subtotal + domicilio + servicio;
  }

  /// Verifica si el carrito está vacío
  bool get isEmpty {
    return obtenerItems().isEmpty;
  }

  /// Verifica si el carrito tiene items
  bool get isNotEmpty {
    return obtenerItems().isNotEmpty;
  }

  /// Obtiene un resumen del carrito
  Map<String, dynamic> obtenerResumen() {
    final items = obtenerItems();
    const domicilio = 5000.0;
    const servicio = 3000.0;
    final subtotalCarrito = subtotal;
    final totalCarrito = calcularTotal(domicilio: domicilio, servicio: servicio);

    return {
      'items': items.map((item) => item.toMap()).toList(),
      'cantidad_items': items.length,
      'total_productos': totalItems,
      'subtotal': subtotalCarrito,
      'domicilio': domicilio,
      'servicio': servicio,
      'total': totalCarrito,
      'fecha_actualizacion': obtenerFechaActualizacion()?.toIso8601String(),
    };
  }

  // ==================== UTILIDADES ====================

  /// Imprime el estado actual del carrito (útil para debugging)
  void imprimirEstado() {
    final items = obtenerItems();
    print('🛒 === ESTADO DEL CARRITO ===');
    print('   Usuario: ${obtenerUserId() ?? "No definido"}');
    print('   Total items: $totalItems');
    print('   Productos diferentes: ${items.length}');
    print('   Subtotal: \$${subtotal.toStringAsFixed(2)}');
    print('   Total: \$${calcularTotal().toStringAsFixed(2)}');
    print('   Última actualización: ${obtenerFechaActualizacion()}');
    
    if (items.isNotEmpty) {
      print('   Productos:');
      for (var item in items) {
        print('     - ${item.nombre}: ${item.cantidad} x \$${item.precio.toStringAsFixed(2)} = \$${item.subtotal.toStringAsFixed(2)}');
      }
    }
    print('🛒 ========================');
  }

  /// Exporta el carrito a un formato listo para crear un pedido
  Map<String, dynamic> exportarParaPedido() {
    final items = obtenerItems();
    return {
      'lista_productos': items.map((item) => {
        'id_producto': item.idProducto,
        'cantidad': item.cantidad,
      }).toList(),
      'costo_total': calcularTotal(),
    };
  }
}
