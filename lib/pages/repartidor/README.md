# 📦 Módulo de Repartidor - MiMercado

## 📋 Descripción General

El módulo de repartidor es una funcionalidad completa dentro de la aplicación MiMercado que permite a los repartidores gestionar sus entregas, consultar pedidos disponibles, revisar su historial y administrar su información personal. Este módulo está diseñado con una arquitectura modular utilizando widgets personalizados para facilitar el mantenimiento y la escalabilidad.

## 🏗️ Arquitectura del Módulo

### Estructura de Archivos

```
lib/pages/repartidor/
├── README.md                     # Documentación del módulo
├── RepartidorPageScreen.dart     # Pantalla principal del repartidor
├── PedidosDisponiblesScreen.dart # Pantalla de pedidos disponibles
├── HistorialPedidosScreen.dart   # Pantalla de historial de pedidos
├── DatosRepartidorScreen.dart    # Pantalla de información personal
└── widgets/                      # Widgets personalizados organizados por pantalla
    ├── repartidorPage/
    │   ├── disponibilidad_selector.dart
    │   ├── estado_indicator.dart
    │   ├── navigation_card.dart
    │   └── pedidos_navigation.dart
    ├── pedidosDisponibles/
    │   ├── confirmar_pedido_dialog.dart
    │   ├── pedido_card.dart
    │   └── pedido_model.dart
    ├── historialPedidos/
    │   ├── historial_card.dart
    │   └── historial_pedido_model.dart
    └── datosRepartidor/
        ├── botones_accion.dart
        ├── calificacion_item.dart
        ├── info_item.dart
        ├── perfil_header.dart
        ├── repartidor_data_model.dart
        └── seccion_informacion.dart
```

## 🖥️ Pantallas Principales

### 1. RepartidorPageScreen
**Archivo:** `RepartidorPageScreen.dart`

**Descripción:** Pantalla principal que actúa como dashboard del repartidor.

**Funcionalidades:**
- ✅ Gestión de estado de disponibilidad (Desconectado/Disponible/Ocupado)
- ✅ Indicador visual de estado actual
- ✅ Navegación a pedidos disponibles e historial
- ✅ Funcionalidad de cerrar sesión
- ✅ Interfaz responsiva y amigable

**Widgets utilizados:**
- `EstadoIndicator`: Muestra el estado actual del repartidor
- `DisponibilidadSelector`: Permite cambiar el estado de disponibilidad
- `PedidosNavigation`: Navegación a otras secciones

### 2. PedidosDisponiblesScreen
**Archivo:** `PedidosDisponiblesScreen.dart`

**Descripción:** Pantalla que muestra los pedidos disponibles para tomar.

**Funcionalidades:**
- ✅ Lista de pedidos disponibles
- ✅ Información detallada de cada pedido
- ✅ Confirmación de pedidos
- ✅ Actualización en tiempo real
- ✅ Pull-to-refresh

**Widgets utilizados:**
- `PedidoCard`: Tarjeta individual de pedido
- `ConfirmarPedidoDialog`: Dialog de confirmación

### 3. HistorialPedidosScreen
**Archivo:** `HistorialPedidosScreen.dart`

**Descripción:** Pantalla que muestra el historial de pedidos del repartidor.

**Funcionalidades:**
- ✅ Historial completo de entregas
- ✅ Estados de pedidos (Completado/Cancelado)
- ✅ Información detallada de cada entrega
- ✅ Búsqueda y filtrado
- ✅ Pull-to-refresh

**Widgets utilizados:**
- `HistorialCard`: Tarjeta de pedido histórico

### 4. DatosRepartidorScreen
**Archivo:** `DatosRepartidorScreen.dart`

**Descripción:** Pantalla de información personal del repartidor (solo lectura).

**Funcionalidades:**
- ✅ Visualización de información personal
- ✅ Datos organizados en secciones
- ✅ Interfaz limpia y profesional
- ✅ Actualización de datos

**Widgets utilizados:**
- `PerfilHeader`: Header con foto y datos básicos
- `SeccionInformacion`: Secciones organizadas de información
- `InfoItem`: Items individuales de información

