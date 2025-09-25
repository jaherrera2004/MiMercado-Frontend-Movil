# HomePage Module

Este módulo contiene toda la funcionalidad relacionada con la pantalla principal (home) de la aplicación.

## Estructura

```
homepage/
├── HomePage.dart              # Pantalla principal refactorizada
├── README.md                  # Documentación del módulo
└── widgets/
    ├── widgets.dart           # Archivo de exportación de widgets
    ├── HomeAppBar.dart        # Widget del AppBar principal
    ├── CategoryItem.dart      # Widget para cada categoría individual
    ├── CategoriesCarousel.dart # Widget carrusel de categorías
    └── HomeBottomNavigation.dart # Widget de navegación inferior
```

## Widgets Disponibles

### HomeAppBar
Widget personalizado para la barra superior de la pantalla principal.
- Muestra ícono de dirección con texto "Dirección"
- Incluye botón de carrito de compras
- Implementa PreferredSizeWidget para compatibilidad con Scaffold
- Callback personalizable para acción del carrito

### CategoryItem
Widget que representa una categoría individual en el carrusel.
- Muestra imagen circular de la categoría
- Texto con el nombre de la categoría
- Gestión de tap personalizable
- Espaciado consistente

### CategoriesCarousel
Widget que organiza las categorías en un carrusel horizontal.
- Scroll horizontal automático
- Utiliza CategoryItem para cada elemento
- Callback para manejar tap en categorías
- Lista de categorías personalizable

### HomeBottomNavigation
Widget de navegación inferior para toda la aplicación.
- 4 pestañas: Inicio, Direcciones, Pedidos, Cuenta
- Navegación automática entre pantallas
- Índice actual personalizable
- Callbacks opcionales para cada pestaña

## Widgets Reutilizados

- **CategoriaSearchBar**: Barra de búsqueda reutilizada del módulo de categoría
- **ProductGrid**: Grid de productos reutilizado del módulo de categoría
- **PageTitle**: Widget global para títulos de sección

## Widgets Globales Utilizados

- **PageTitle**: Para el título "Nuestros Productos"

## Funcionalidades

- **🏠 Pantalla principal**: Vista completa del home con navegación
- **🔍 Búsqueda de productos**: Barra de búsqueda interactiva
- **📂 Navegación por categorías**: Carrusel horizontal de categorías
- **🛍️ Visualización de productos**: Grid de productos destacados
- **🛒 Agregar al carrito**: Funcionalidad para agregar productos
- **🧭 Navegación inferior**: Acceso rápido a todas las secciones

## Navegación

La HomePage incluye navegación hacia:
- **Carrito**: Desde el AppBar y productos
- **Categorías**: Desde el carrusel de categorías
- **Direcciones**: Desde la barra de navegación inferior
- **Pedidos**: Desde la barra de navegación inferior
- **Cuenta**: Desde la barra de navegación inferior

## Uso

```dart
import 'package:flutter/material.dart';
import 'homepage/HomePage.dart';

// En tu navegación
Navigator.pushNamed(context, '/home');
```

## Datos de Ejemplo

El módulo incluye datos de ejemplo para:
- Lista de categorías con iconos y nombres
- Lista de productos destacados
- Configuración de navegación por defecto

## Características de Reutilización

- **Modularidad**: Cada widget puede ser usado independientemente
- **Consistencia**: Uso de widgets globales y reutilizados
- **Escalabilidad**: Fácil adición de nuevas categorías y productos
- **Mantenibilidad**: Código organizado y bien documentado