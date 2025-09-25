# Carrito Module

Este módulo contiene toda la funcionalidad relacionada con el carrito de compras.

## Estructura

```
carrito/
├── CarritoScreen.dart          # Pantalla principal del carrito
└── widgets/
    ├── widgets.dart           # Archivo de exportación de widgets
    ├── CarritoItem.dart       # Widget para cada producto en el carrito
    ├── CarritoSummary.dart    # Widget para mostrar el subtotal
    └── CarritoBottomActions.dart # Widget para las acciones del pie (continuar pago)
```

## Widgets Disponibles

### CarritoItem
Widget que representa un producto individual en el carrito.
- Muestra imagen, nombre, precio y cantidad del producto
- Incluye botones para eliminar, incrementar y decrementar cantidad
- Recibe callbacks para las acciones

### CarritoSummary
Widget que muestra el resumen del carrito (subtotal).
- Recibe el subtotal calculado como parámetro

### CarritoBottomActions
Widget que contiene las acciones del pie de página.
- Incluye el botón "Continuar pago"
- Utiliza el PrimaryButton global para consistencia

## Widgets Globales Utilizados

- **CustomBackButton**: Para el botón de navegación hacia atrás
- **PageTitle**: Para el título de la pantalla
- **PrimaryButton**: Para el botón de continuar pago

## Uso

```dart
import 'package:flutter/material.dart';
import 'carrito/CarritoScreen.dart';

// En tu navegación
Navigator.pushNamed(context, '/carrito');
```