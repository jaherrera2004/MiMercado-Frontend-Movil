# Módulo Pedidos

Este módulo contiene toda la funcionalidad relacionada con la gestión y visualización de pedidos en la aplicación MiMercado.

## Estructura del Módulo

```
lib/pages/pedidos/
├── PedidosScreen.dart          # Pantalla principal de lista de pedidos
├── PedidoDetalleScreen.dart    # Pantalla de detalle de un pedido específico
├── widgets/
│   ├── PedidoItem.dart         # Widget individual de pedido en la lista
│   ├── PedidosAppBar.dart      # AppBar específico para la pantalla de pedidos
│   ├── PedidosList.dart        # Lista completa de pedidos con estado vacío
│   ├── PedidoInfo.dart         # Widget de información del pedido (número, dirección, estado)
│   ├── PedidoResumen.dart      # Widget de resumen de costos del pedido
│   ├── PedidoProductos.dart    # Widget de lista de productos del pedido
│   └── widgets.dart            # Archivo de exportación de widgets
└── README.md                   # Este archivo
```

## Widgets Principales

### PedidoItem
Componente mejorado que muestra información resumida de un pedido:
- Número de pedido
- Dirección de entrega
- Fecha del pedido
- Estado del pedido (con colores distintivos)
- Total del pedido
- Diseño tipo card moderno

**Uso:**
```dart
PedidoItem(
  numeroPedido: "1",
  direccion: "Carrera 15 #123-45",
  fecha: "2024-03-15",
  estado: "Entregado",
  total: 58000,
  onTap: () => Navigator.pushNamed(context, '/detalle-pedido'),
)
```

### PedidosAppBar
AppBar consistente que utiliza widgets globales:
- CustomBackButton para navegación
- PageTitle para el título
- Diseño limpio y consistente

### PedidosList
Lista de pedidos con manejo de estado vacío:
- Muestra EmptyState cuando no hay pedidos
- Lista scrolleable de PedidoItem
- Callback para manejar tap en pedidos

### PedidoInfo
Widget que muestra la información detallada del pedido:
- Número de pedido
- Dirección de entrega
- Fecha del pedido
- Estado con badge colorido
- Iconos descriptivos

### PedidoResumen
Componente que presenta el desglose de costos:
- Subtotal de productos
- Costo de domicilio
- Tarifa de servicio
- Total destacado

### PedidoProductos
Lista de productos incluidos en el pedido:
- Imagen del producto (con placeholder)
- Nombre y precio
- Cantidad ordenada
- Diseño consistente con tema de la app

## Pantallas

### PedidosScreen
Pantalla principal que muestra la lista de todos los pedidos:
- Utiliza HomeBottomNavigation para navegación inferior
- Datos de ejemplo (en producción vendría de un servicio)
- Navegación a detalle de pedido con argumentos

### PedidoDetalleScreen (DatosPedidosScreen)
Pantalla de detalle de un pedido específico:
- Recibe argumentos del pedido seleccionado
- Muestra información completa del pedido
- Desglose de costos detallado
- Lista de productos incluidos

## Características del Diseño

### Paleta de Colores
- **Verde primario**: `Color(0xFF58E181)` - Para elementos destacados
- **Estados**: Colores diferenciados por estado del pedido
  - Verde: Entregado
  - Naranja: En camino
  - Azul: Pendiente
  - Rojo: Cancelado

### Tipografía
- Utiliza Google Fonts (Inter) para consistencia
- Jerarquía clara de tamaños y pesos

### Componentes Reutilizables
- Cards con elevación sutil
- Bordes redondeados (12px radius)
- Iconos descriptivos
- Badges para estados

## Integración con Widgets Globales

Este módulo utiliza los siguientes widgets globales:
- `CustomBackButton`: Botón de navegación hacia atrás
- `PageTitle`: Títulos consistentes de páginas
- `EmptyState`: Estado vacío cuando no hay pedidos
- `HomeBottomNavigation`: Navegación inferior compartida

## Datos de Ejemplo

Para efectos de demostración, el módulo incluye datos de ejemplo:

```dart
final List<Map<String, dynamic>> pedidosEjemplo = [
  {
    'numero': 1,
    'direccion': 'Carrera 15 #123-45, Chapinero',
    'fecha': '2024-03-15',
    'estado': 'Entregado',
    'total': 45000,
  },
  // ... más pedidos
];
```

En una aplicación real, estos datos vendrían de:
- API REST
- Base de datos local
- Estado global (Provider, Bloc, etc.)

## Navegación

### Rutas utilizadas:
- `/pedidos` → PedidosScreen
- `/detalle-pedido` → PedidoDetalleScreen
- `/home` → HomePage (navegación de regreso)

### Parámetros de navegación:
- `PedidoDetalleScreen` recibe el objeto pedido como argumento
- Manejo de navegación hacia atrás personalizado

## Mejoras Futuras

1. **Integración con API**: Conectar con servicios reales
2. **Estados de carga**: Agregar indicadores de carga
3. **Manejo de errores**: Componentes para errores de red
4. **Filtros**: Filtrar por estado, fecha, etc.
5. **Búsqueda**: Buscar pedidos por número o dirección
6. **Pull to refresh**: Actualizar lista de pedidos
7. **Paginación**: Para listas largas de pedidos

## Dependencias

Este módulo depende de:
- `flutter/material.dart`
- `google_fonts` para tipografía
- Widgets globales compartidos
- HomeBottomNavigation para navegación