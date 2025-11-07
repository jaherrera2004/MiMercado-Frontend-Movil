# 📘 Guía de Arquitectura Hexagonal - MiMercado

## 📑 Tabla de Contenidos

1. [Introducción](#introducción)
2. [Estructura de la Arquitectura Hexagonal](#estructura-de-la-arquitectura-hexagonal)
3. [Flujo de Datos Completo](#flujo-de-datos-completo)
4. [Ubicación de Archivos](#ubicación-de-archivos)
5. [Inyección de Dependencias](#inyección-de-dependencias)
6. [GetX Controllers](#getx-controllers)
7. [Ejemplo Práctico: Creación de una Nueva Funcionalidad](#ejemplo-práctico-creación-de-una-nueva-funcionalidad)
8. [Mejores Prácticas](#mejores-prácticas)

---

## 🎯 Introducción

Este proyecto implementa **Arquitectura Hexagonal** (también conocida como **Ports and Adapters**) combinada con **Clean Architecture**. Esta arquitectura separa la lógica de negocio del código de infraestructura (bases de datos, UI, frameworks externos).

### Ventajas
- ✅ **Independencia de frameworks**: La lógica de negocio no depende de Flutter, Firebase, GetX, etc.
- ✅ **Testeable**: Cada capa puede ser probada independientemente
- ✅ **Mantenible**: Cambios en una capa no afectan a las demás
- ✅ **Escalable**: Fácil de agregar nuevas funcionalidades

---

## 🏗️ Estructura de la Arquitectura Hexagonal

La arquitectura se divide en **3 capas principales**:

```
lib/features/[feature]/
├── data/              # Capa de Datos (Infraestructura)
│   ├── datasources/   # Implementaciones de acceso a datos
│   └── repositories/  # Implementaciones de repositorios
├── domain/            # Capa de Dominio (Lógica de Negocio)
│   ├── entities/      # Modelos de datos puros
│   ├── repositories/  # Interfaces de repositorios
│   ├── datasources/   # Interfaces de datasources
│   └── useCases/      # Casos de uso (lógica de negocio)
└── presentation/      # Capa de Presentación (UI)
    ├── controllers/   # Controladores GetX
    ├── pages/         # Pantallas
    └── widgets/       # Widgets reutilizables
```

### 📦 Descripción de cada capa

#### 1️⃣ **Domain Layer** (Capa de Dominio - Centro de la Arquitectura)
- **Entities**: Objetos de negocio puros (ej: `Producto`, `Usuario`, `Pedido`)
- **Repositories (Interfaces)**: Contratos que definen qué operaciones se pueden realizar
- **DataSources (Interfaces)**: Contratos para acceso a datos externos
- **Use Cases**: Casos de uso específicos (ej: `ObtenerProductos`, `AgregarAlCarrito`)

**Regla de oro**: Esta capa **NO** debe depender de ninguna otra. Es completamente independiente.

#### 2️⃣ **Data Layer** (Capa de Datos - Adaptadores)
- **DataSources Implementations**: Implementaciones concretas que acceden a Firebase, APIs, SQLite, etc.
- **Repositories Implementations**: Implementan las interfaces del dominio y coordinan datasources

**Responsabilidad**: Convertir datos externos al formato de las entidades del dominio.

#### 3️⃣ **Presentation Layer** (Capa de Presentación - UI)
- **Controllers**: Controladores GetX que orquestan la UI y los use cases
- **Pages**: Pantallas de la aplicación
- **Widgets**: Componentes visuales reutilizables

**Responsabilidad**: Mostrar datos al usuario y capturar sus interacciones.

---

## 🔄 Flujo de Datos Completo

### Ejemplo: Obtener lista de productos

```
┌──────────────────┐
│   UI (Screen)    │
│  homepage_screen │
└────────┬─────────┘
         │ 1. Usuario abre la pantalla
         ↓
┌──────────────────────────┐
│   Controller (GetX)      │
│  HomePageController      │
│  - onInit()             │
│  - cargarProductos()    │
└────────┬─────────────────┘
         │ 2. Llama al Use Case
         ↓
┌──────────────────────────┐
│   Use Case               │
│  ObtenerProductos        │
│  - call(NoParams)       │
└────────┬─────────────────┘
         │ 3. Solicita datos al Repository
         ↓
┌──────────────────────────┐
│   Repository Interface   │
│  ProductoRepository      │
└────────┬─────────────────┘
         │
         ↓
┌──────────────────────────┐
│ Repository Implementation│
│ ProductoRepositoryImpl   │
└────────┬─────────────────┘
         │ 4. Delega al DataSource
         ↓
┌──────────────────────────┐
│  DataSource Interface    │
│  ProductoDataSource      │
└────────┬─────────────────┘
         │
         ↓
┌──────────────────────────┐
│ DataSource Implementation│
│ ProductoDataSourceImpl   │
│ - Firebase/API calls     │
└────────┬─────────────────┘
         │ 5. Obtiene datos de Firebase
         ↓
    ☁️ Firebase ☁️
         │
         │ 6. Retorna Map/JSON
         ↓
┌──────────────────────────┐
│ DataSource Implementation│
│ - fromMap() → Entity     │
└────────┬─────────────────┘
         │ 7. Retorna List<Producto>
         ↓
┌──────────────────────────┐
│ Repository Implementation│
└────────┬─────────────────┘
         │ 8. Retorna List<Producto>
         ↓
┌──────────────────────────┐
│   Use Case               │
│  - Right(productos) o    │
│    Left(Failure)         │
└────────┬─────────────────┘
         │ 9. Retorna Either<Failure, List<Producto>>
         ↓
┌──────────────────────────┐
│   Controller             │
│  - productos.assignAll() │
└────────┬─────────────────┘
         │ 10. Actualiza estado observable
         ↓
┌──────────────────────────┐
│   UI (Obx/GetBuilder)    │
│  - Renderiza productos   │
└──────────────────────────┘
```

### 📝 Descripción paso a paso

1. **Usuario abre pantalla**: La pantalla inicializa el controller
2. **Controller**: `onInit()` se ejecuta automáticamente y llama a `cargarProductos()`
3. **Use Case**: El controller llama al caso de uso `ObtenerProductos.call(NoParams())`
4. **Repository Interface**: El use case usa la interfaz del repositorio
5. **Repository Implementation**: Implementación concreta que delega al datasource
6. **DataSource Implementation**: Hace la llamada a Firebase Firestore
7. **Firebase**: Retorna los datos en formato Map/JSON
8. **Conversión**: DataSource convierte Map → `Producto` entity usando `Producto.fromMap()`
9. **Retorno**: Los datos suben por todas las capas
10. **UI Update**: Controller actualiza variables observables `.obs` y la UI se reconstruye automáticamente

---

## 📂 Ubicación de Archivos

### Estructura de un feature completo

Ejemplo: Feature de **Productos**

```
lib/features/usuario/productos/
│
├── data/
│   ├── datasources/
│   │   ├── producto_datasource_impl.dart       # Implementación acceso Firebase
│   │   ├── categoria_datasource_impl.dart
│   │   └── carrito_datasource_impl.dart
│   │
│   └── repositories/
│       ├── producto_repository_impl.dart       # Implementación del contrato
│       ├── categoria_repository_impl.dart
│       └── carrito_repository_impl.dart
│
├── domain/
│   ├── datasources/
│   │   ├── producto_datasource.dart            # Interface (contrato)
│   │   ├── categoria_datasource.dart
│   │   └── carrito_datasource.dart
│   │
│   ├── entities/
│   │   ├── Producto.dart                       # Modelo puro (solo datos)
│   │   ├── Categoria.dart
│   │   └── CarritoItem.dart
│   │
│   ├── repositories/
│   │   ├── producto_repository.dart            # Interface (contrato)
│   │   ├── categoria_repository.dart
│   │   └── carrito_repository.dart
│   │
│   └── useCases/
│       ├── obtener_productos.dart              # Caso de uso específico
│       ├── obtener_productos_por_categoria.dart
│       ├── agregar_producto_carrito.dart
│       ├── obtener_items_carrito.dart
│       ├── incrementar_cantidad.dart
│       ├── decrementar_cantidad.dart
│       └── eliminar_producto_carrito.dart
│
└── presentation/
    ├── controllers/
    │   ├── homepage_controller.dart            # Controlador GetX
    │   ├── carrito_controller.dart
    │   └── productos_filtrados_controller.dart
    │
    ├── pages/
    │   ├── homepage_screen.dart                # Pantalla principal
    │   ├── carrito_screen.dart
    │   └── productos_filtrados_screen.dart
    │
    └── widgets/
        ├── producto_card.dart                  # Widgets específicos del feature
        ├── categoria_carousel.dart
        └── widgets.dart                         # Barrel file (exporta todos)
```

### 🗂️ Archivos Core (compartidos)

```
lib/core/
├── di/
│   └── injection.dart              # Configuración de inyección de dependencias
│
├── error/
│   └── failure.dart                # Clases de error personalizadas
│
├── useCases/
│   └── use_case.dart               # Clase base abstracta para use cases
│
├── utils/
│   ├── shared_preferences_utils.dart
│   └── bcrypt_utils.dart
│
└── widgets/
    ├── buttons/
    ├── forms/
    ├── navigation/
    └── text/
```

---

## 💉 Inyección de Dependencias con GetX

### ¿Qué es GetX para inyección de dependencias?

**GetX** incluye un poderoso sistema de inyección de dependencias integrado que reemplaza completamente la necesidad de GetIt. Todas las dependencias se registran usando `Get.put()`, `Get.lazyPut()`, etc.

### Archivo: `lib/core/di/injection.dart`

Este archivo configura **todas** las dependencias de la aplicación usando solo GetX.

### ⚠️ **REGLA CRÍTICA: Registro Obligatorio**

**SI CREAS un repositorio, use case, datasource o controller, SI O SI debes registrarlo en `setupDependencies()`.**

- ✅ **DataSources** → `Get.put(instance, permanent: true)`
- ✅ **Repositories** → `Get.put<Interface>(implementation, permanent: true)`
- ✅ **Use Cases** → `Get.lazyPut(() => UseCase(repository))`
- ✅ **Controllers** → `Get.put()` o `Get.lazyPut()` según necesidad

**Si no registras una clase, la aplicación fallará con errores de inyección de dependencias.**

### Tipos de registro en GetX

```dart
// 1. Get.put() - Instancia inmediata (se crea al registrar)
Get.put(ProductoDataSourceImpl(FirebaseFirestore.instance), permanent: true);

// 2. Get.lazyPut() - Instancia perezosa (se crea la primera vez que se solicita)
Get.lazyPut(() => ProductoRepositoryImpl(Get.find<ProductoDataSourceImpl>()));

// 3. Get.lazyPut() con fenix - Se recrea automáticamente si es destruida
Get.lazyPut(() => HomePageController(), fenix: true);
```

### 📋 Orden de registro (IMPORTANTE)

El orden de registro es **crítico**. Debes registrar las dependencias de abajo hacia arriba:

```dart
void setupDependencies() {
  // 1️⃣ PRIMERO: DataSources (no tienen dependencias)
  Get.put(ProductoDataSourceImpl(FirebaseFirestore.instance), permanent: true);
  
  // 2️⃣ SEGUNDO: Repositories (dependen de DataSources)
  Get.put<ProductoRepository>(
    ProductoRepositoryImpl(Get.find<ProductoDataSourceImpl>()), 
    permanent: true
  );
  
  // 3️⃣ TERCERO: Use Cases (dependen de Repositories)
  Get.lazyPut(() => ObtenerProductos(Get.find<ProductoRepository>()));
  
  // 4️⃣ CUARTO: Controllers (dependen de Use Cases)
  Get.lazyPut(() => HomePageController(
    obtenerCategorias: Get.find<ObtenerCategorias>(),
    obtenerProductos: Get.find<ObtenerProductos>(),
  ), fenix: true);
}
```

### 🔧 Cuándo usar cada tipo de registro

| Tipo | Cuándo usar | Ejemplo |
|------|-------------|---------|
| `Get.put(permanent: true)` | DataSources, Repositories (una sola instancia) | Firebase connections, HTTP clients |
| `Get.lazyPut()` | Use Cases, Controllers (nueva instancia cuando se necesita) | Use cases sin estado |
| `Get.lazyPut(fenix: true)` | Controllers de pantallas (auto-recreación) | Controllers que pueden ser destruidos |

### 🎯 GetX: Gestión completa de dependencias

GetX maneja tanto la **inyección de dependencias** como el **ciclo de vida** y **estado reactivo**:

```dart
// Registro completo en GetX
Get.lazyPut(() => HomePageController(
  obtenerProductos: Get.find<ObtenerProductos>(),
), fenix: true);

// Uso en la UI
final controller = Get.find<HomePageController>();
```

**¿Por qué GetX es suficiente?**
- **Inyección**: `Get.put()`, `Get.lazyPut()`, `Get.find()`
- **Ciclo de vida**: `onInit()`, `onClose()` automáticos
- **Estado reactivo**: Variables `.obs` y `Obx()`

### Parámetros de GetX:

```dart
// Get.put() - Instancia inmediata, vive toda la vida de la app
Get.put(CarritoController(), permanent: true);

// Get.lazyPut() - Instancia perezosa (se crea al usar Get.find())
Get.lazyPut(() => HomePageController());

// Get.lazyPut() con fenix - Se recrea automáticamente si es destruida
Get.lazyPut(() => PagoController(), fenix: true);
```

### 🚀 Inicialización en `main.dart`

```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // ⭐ INICIALIZAR INYECCIÓN DE DEPENDENCIAS
  setupDependencies();
  
  runApp(const MiMercadoApp());
}
```

**IMPORTANTE**: `setupDependencies()` se llama **UNA SOLA VEZ** al inicio de la app.

---

## 🎮 GetX Controllers

### ⚠️ **REGLA CRÍTICA: Cada Vista debe tener un Controller**

**TODAS las pantallas/vistas DEBEN tener su propio Controller.** Esta es una regla fundamental de la arquitectura:

- ✅ **HomePage** → `HomePageController`
- ✅ **LoginScreen** → `LoginController` 
- ✅ **ProductoDetallePage** → `ProductoDetalleController`
- ✅ **CarritoScreen** → `CarritoController`

**¿Por qué?**
- **Separación de responsabilidades**: Cada vista maneja su propio estado
- **Reutilización**: Controllers pueden ser compartidos entre vistas relacionadas
- **Mantenibilidad**: Fácil de encontrar y modificar lógica de cada pantalla
- **Testing**: Cada controller se puede testear independientemente

**Excepción**: Vistas muy simples (como diálogos modales) pueden compartir controller con la vista padre.

### ¿Qué es un Controller en GetX?

Un **Controller** es una clase que:
1. ✅ Gestiona el **estado** de la UI
2. ✅ Ejecuta **lógica de presentación** (qué mostrar, cuándo)
3. ✅ Orquesta **Use Cases** (llamadas a lógica de negocio)
4. ✅ Maneja **eventos del usuario** (clicks, inputs, etc.)

### Estructura de un Controller

```dart
import 'package:get/get.dart';
import '../../domain/entities/Producto.dart';
import '../../domain/useCases/obtener_productos.dart';

class HomePageController extends GetxController {
  // 1️⃣ DEPENDENCIAS (Inyectadas por constructor)
  final ObtenerCategorias obtenerCategorias;
  final ObtenerProductos obtenerProductos;

  HomePageController({
    required this.obtenerCategorias,
    required this.obtenerProductos,
  });

  // 2️⃣ ESTADO REACTIVO (.obs = observable)
  var categorias = <Categoria>[].obs;
  var productos = <Producto>[].obs;
  var productosFiltrados = <Producto>[].obs;
  var searchQuery = ''.obs;
  var isLoading = false.obs;

  // 3️⃣ LIFECYCLE: onInit (se ejecuta automáticamente)
  @override
  void onInit() {
    super.onInit();
    cargarCategorias();
    cargarProductos();
  }

  // 4️⃣ MÉTODOS DE NEGOCIO
  Future<void> cargarProductos() async {
    isLoading.value = true;
    final result = await obtenerProductos.call(NoParams());
    result.fold(
      (failure) => print('Error: ${failure.toString()}'),
      (prods) => productos.assignAll(prods),
    );
    isLoading.value = false;
  }

  // 5️⃣ MÉTODOS DE INTERACCIÓN
  void aplicarFiltro() {
    final query = searchQuery.value.toLowerCase();
    if (query.isEmpty) {
      productosFiltrados.assignAll(productos);
    } else {
      productosFiltrados.assignAll(
        productos.where((p) => p.nombre.toLowerCase().contains(query))
      );
    }
  }

  // 6️⃣ LIFECYCLE: onClose (limpieza de recursos)
  @override
  void onClose() {
    // Cerrar streams, cancelar timers, etc.
    super.onClose();
  }
}
```

### 🔄 Ciclo de vida del Controller

```
┌─────────────────┐
│  Constructor    │ ← Inyección de dependencias
└────────┬────────┘
         │
         ↓
┌─────────────────┐
│    onInit()     │ ← Se ejecuta automáticamente al crearse
└────────┬────────┘
         │
         ↓
┌─────────────────┐
│  Controller     │ ← Controller activo, UI lo usa
│    activo       │
└────────┬────────┘
         │
         ↓
┌─────────────────┐
│   onClose()     │ ← Se ejecuta al destruirse
└─────────────────┘
```

### 🎯 Variables Reactivas (.obs)

```dart
// Variable observable
var contador = 0.obs;

// Getter para leer
int get valorContador => contador.value;

// Setter para escribir
void incrementar() {
  contador.value++;  // La UI se actualiza automáticamente
}

// Asignar lista completa
var productos = <Producto>[].obs;
productos.assignAll(nuevosProductos);

// Agregar elemento
productos.add(nuevoProducto);

// Actualizar con update()
contador.update((val) {
  contador.value = val! + 1;
});
```

### 🔍 Uso en la UI con `Obx()`

```dart
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Obtener el controller (ya registrado en GetX)
    final controller = Get.find<HomePageController>();
    
    return Scaffold(
      body: Obx(() => ListView.builder(
        itemCount: controller.productos.length,  // Reactivo
        itemBuilder: (context, index) {
          final producto = controller.productos[index];
          return ProductoCard(producto: producto);
        },
      )),
    );
  }
}
```

**¿Qué hace `Obx()`?**
- Escucha cambios en variables `.obs`
- Reconstruye **solo** el widget envuelto cuando cambian
- Es más eficiente que `setState()`

### 📌 Inicialización de Controllers

Hay **3 formas** de inicializar un controller en GetX:

#### 1. Get.put() - Instancia inmediata
```dart
// En injection.dart
Get.put(CarritoController(), permanent: true);

// En la UI
final controller = Get.find<CarritoController>();
```
**Uso**: Controllers que deben existir toda la vida de la app (Ej: CarritoController)

#### 2. Get.lazyPut() - Instancia perezosa
```dart
// En injection.dart
Get.lazyPut(() => HomePageController());

// En la UI (se crea aquí la primera vez)
final controller = Get.find<HomePageController>();
```
**Uso**: Controllers de pantallas específicas

#### 3. Get.lazyPut() con fenix - Auto-recreación
```dart
// En injection.dart
Get.lazyPut(() => PagoController(), fenix: true);

// Se recrea automáticamente si fue destruido
```
**Uso**: Controllers que pueden ser destruidos pero necesitan recrearse al volver a la pantalla

### 🛠️ Diferencia entre Get.find() y Get.put()

```dart
// Get.put() - CREA una nueva instancia (o retorna si existe)
final controller = Get.put(HomePageController());

// Get.find() - BUSCA una instancia existente (ERROR si no existe)
final controller = Get.find<HomePageController>();
```

**Regla**: Siempre usa `Get.find()` en las pantallas. El `Get.put()` o `Get.lazyPut()` va en `injection.dart`.

---

## 🚀 Ejemplo Práctico: Creación de una Nueva Funcionalidad

Vamos a crear un feature completo: **"Favoritos"**

### Paso 1: Crear la estructura de carpetas

```
lib/features/usuario/favoritos/
├── data/
│   ├── datasources/
│   └── repositories/
├── domain/
│   ├── datasources/
│   ├── entities/
│   ├── repositories/
│   └── useCases/
└── presentation/
    ├── controllers/
    ├── pages/
    └── widgets/
```

### Paso 2: Crear la Entity (Domain)

**Ubicación**: `lib/features/usuario/favoritos/domain/entities/favorito.dart`

```dart
class Favorito {
  final String id;
  final String userId;
  final String productoId;
  final DateTime fechaAgregado;

  Favorito({
    required this.id,
    required this.userId,
    required this.productoId,
    required this.fechaAgregado,
  });

  factory Favorito.fromMap(Map<String, dynamic> map) {
    return Favorito(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      productoId: map['productoId'] ?? '',
      fechaAgregado: (map['fechaAgregado'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'productoId': productoId,
      'fechaAgregado': Timestamp.fromDate(fechaAgregado),
    };
  }
}
```

### Paso 3: Crear DataSource Interface (Domain)

**Ubicación**: `lib/features/usuario/favoritos/domain/datasources/favorito_datasource.dart`

```dart
import '../entities/favorito.dart';

abstract class FavoritoDataSource {
  Future<List<Favorito>> obtenerFavoritos(String userId);
  Future<void> agregarFavorito(Favorito favorito);
  Future<void> eliminarFavorito(String favoritoId);
  Future<bool> esFavorito(String userId, String productoId);
}
```

### Paso 4: Crear Repository Interface (Domain)

**Ubicación**: `lib/features/usuario/favoritos/domain/repositories/favorito_repository.dart`

```dart
import '../entities/favorito.dart';

abstract class FavoritoRepository {
  Future<List<Favorito>> obtenerFavoritos(String userId);
  Future<void> agregarFavorito(Favorito favorito);
  Future<void> eliminarFavorito(String favoritoId);
  Future<bool> esFavorito(String userId, String productoId);
}
```

### Paso 5: Crear DataSource Implementation (Data)

**Ubicación**: `lib/features/usuario/favoritos/data/datasources/favorito_datasource_impl.dart`

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/datasources/favorito_datasource.dart';
import '../../domain/entities/favorito.dart';

class FavoritoDataSourceImpl implements FavoritoDataSource {
  final FirebaseFirestore _firestore;
  final String _collection = 'favoritos';

  FavoritoDataSourceImpl(this._firestore);

  @override
  Future<List<Favorito>> obtenerFavoritos(String userId) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .get();
      
      return snapshot.docs
          .map((doc) => Favorito.fromMap({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      throw Exception('Error al obtener favoritos: $e');
    }
  }

  @override
  Future<void> agregarFavorito(Favorito favorito) async {
    try {
      await _firestore.collection(_collection).add(favorito.toMap());
    } catch (e) {
      throw Exception('Error al agregar favorito: $e');
    }
  }

  @override
  Future<void> eliminarFavorito(String favoritoId) async {
    try {
      await _firestore.collection(_collection).doc(favoritoId).delete();
    } catch (e) {
      throw Exception('Error al eliminar favorito: $e');
    }
  }

  @override
  Future<bool> esFavorito(String userId, String productoId) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .where('productoId', isEqualTo: productoId)
          .limit(1)
          .get();
      
      return snapshot.docs.isNotEmpty;
    } catch (e) {
      throw Exception('Error al verificar favorito: $e');
    }
  }
}
```

### Paso 6: Crear Repository Implementation (Data)

**Ubicación**: `lib/features/usuario/favoritos/data/repositories/favorito_repository_impl.dart`

```dart
import '../../domain/datasources/favorito_datasource.dart';
import '../../domain/entities/favorito.dart';
import '../../domain/repositories/favorito_repository.dart';

class FavoritoRepositoryImpl implements FavoritoRepository {
  final FavoritoDataSource _dataSource;

  FavoritoRepositoryImpl(this._dataSource);

  @override
  Future<List<Favorito>> obtenerFavoritos(String userId) {
    return _dataSource.obtenerFavoritos(userId);
  }

  @override
  Future<void> agregarFavorito(Favorito favorito) {
    return _dataSource.agregarFavorito(favorito);
  }

  @override
  Future<void> eliminarFavorito(String favoritoId) {
    return _dataSource.eliminarFavorito(favoritoId);
  }

  @override
  Future<bool> esFavorito(String userId, String productoId) {
    return _dataSource.esFavorito(userId, productoId);
  }
}
```

### Paso 7: Crear Use Cases (Domain)

**Ubicación**: `lib/features/usuario/favoritos/domain/useCases/obtener_favoritos.dart`

```dart
import 'package:dartz/dartz.dart';
import 'package:mi_mercado/core/error/failure.dart';
import 'package:mi_mercado/core/useCases/use_case.dart';
import '../entities/favorito.dart';
import '../repositories/favorito_repository.dart';

class ObtenerFavoritosUseCase implements UseCase<Either<Failure, List<Favorito>>, String> {
  final FavoritoRepository repository;

  ObtenerFavoritosUseCase(this.repository);

  @override
  Future<Either<Failure, List<Favorito>>> call(String userId) async {
    try {
      final favoritos = await repository.obtenerFavoritos(userId);
      return Right(favoritos);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
```

**Ubicación**: `lib/features/usuario/favoritos/domain/useCases/agregar_favorito.dart`

```dart
import 'package:dartz/dartz.dart';
import 'package:mi_mercado/core/error/failure.dart';
import 'package:mi_mercado/core/useCases/use_case.dart';
import '../entities/favorito.dart';
import '../repositories/favorito_repository.dart';

class AgregarFavoritoUseCase implements UseCase<Either<Failure, void>, Favorito> {
  final FavoritoRepository repository;

  AgregarFavoritoUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(Favorito favorito) async {
    try {
      await repository.agregarFavorito(favorito);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
```

### Paso 8: Crear Controller (Presentation)

**Ubicación**: `lib/features/usuario/favoritos/presentation/controllers/favoritos_controller.dart`

```dart
import 'package:get/get.dart';
import '../../domain/entities/favorito.dart';
import '../../domain/useCases/obtener_favoritos.dart';
import '../../domain/useCases/agregar_favorito.dart';
import '../../domain/useCases/eliminar_favorito.dart';
import '../../domain/useCases/verificar_favorito.dart';

class FavoritosController extends GetxController {
  final ObtenerFavoritosUseCase obtenerFavoritosUseCase;
  final AgregarFavoritoUseCase agregarFavoritoUseCase;
  final EliminarFavoritoUseCase eliminarFavoritoUseCase;
  final VerificarFavoritoUseCase verificarFavoritoUseCase;

  FavoritosController({
    required this.obtenerFavoritosUseCase,
    required this.agregarFavoritoUseCase,
    required this.eliminarFavoritoUseCase,
    required this.verificarFavoritoUseCase,
  });

  // Estado reactivo
  var favoritos = <Favorito>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    cargarFavoritos();
  }

  Future<void> cargarFavoritos() async {
    isLoading.value = true;
    final userId = 'USER_ID_ACTUAL'; // Obtener del AuthController
    
    final result = await obtenerFavoritosUseCase.call(userId);
    result.fold(
      (failure) => print('Error: ${failure.toString()}'),
      (favs) => favoritos.assignAll(favs),
    );
    
    isLoading.value = false;
  }

  Future<void> toggleFavorito(String productoId) async {
    final userId = 'USER_ID_ACTUAL';
    final esFav = await verificarFavoritoUseCase.call({'userId': userId, 'productoId': productoId});
    
    esFav.fold(
      (failure) => print('Error: $failure'),
      (isFavorito) async {
        if (isFavorito) {
          // Eliminar
          final fav = favoritos.firstWhere((f) => f.productoId == productoId);
          await eliminarFavoritoUseCase.call(fav.id);
        } else {
          // Agregar
          final nuevoFav = Favorito(
            id: '',
            userId: userId,
            productoId: productoId,
            fechaAgregado: DateTime.now(),
          );
          await agregarFavoritoUseCase.call(nuevoFav);
        }
        cargarFavoritos(); // Recargar lista
      },
    );
  }
}
```

### Paso 9: Registrar en Inyección de Dependencias

**Ubicación**: `lib/core/di/injection.dart`

```dart
import 'package:mi_mercado/features/usuario/favoritos/data/datasources/favorito_datasource_impl.dart';
import 'package:mi_mercado/features/usuario/favoritos/data/repositories/favorito_repository_impl.dart';
import 'package:mi_mercado/features/usuario/favoritos/domain/repositories/favorito_repository.dart';
import 'package:mi_mercado/features/usuario/favoritos/domain/useCases/obtener_favoritos.dart';
import 'package:mi_mercado/features/usuario/favoritos/domain/useCases/agregar_favorito.dart';
import 'package:mi_mercado/features/usuario/favoritos/domain/useCases/eliminar_favorito.dart';
import 'package:mi_mercado/features/usuario/favoritos/domain/useCases/verificar_favorito.dart';
import 'package:mi_mercado/features/usuario/favoritos/presentation/controllers/favoritos_controller.dart';

void setupDependencies() {
  // ... código existente ...

  // ⭐ FAVORITOS - AGREGAR AL FINAL DE setupDependencies()
  
  // 1. DataSource
  Get.put(FavoritoDataSourceImpl(FirebaseFirestore.instance), permanent: true);
  
  // 2. Repository
  Get.put<FavoritoRepository>(
    FavoritoRepositoryImpl(Get.find<FavoritoDataSourceImpl>()), 
    permanent: true
  );
  
  // 3. Use Cases
  Get.lazyPut(() => ObtenerFavoritosUseCase(Get.find<FavoritoRepository>()));
  Get.lazyPut(() => AgregarFavoritoUseCase(Get.find<FavoritoRepository>()));
  Get.lazyPut(() => EliminarFavoritoUseCase(Get.find<FavoritoRepository>()));
  Get.lazyPut(() => VerificarFavoritoUseCase(Get.find<FavoritoRepository>()));
  
  // 4. Controller
  Get.lazyPut(() => FavoritosController(
    obtenerFavoritosUseCase: Get.find<ObtenerFavoritosUseCase>(),
    agregarFavoritoUseCase: Get.find<AgregarFavoritoUseCase>(),
    eliminarFavoritoUseCase: Get.find<EliminarFavoritoUseCase>(),
    verificarFavoritoUseCase: Get.find<VerificarFavoritoUseCase>(),
  ), fenix: true);
}
```

### Paso 10: Crear la Pantalla (Presentation)

**Ubicación**: `lib/features/usuario/favoritos/presentation/pages/favoritos_screen.dart`

```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/favoritos_controller.dart';

class FavoritosScreen extends StatelessWidget {
  const FavoritosScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FavoritosController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Mis Favoritos')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.favoritos.isEmpty) {
          return const Center(child: Text('No tienes favoritos'));
        }

        return ListView.builder(
          itemCount: controller.favoritos.length,
          itemBuilder: (context, index) {
            final favorito = controller.favoritos[index];
            return ListTile(
              title: Text(favorito.productoId),
              trailing: IconButton(
                icon: const Icon(Icons.favorite, color: Colors.red),
                onPressed: () => controller.toggleFavorito(favorito.productoId),
              ),
            );
          },
        );
      }),
    );
  }
}
```

---

## ✅ Mejores Prácticas

### ⚠️ **Regla Fundamental: Un Controller por Vista**

**Cada pantalla/vista debe tener su propio Controller.** No compartir controllers entre vistas diferentes:

```dart
✅ BIEN - Controllers separados
class HomePage extends StatelessWidget {
  final controller = Get.find<HomePageController>();
  // ...
}

class ProductoDetallePage extends StatelessWidget {
  final controller = Get.find<ProductoDetalleController>();
  // ...
}

❌ MAL - Compartir controller
class HomePage extends StatelessWidget {
  final controller = Get.find<SharedController>(); // ❌
  // ...
}

class ProductoDetallePage extends StatelessWidget {
  final controller = Get.find<SharedController>(); // ❌
  // ...
}
```

**Excepciones**: Solo para vistas muy relacionadas (ej: un modal que pertenece a una pantalla específica).

### 1. Separación de Responsabilidades

```dart
❌ MAL - Controller con lógica de negocio
class ProductoController extends GetxController {
  Future<void> calcularDescuento(Producto producto) {
    // ❌ Lógica de negocio en el controller
    final descuento = producto.precio * 0.15;
    return producto.precio - descuento;
  }
}

✅ BIEN - Use Case con lógica de negocio
// Use Case
class CalcularDescuentoUseCase {
  double call(Producto producto) {
    final descuento = producto.precio * 0.15;
    return producto.precio - descuento;
  }
}

// Controller
class ProductoController extends GetxController {
  final CalcularDescuentoUseCase calcularDescuentoUseCase;
  
  double obtenerPrecioConDescuento(Producto producto) {
    return calcularDescuentoUseCase.call(producto);
  }
}
```

### 2. Manejo de Errores

```dart
✅ Usar Either<Failure, T> en Use Cases
Future<Either<Failure, List<Producto>>> call(NoParams params) async {
  try {
    final productos = await repository.obtenerProductos();
    return Right(productos);
  } catch (e) {
    return Left(ServerFailure(e.toString()));
  }
}

✅ Procesar en Controller
result.fold(
  (failure) {
    Get.snackbar('Error', failure.message);
  },
  (productos) {
    this.productos.assignAll(productos);
  },
);
```

### 3. Naming Conventions

```dart
// Use Cases: Verbos en infinitivo
ObtenerProductos
AgregarAlCarrito
EliminarFavorito

// Entities: Sustantivos en singular
Producto
Usuario
Pedido

// Controllers: Sustantivo + Controller
HomePageController
CarritoController
FavoritosController

// Repositories: Sustantivo + Repository
ProductoRepository
UsuarioRepository

// DataSources: Sustantivo + DataSource
ProductoDataSource
UsuarioDataSource
```

### 4. Evitar Dependencias Circulares

```dart
❌ MAL
// HomePageController depende de CarritoController
class HomePageController {
  final CarritoController carritoController;
}

✅ BIEN
// Ambos usan casos de uso independientes
class HomePageController {
  final AgregarProductoCarritoUseCase agregarProductoUseCase;
}

class CarritoController {
  final ObtenerItemsCarritoUseCase obtenerItemsUseCase;
}
```

### 5. Controllers Ligeros

```dart
❌ MAL - Controller pesado
class ProductoController extends GetxController {
  // ❌ Demasiada lógica en el controller
  Future<void> comprarProducto(Producto producto) {
    // Validar stock
    // Calcular precio
    // Aplicar descuentos
    // Actualizar inventario
    // Crear pedido
    // Enviar email
  }
}

✅ BIEN - Controller delgado
class ProductoController extends GetxController {
  final ComprarProductoUseCase comprarProductoUseCase;
  
  Future<void> comprarProducto(Producto producto) async {
    final result = await comprarProductoUseCase.call(producto);
    result.fold(
      (failure) => mostrarError(failure),
      (success) => mostrarExito(),
    );
  }
}
```

---

## 📚 Resumen Rápido

### Checklist para una nueva funcionalidad:

- [ ] 1. Crear estructura de carpetas (`data`, `domain`, `presentation`)
- [ ] 2. Definir **Entity** en `domain/entities/`
- [ ] 3. Crear **DataSource Interface** en `domain/datasources/`
- [ ] 4. Crear **Repository Interface** en `domain/repositories/`
- [ ] 5. Crear **Use Cases** en `domain/useCases/`
- [ ] 6. Implementar **DataSource** en `data/datasources/`
- [ ] 7. Implementar **Repository** en `data/repositories/`
- [ ] 8. **Crear Controller específico para la vista** en `presentation/controllers/`
- [ ] 9. Registrar en **injection.dart** (orden: DataSource → Repository → Use Cases → Controller)
- [ ] 10. Crear **Pages y Widgets** en `presentation/pages/` y `presentation/widgets/`
- [ ] 11. Usar `Get.find<>()` en la UI

---

## 🎓 Conclusión

Esta arquitectura puede parecer compleja al principio, pero proporciona:

- ✅ **Código limpio y organizado**
- ✅ **Fácil de mantener y escalar**
- ✅ **Testeable en todas las capas**
- ✅ **Independiente de frameworks**
- ✅ **Trabajo en equipo eficiente**

### 📋 Reglas Fundamentales a Recordar:

1. **Cada vista debe tener su propio Controller**
2. **Registrar TODAS las dependencias en `setupDependencies()`**
3. **Usar `Get.find<>()` en la UI, nunca crear controllers manualmente**
4. **Separar lógica de negocio (Use Cases) de lógica de presentación (Controllers)**
5. **La capa Domain nunca debe depender de frameworks externos**

**Regla de oro**: Cada capa solo conoce la capa inmediatamente inferior. La capa de dominio es completamente independiente.

---

## 📞 Contacto y Ayuda

Si tienes dudas sobre la implementación:
1. Revisa esta guía
2. Busca ejemplos similares en el proyecto (ej: `productos`, `direcciones`, `pedidos`)
3. Consulta con el equipo

**Happy Coding! 🚀**
