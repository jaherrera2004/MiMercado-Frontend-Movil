# Categoría Module

Este módulo contiene toda la funcionalidad relacionada con la visualización de productos por categorías.

## Estructura

```
categoria/
├── CategoriaScreen.dart        # Pantalla principal de categorías
└── widgets/
    ├── widgets.dart           # Archivo de exportación de widgets
    ├── CategoriaSearchBar.dart # Widget de barra de búsqueda
    ├── ProductCard.dart       # Widget para cada producto individual
    └── ProductGrid.dart       # Widget grid de productos
```

## Widgets Disponibles

### CategoriaSearchBar
Widget para la barra de búsqueda de productos.
- Incluye ícono de búsqueda y placeholder personalizable
- Recibe callbacks para manejar cambios de texto
- Diseño redondeado y consistente

### ProductCard
Widget que representa un producto individual en el grid.
- Muestra imagen, nombre y precio del producto
- Incluye botón de agregar al carrito
- Diseño con sombras y bordes redondeados
- Texto con overflow handling

### ProductGrid
Widget que organiza los productos en una grilla.
- Grid responsivo de 2 columnas
- Maneja automáticamente el scroll
- Recibe callback para acciones de agregar al carrito

## Widgets Globales Utilizados

- **CustomBackButton**: Para el botón de navegación hacia atrás
- **PageTitle**: Para el título de la sección

## Funcionalidades

- **Búsqueda de productos**: Barra de búsqueda interactiva
- **Visualización en grid**: Productos organizados en grilla de 2 columnas
- **Agregar al carrito**: Funcionalidad para agregar productos
- **Navegación**: Botón para volver a la pantalla anterior
- **Carrito**: Botón de acceso rápido al carrito

## Uso

```dart
import 'package:flutter/material.dart';
import 'categoria/CategoriaScreen.dart';

// En tu navegación
Navigator.pushNamed(context, '/categoria');
```

## Datos de Ejemplo

El módulo incluye datos de ejemplo para:
- Lista de productos con nombre, precio e imagen
- Funcionalidad de búsqueda y filtrado
- Integración con el carrito de compras