## 🧩 Componentes (Widgets)

### RepartidorPage Widgets

#### `DisponibilidadSelector`
- **Función:** Selector de tres estados para la disponibilidad del repartidor
- **Estados:** Desconectado, Disponible, Ocupado
- **Características:** Botones con colores distintivos y feedback visual

#### `EstadoIndicator`
- **Función:** Indicador visual del estado actual
- **Características:** Íconos y colores dinámicos según el estado

#### `PedidosNavigation`
- **Función:** Navegación a secciones de pedidos
- **Características:** Cards navegables con íconos y estadísticas

#### `NavigationCard`
- **Función:** Componente reutilizable para navegación
- **Características:** Card personalizable con ícono, título y subtítulo

### PedidosDisponibles Widgets

#### `PedidoModel`
- **Función:** Modelo de datos para pedidos disponibles
- **Propiedades:** ID, cliente, dirección, productos, total, distancia, tiempo estimado

#### `PedidoCard`
- **Función:** Tarjeta de presentación de pedido disponible
- **Características:** Información completa del pedido, botón de acción

#### `ConfirmarPedidoDialog`
- **Función:** Dialog de confirmación para tomar pedidos
- **Características:** Información detallada, confirmación segura

### HistorialPedidos Widgets

#### `HistorialPedidoModel`
- **Función:** Modelo de datos para pedidos históricos
- **Propiedades:** ID, cliente, fecha, estado, productos, total
- **Estados:** Enum con Completado/Cancelado

#### `HistorialCard`
- **Función:** Tarjeta de pedido histórico
- **Características:** Información resumida, indicadores de estado

### DatosRepartidor Widgets

#### `RepartidorDataModel`
- **Función:** Modelo completo de datos del repartidor
- **Propiedades:** Información personal, vehículo, laboral, bancaria

#### `PerfilHeader`
- **Función:** Header de perfil con avatar y datos básicos
- **Características:** Avatar, nombre, estado, información básica

#### `SeccionInformacion`
- **Función:** Contenedor para agrupar información relacionada
- **Características:** Título de sección, lista de items

#### `InfoItem`
- **Función:** Item individual de información
- **Características:** Ícono, etiqueta, valor, color personalizable

#### `CalificacionItem`
- **Función:** Componente para mostrar calificaciones
- **Características:** Estrellas, puntaje numérico

#### `BotonesAccion`
- **Función:** Botones de acción para el perfil
- **Características:** Botones de editar y cambiar foto (actualmente no utilizados)

## 🎨 Diseño y Estilo

### Paleta de Colores
- **Verde principal:** `#58E181` - Color característico de MiMercado
- **Estados:**
  - Desconectado: `Colors.grey`
  - Disponible: `#58E181`
  - Ocupado: `Colors.orange`
- **Errores/Alertas:** `Colors.red`
- **Texto:** Variaciones de `Colors.grey`

### Tipografía
- **Fuente:** Google Fonts - Inter
- **Pesos:** w400 (regular), w600 (semi-bold), w700 (bold)
- **Tamaños:** Desde 12px hasta 20px según contexto

### Componentes UI
- **Bordes redondeados:** BorderRadius entre 8px y 16px
- **Sombras:** BoxShadow sutil para elevación
- **Espaciado:** Múltiplos de 8px para consistencia
- **Íconos:** Material Icons con tamaños consistentes

## 🔄 Gestión de Estado

### Patrón Utilizado
- **StatefulWidget** con `setState()` para estado local
- Estado reactivo en tiempo real
- Manejo de carga con indicadores

### Estados Principales
1. **Estado de Disponibilidad:**
   - Desconectado
   - Disponible  
   - Ocupado

2. **Estados de Carga:**
   - `_isLoading`: Indica carga de datos
   - Estados de error y éxito

3. **Estados de Pedidos:**
   - Disponibles para tomar
   - En proceso
   - Completados
   - Cancelados

## 🚀 Funcionalidades Implementadas

### ✅ Funcionalidades Completadas

