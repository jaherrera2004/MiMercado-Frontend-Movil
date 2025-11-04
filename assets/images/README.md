# Logo de la Aplicación

Para cambiar el logo de MiMercado, coloca tu imagen PNG en la siguiente ruta:

```
assets/images/app_icon.png
```

## Requisitos del logo:
- **Formato**: PNG con fondo transparente
- **Tamaño recomendado**: 1024x1024 píxeles (cuadrado)
- **Resolución**: Alta calidad (al menos 300 DPI)
- **Fondo**: Transparente o con el color de fondo deseado

## Después de colocar el logo:

1. Ejecuta en la terminal:
```bash
flutter pub get
flutter pub run flutter_launcher_icons
```

2. Para Android, reconstruye la app:
```bash
flutter clean
flutter build apk
```

3. Para iOS, reconstruye la app:
```bash
flutter clean
flutter build ios
```

Los iconos se generarán automáticamente para todas las densidades de pantalla.