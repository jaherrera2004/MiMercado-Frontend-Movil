# Widgets Globales - MiMercado

Esta carpeta contiene widgets reutilizables que pueden ser utilizados en toda la aplicación.

## 📁 Estructura

```
lib/shared/widgets/
├── buttons/
│   └── PrimaryButton.dart       # Botón principal con estados de carga
├── forms/
│   └── CustomTextField.dart     # Campo de texto personalizado con validaciones
├── navigation/
│   ├── BackButton.dart          # Botón de retroceso personalizado
│   └── NavigationLink.dart      # Enlaces de navegación entre pantallas
├── text/
│   └── PageTitle.dart           # Títulos de página consistentes
├── common/
│   ├── LoadingWidget.dart       # Indicador de carga personalizado
│   ├── ErrorMessage.dart        # Widget para mostrar mensajes de error
│   └── EmptyState.dart          # Widget para estados vacíos
└── widgets.dart                 # Archivo barrel para facilitar imports
```

## 🚀 Uso

### Importación Simple
```dart
import 'package:mi_mercado/shared/shared.dart';
// Esto importa todos los widgets globales
```

### Importación Específica
```dart
import 'package:mi_mercado/pages/shared/widgets/widgets.dart';
// Solo los widgets
```

## 🎯 Widgets Disponibles

### **PrimaryButton**
Botón principal reutilizable con estados de carga.
```dart
PrimaryButton(
  text: "Iniciar sesión",
  onPressed: () => handleLogin(),
  backgroundColor: Colors.blue,
  isLoading: isLoading,
)
```

### **CustomTextField**
Campo de texto personalizado con validaciones.
```dart
CustomTextField(
  label: "Email",
  hint: "Ingresa tu email",
  primaryColor: Colors.blue,
  controller: emailController,
  validator: (value) => Validators.email(value),
)
```

### **CustomBackButton**
Botón de retroceso personalizable.
```dart
CustomBackButton(
  iconPath: 'lib/resources/go_back_icon.png',
  onPressed: () => Navigator.pop(context),
)
```

### **PageTitle**
Títulos de página con estilos consistentes.
```dart
PageTitle(
  title: "Inicio de Sesión",
  fontSize: 24,
  textAlign: TextAlign.center,
)
```

### **NavigationLink**
Enlaces para navegación entre pantallas.
```dart
NavigationLink(
  text: "¿No tienes cuenta? ",
  linkText: "Regístrate aquí",
  linkColor: Colors.blue,
  onTap: () => Navigator.pushNamed(context, '/register'),
)
```

### **LoadingWidget**
Indicador de carga con mensaje opcional.
```dart
LoadingWidget(
  message: "Cargando datos...",
  color: Colors.blue,
)
```

### **ErrorMessage**
Widget para mostrar errores con opción de reintento.
```dart
ErrorMessage(
  message: "Error al cargar los datos",
  onRetry: () => loadData(),
)
```

### **EmptyState**
Widget para mostrar estados vacíos.
```dart
EmptyState(
  title: "No hay productos",
  subtitle: "Agrega productos para comenzar",
  icon: Icons.shopping_cart_outlined,
  action: PrimaryButton(
    text: "Agregar Producto",
    onPressed: () => addProduct(),
    backgroundColor: Colors.blue,
  ),
)
```

## 🎨 Personalización

Todos los widgets están diseñados para ser altamente personalizables:
- Colores dinámicos basados en el tema
- Tamaños ajustables
- Estilos de texto personalizables
- Estados reactivos

## 📋 Beneficios

1. **Consistencia**: Estilos uniformes en toda la app
2. **Reutilización**: Reduce duplicación de código
3. **Mantenimiento**: Cambios centralizados
4. **Escalabilidad**: Fácil agregar nuevos widgets
5. **Testing**: Componentes aislados y testeable

## 🔄 Migración

Los widgets originales de `features/auth/widgets/` han sido migrados:
- `AuthButton` → `PrimaryButton`
- `AuthBackButton` → `CustomBackButton`
- `AuthPageTitle` → `PageTitle`
- `AuthNavigationLink` → `NavigationLink`

## 🎯 Próximos Pasos

- [ ] Agregar más variantes de botones
- [ ] Crear widgets para cards y listas
- [ ] Implement ar widgets de formulario más complejos
- [ ] Agregar widgets para modales y diálogos
- [ ] Crear widgets específicos para e-commerce