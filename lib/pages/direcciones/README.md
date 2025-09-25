# Direcciones Module

Este módulo contiene toda la funcionalidad relacionada con la gestión de direcciones del usuario.

## Estructura

```
direcciones/
├── DireccionesScreen.dart      # Pantalla principal de direcciones
├── README.md                   # Documentación del módulo
└── widgets/
    ├── widgets.dart           # Archivo de exportación de widgets
    ├── DireccionItem.dart     # Widget para cada dirección individual (mejorado)
    ├── DireccionesAppBar.dart # Widget del AppBar con botón agregar
    └── DireccionesList.dart   # Widget lista de direcciones
```

## Widgets Disponibles

### DireccionItem (Mejorado)
Widget que representa una dirección individual en la lista.
- **Cambios realizados**: 
  - Cambio de nombre de clase de `direccion` a `DireccionItem` (siguiendo convenciones)
  - Agregados callbacks opcionales para edit, delete y tap
  - Mejorada la funcionalidad y consistencia del código
- Muestra ícono de ubicación, nombre y dirección
- Botones de editar y eliminar integrados
- Callbacks personalizables para todas las acciones
- Diseño consistente con ListTile

### DireccionesAppBar
Widget personalizado para la barra superior de direcciones.
- Utiliza PageTitle global para consistencia
- Incluye botón de agregar dirección
- Callback personalizable para acción de agregar
- Implementa PreferredSizeWidget para compatibilidad

### DireccionesList
Widget que organiza las direcciones en una lista.
- Utiliza ListView.separated para mejor separación visual
- Maneja automáticamente los divisores entre elementos
- Callbacks para todas las acciones (editar, eliminar, seleccionar)
- Lista de direcciones personalizable

## Widgets Globales Utilizados

- **PageTitle**: Para el título "Direcciones" en el AppBar
- **HomeBottomNavigation**: Reutilizada para navegación inferior (currentIndex: 1)

## Funcionalidades

- **📍 Gestión de direcciones**: Lista completa de direcciones guardadas
- **➕ Agregar dirección**: Botón en AppBar para nueva dirección
- **✏️ Editar dirección**: Botón de edición por cada dirección
- **🗑️ Eliminar dirección**: Botón de eliminación por cada dirección
- **📍 Seleccionar dirección**: Tap en dirección para seleccionar
- **🧭 Navegación**: Integración con navegación inferior
- **📱 Feedback**: SnackBars para confirmación de acciones

## Datos de Ejemplo

El módulo incluye direcciones de ejemplo:
- **Casa**: Calle 123 #45-67, Bogotá
- **Trabajo**: Carrera 7 #32-16, Bogotá  
- **Universidad**: Avenida 68 #40-00, Bogotá

## Navegación

La pantalla de direcciones incluye:
- **WillPopScope**: Navegación de retorno hacia home
- **Navegación inferior**: Acceso a home, pedidos y cuenta
- **Índice actual**: 1 (Direcciones)

## Uso

```dart
import 'package:flutter/material.dart';
import 'direcciones/DireccionesScreen.dart';

// En tu navegación
Navigator.pushNamed(context, '/direcciones');
```

## Acciones Disponibles

### Para cada dirección:
- **Editar**: Modifica los datos de la dirección
- **Eliminar**: Remueve la dirección de la lista
- **Seleccionar**: Elige la dirección como activa

### Acciones globales:
- **Agregar**: Crea una nueva dirección
- **Navegar**: Moverse entre secciones de la app

## Mejoras Implementadas

1. **Modularidad**: Separación clara de responsabilidades
2. **Reutilización**: Uso de widgets globales existentes
3. **Consistencia**: Nombres de clases siguiendo convenciones Dart
4. **Funcionalidad**: Callbacks para todas las acciones principales
5. **UX**: Feedback visual con SnackBars para todas las acciones
6. **Navegación**: Integración completa con el sistema de navegación

## Estructura Modular

- **DireccionItem**: Componente base reutilizable
- **DireccionesList**: Contenedor de direcciones
- **DireccionesAppBar**: Barra superior especializada
- **DireccionesScreen**: Orquestador principal (pendiente de refactorización)

Este módulo establece una base sólida para la gestión de direcciones con componentes modulares y reutilizables.