1. **Dashboard Principal**
   - Gestión de disponibilidad
   - Navegación intuitiva
   - Cerrar sesión

2. **Gestión de Pedidos**
   - Visualización de pedidos disponibles
   - Confirmación de pedidos
   - Historial completo

3. **Información Personal**
   - Vista de datos personales
   - Información organizada
   - Interfaz de solo lectura

4. **Navegación**
   - Navegación fluida entre pantallas
   - AppBars consistentes
   - Botones de retroceso

5. **UX/UI**
   - Diseño responsivo
   - Feedback visual
   - Pull-to-refresh
   - Animaciones sutiles

## 📱 Navegación del Módulo

```
RepartidorPageScreen (Dashboard)
├── PedidosDisponiblesScreen
│   └── ConfirmarPedidoDialog
├── HistorialPedidosScreen
└── DatosRepartidorScreen
```

### Rutas de Navegación
- Desde Dashboard → Pedidos Disponibles
- Desde Dashboard → Historial de Pedidos  
- Desde Dashboard → Información Personal
- Cerrar Sesión → Pantalla de Login

## 🛠️ Tecnologías y Dependencias

### Dependencias Principales
- **Flutter SDK:** Framework principal
- **Google Fonts:** Tipografía personalizada
- **Material Design:** Componentes UI

### Widgets Flutter Utilizados
- `Scaffold`, `AppBar`, `SingleChildScrollView`
- `Card`, `Container`, `Row`, `Column`
- `ElevatedButton`, `OutlinedButton`, `IconButton`
- `Dialog`, `SnackBar`, `CircularProgressIndicator`
- `RefreshIndicator`, `ListView`

## 🔧 Instalación y Uso

### Prerrequisitos
1. Flutter SDK instalado
2. Proyecto MiMercado configurado
3. Dependencias del proyecto instaladas

### Integración
```dart
// Importar el módulo
import 'package:mi_mercado/pages/repartidor/RepartidorPageScreen.dart';

// Navegar al módulo
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const RepartidorPageScreen(),
  ),
);
```

## 🧪 Testing

### Áreas de Testing Recomendadas
1. **Navegación entre pantallas**
2. **Cambio de estados de disponibilidad**
3. **Confirmación de pedidos**
4. **Carga de datos**
5. **Funcionalidad de refresh**

### Testing Manual
- Verificar responsividad en diferentes dispositivos
- Probar todos los flujos de navegación
- Validar estados de carga y error
- Confirmar funcionalidad de cerrar sesión

## 🐛 Troubleshooting

### Problemas Comunes

1. **Error de navegación**
   - Verificar que las rutas estén correctamente definidas
   - Comprobar imports de archivos

2. **Problemas de estado**
   - Asegurar que `setState()` se llame correctamente
   - Verificar inicialización de variables

3. **Issues de diseño**
   - Revisar constraints de widgets
   - Verificar que los assets estén disponibles

## 📈 Futuras Mejoras

### Funcionalidades Pendientes
- [ ] Notificaciones push para nuevos pedidos
- [ ] Geolocalización en tiempo real
- [ ] Chat con clientes
- [ ] Métricas de rendimiento
- [ ] Modo offline

### Optimizaciones Técnicas
- [ ] Implementar estado global (Bloc/Provider)
- [ ] Caché de datos
- [ ] Optimización de imágenes
- [ ] Testing automatizado
- [ ] CI/CD pipeline

## 👥 Contribución

### Estándares de Código
- Seguir las convenciones de Dart/Flutter
- Mantener la arquitectura modular existente
- Documentar nuevos widgets y funcionalidades
- Usar nombres descriptivos en español para consistencia

### Proceso de Contribución
1. Crear branch desde main
2. Implementar cambios siguiendo la arquitectura
3. Probar funcionalmente
4. Actualizar documentación si es necesario
5. Crear pull request con descripción detallada

---

## 📞 Contacto y Soporte

Para consultas sobre este módulo, contactar al equipo de desarrollo de MiMercado.

**Última actualización:** Septiembre 2025  
**Versión del módulo:** 1.0.0