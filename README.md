# MiMercado 📱

Una aplicación móvil de delivery y compras en línea desarrollada con Flutter que conecta a usuarios con repartidores para la entrega de productos.

## 🚀 Características Principales

### Para Usuarios (Clientes) 👥
- **Navegación de Productos**: Explora productos organizados por categorías
- **Carrito de Compras**: Agrega productos y gestiona tu carrito
- **Sistema de Pagos**: Procesa pagos de manera segura
- **Gestión de Direcciones**: Guarda y administra múltiples direcciones de entrega
- **Historial de Pedidos**: Revisa tus pedidos anteriores y su estado
- **Perfil de Usuario**: Gestiona tu información personal y seguridad

### Para Repartidores 🛵
- **Panel de Control**: Visualiza tu estado actual (Disponible/Ocupado)
- **Pedidos Disponibles**: Ve pedidos disponibles para entrega
- **Pedido Actual**: Gestiona el pedido que estás entregando
- **Historial de Entregas**: Revisa tus entregas completadas
- **Perfil de Repartidor**: Gestiona tu información personal

## 🏗️ Arquitectura

La aplicación sigue una **Arquitectura Hexagonal (Clean Architecture)** con las siguientes capas:

```
lib/
├── core/                    # Núcleo de la aplicación
│   ├── di/                 # Inyección de dependencias (GetX)
│   ├── error/              # Manejo de errores
│   ├── useCases/           # Casos de uso
│   ├── utils/              # Utilidades comunes
│   └── widgets/            # Widgets compartidos
├── features/               # Funcionalidades principales
│   ├── auth/               # Autenticación
│   ├── usuario/            # Módulo de usuario
│   ├── repartidor/         # Módulo de repartidor
│   └── pedidos/            # Gestión de pedidos
├── resources/              # Recursos estáticos
└── main.dart              # Punto de entrada
```

## 🛠️ Tecnologías Utilizadas

- **Flutter**: Framework principal para desarrollo móvil
- **Dart**: Lenguaje de programación
- **Firebase**:
  - Authentication: Autenticación de usuarios
  - Firestore: Base de datos en tiempo real
- **GetX**: Gestión de estado, navegación e inyección de dependencias
- **Google Fonts**: Tipografía consistente
- **Shared Preferences**: Almacenamiento local
- **Cached Network Image**: Carga optimizada de imágenes

## 📋 Requisitos Previos

- Flutter SDK (versión 3.9.0 o superior)
- Dart SDK (incluido con Flutter)
- Android Studio o VS Code
- Cuenta de Firebase configurada

## 🚀 Instalación y Configuración

### 1. Clonar el repositorio
```bash
git clone https://github.com/jaherrera2004/MiMercado-Frontend-Movil.git
cd MiMercado-Frontend-Movil
```

### 2. Instalar dependencias
```bash
flutter pub get
```

### 3. Configurar Firebase
1. Crear un proyecto en [Firebase Console](https://console.firebase.google.com/)
2. Habilitar Authentication y Firestore
3. Descargar `google-services.json` y colocarlo en `android/app/`
4. Configurar las opciones de Firebase en `lib/firebase_options.dart`

### 4. Ejecutar la aplicación
```bash
# Para Android
flutter run

# Para iOS (solo en macOS)
flutter run --platform ios

# Para web
flutter run --platform web
```

## 🎨 Personalización de la App

### Cambiar Nombre de la Aplicación
El nombre de la app se configura en varios lugares:

1. **pubspec.yaml**: Campo `name`
2. **Android**: `android/app/src/main/AndroidManifest.xml` (android:label)
3. **iOS**: `ios/Runner/Info.plist` (CFBundleDisplayName)

### Cambiar Logo/Icono de la Aplicación
1. Coloca tu logo PNG en `assets/images/app_icon.png`
   - **Tamaño recomendado**: 1024x1024 píxeles
   - **Formato**: PNG con fondo transparente
   - **Resolución**: Alta calidad (300 DPI mínimo)

2. Ejecuta los comandos:
```bash
flutter pub run flutter_launcher_icons
```

3. Reconstruye la aplicación:
```bash
# Para Android
flutter clean && flutter build apk

# Para iOS
flutter clean && flutter build ios
```

Los iconos se generarán automáticamente para todas las densidades de pantalla (Android/iOS/Web).

### Flujo de Usuario Cliente

1. **Registro/Inicio de Sesión**
   - Regístrate con email y contraseña
   - Inicia sesión con tus credenciales

2. **Explorar Productos**
   - Navega por categorías de productos
   - Busca productos específicos
   - Agrega productos al carrito

3. **Realizar Pedido**
   - Revisa tu carrito
   - Selecciona dirección de entrega
   - Procesa el pago
   - Confirma el pedido

4. **Seguimiento**
   - Ve el estado de tu pedido
   - Recibe notificaciones de entrega

### Flujo de Repartidor

1. **Inicio de Sesión**
   - Accede con credenciales de repartidor

2. **Estado del Repartidor**
   - Cambia tu estado a "Disponible"
   - Espera asignación de pedidos

3. **Gestión de Pedidos**
   - Acepta pedidos disponibles
   - Ve detalles del pedido actual
   - Actualiza estado de entrega

4. **Historial**
   - Revisa entregas completadas

## 🔧 Scripts Disponibles

```bash
# Ejecutar pruebas
flutter test

# Verificar linting
flutter analyze

# Formatear código
flutter format .

# Construir APK
flutter build apk

# Construir para iOS
flutter build ios
```

## 🎨 Diseño y UI

- **Tema Principal**: Verde (#58E181)
- **Tipografía**: Inter (Google Fonts)
- **Diseño**: Material Design 3
- **Idioma**: Español
- **Responsive**: Adaptable a diferentes tamaños de pantalla

## 🔐 Seguridad

- **Autenticación**: Firebase Authentication
- **Encriptación**: bcrypt para contraseñas
- **Validación**: Formularios con validación en tiempo real
- **Almacenamiento Seguro**: Shared Preferences para datos locales

## 📊 Base de Datos

### Firestore Collections
- `usuarios`: Información de usuarios clientes
- `repartidores`: Información de repartidores
- `productos`: Catálogo de productos
- `pedidos`: Historial de pedidos
- `direcciones`: Direcciones de entrega
- `categorias`: Categorías de productos

## 🤝 Contribución

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 📝 Licencia

Este proyecto está bajo la Licencia MIT - ver el archivo [LICENSE](LICENSE) para más detalles.

## 🙏 Agradecimientos

- Flutter Community
- Firebase Team
- GetX Framework
- Google Fonts

---

**MiMercado** - Conectando compradores y repartidores de manera eficiente y segura. 🛒🚚
