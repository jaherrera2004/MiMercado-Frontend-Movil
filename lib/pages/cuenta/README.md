# Módulo Cuenta

Este módulo contiene toda la funcionalidad relacionada con la gestión de cuenta de usuario en la aplicación MiMercado.

## Estructura del Módulo

```
lib/pages/cuenta/
├── MiCuentaScreen.dart         # Pantalla principal de cuenta de usuario
├── DatosPerfilScreen.dart      # Pantalla de datos personales (modularizada)
├── Perfil.dart                 # Pantalla de perfil completo (legacy)
├── SeguridadScreen.dart       # Pantalla de configuración de seguridad (modularizada)
├── EditarPerfil.dart          # Pantalla para editar perfil
├── EditarContraseñaScreen.dart # Pantalla para cambiar contraseña (modularizada)
├── EditarSeguridad.dart       # Pantalla para editar seguridad (legacy)
├── widgets/
│   ├── CuentaAppBar.dart      # AppBar específico para cuenta
│   ├── PerfilHeader.dart      # Header con imagen y nombre del usuario
│   ├── CuentaOpciones.dart    # Opciones del menú de cuenta
│   ├── DatosAppBar.dart       # AppBar para pantalla de datos
│   ├── DatosLista.dart        # Lista de campos de datos del perfil
│   ├── EditarPerfilAppBar.dart # AppBar para pantalla de editar perfil
│   ├── EditarPerfilForm.dart  # Formulario de edición de perfil
│   ├── EditarPerfilBotones.dart # Botones de acción (guardar/cancelar)
│   ├── SeguridadAppBar.dart   # AppBar para pantalla de seguridad
│   ├── SeguridadInfo.dart     # Información de seguridad actual
│   ├── SeguridadBoton.dart    # Botón para cambiar contraseña
│   ├── EditarContrasenaAppBar.dart # AppBar para cambiar contraseña
│   ├── EditarContrasenaForm.dart # Formulario de cambio de contraseña
│   ├── EditarContrasenaBotones.dart # Botones de acción cambio contraseña
│   ├── opcion.dart            # Widget individual de opción (legacy)
│   ├── camposDatos.dart       # Campos de datos para formularios (legacy)
│   └── widgets.dart           # Archivo de exportación de widgets
└── README.md                  # Este archivo
```

## Widgets Principales

### CuentaAppBar
AppBar limpio y moderno para la pantalla de cuenta:
- Título "Perfil" centrado
- Sin botón de retroceso
- Fondo blanco con texto negro
- Consistente con el diseño de la app

**Uso:**
```dart
appBar: const CuentaAppBar(),
```

### PerfilHeader
Widget que muestra la información básica del usuario:
- Avatar circular del usuario
- Nombre del usuario debajo del avatar
- Espaciado consistente
- Imagen y nombre configurables

**Propiedades:**
- `nombre`: Nombre del usuario (por defecto: "Nombre")
- `imagenPath`: Ruta de la imagen del avatar (por defecto: 'lib/resources/usuarioIMG.png')

**Uso:**
```dart
PerfilHeader(
  nombre: "Juan Pérez",
  imagenPath: 'lib/resources/usuario_custom.png',
)
```

### CuentaOpciones
Contenedor de todas las opciones del menú de cuenta:
- Información personal
- Seguridad
- Cerrar sesión (con diálogo de confirmación)
- Navegación automática a pantallas correspondientes
- Diálogo de confirmación para cerrar sesión

**Características:**
- **Navegación inteligente**: Cada opción navega a su pantalla correspondiente
- **Confirmación de logout**: Diálogo de confirmación antes de cerrar sesión
- **UX mejorada**: Feedback visual y textual claro

**Uso:**
```dart
const CuentaOpciones(),
```

### EditarPerfilAppBar
AppBar limpio para la pantalla de edición de perfil:
- Botón de retroceso usando `CustomBackButton`
- Título "Editar Perfil" centrado
- Diseño consistente con otros módulos
- Sin botones adicionales (acciones en el body)

**Uso:**
```dart
appBar: const EditarPerfilAppBar(),
```

### EditarPerfilForm
Formulario modular para edición de datos del perfil:
- Cuatro campos: Nombre, Apellido, Teléfono, Email
- Controllers configurables para cada campo
- Tipos de teclado apropiados (teléfono, email)
- Color primario customizable
- Espaciado optimizado

**Propiedades:**
- `primaryColor`: Color del tema (por defecto: Color(0xFF58E181))
- `nombreController`: Controller para el campo nombre
- `apellidoController`: Controller para el campo apellido
- `telefonoController`: Controller para el campo teléfono
- `emailController`: Controller para el campo email

**Uso:**
```dart
EditarPerfilForm(
  nombreController: _nombreController,
  apellidoController: _apellidoController,
  telefonoController: _telefonoController,
  emailController: _emailController,
)
```

### EditarPerfilBotones
Widget que contiene los botones de acción para guardar o cancelar:
- Botón "Guardar cambios" verde con loading state
- Botón "Cancelar" rojo
- Estados de loading automáticos
- Callbacks personalizables
- Ancho completo para mejor UX

**Propiedades:**
- `onGuardar`: Callback para el botón guardar
- `onCancelar`: Callback para el botón cancelar
- `isLoading`: Estado de carga (muestra spinner)

**Uso:**
```dart
EditarPerfilBotones(
  onGuardar: _guardarCambios,
  isLoading: _isLoading,
)
```

### SeguridadAppBar
AppBar limpio para la pantalla de configuración de seguridad:
- Botón de retroceso usando `CustomBackButton`
- Título "Seguridad" centrado
- Diseño consistente con otros módulos
- Sin elementos adicionales

**Uso:**
```dart
appBar: const SeguridadAppBar(),
```

### SeguridadInfo
Widget que muestra la información de seguridad actual:
- Campo de contraseña (mostrado como texto genérico)
- Divisor visual
- Espaciado optimizado
- Padding configurable
- Reutiliza el widget `CamposDatos` legacy

**Propiedades:**
- `passwordDisplay`: Texto a mostrar (por defecto: "Contraseña")
- `padding`: Espaciado alrededor del contenido

**Uso:**
```dart
// Uso básico
const SeguridadInfo(),

// Con personalización
SeguridadInfo(
  passwordDisplay: "••••••••",
  padding: EdgeInsets.all(20),
),
```

### SeguridadBoton
Widget configurable para botones de acción de seguridad:
- Botón de ancho completo
- Colores personalizables
- Callback configurable
- Navegación automática por defecto
- Bordes redondeados

**Propiedades:**
- `onPressed`: Callback para el botón
- `texto`: Texto del botón (por defecto: "Cambiar contraseña")
- `backgroundColor`: Color de fondo (por defecto: Verde #58E181)
- `textColor`: Color del texto (por defecto: Blanco)
- `padding`: Espaciado alrededor del botón

**Uso:**
```dart
// Uso básico
const CambiarContrasenaBoton(),

// Con personalización
SeguridadBoton(
  texto: "Configurar seguridad",
  onPressed: () => _configurarSeguridad(),
  backgroundColor: Colors.blue,
),
```

### CambiarContrasenaBoton
Widget predefinido específico para cambiar contraseña:
- Botón verde con texto "Cambiar contraseña"
- Navegación automática a `/editar-seguridad`
- Callback opcional personalizable
- Wrapper simplificado de `SeguridadBoton`

**Uso:**
```dart
const CambiarContrasenaBoton(),
```

### EditarContrasenaAppBar
AppBar especializado para la pantalla de cambio de contraseña:
- Botón de retroceso usando `CustomBackButton`
- Título "Seguridad" centrado (consistente con la sección)
- Diseño limpio sin elementos adicionales
- Implementa `PreferredSizeWidget`

**Uso:**
```dart
appBar: const EditarContrasenaAppBar(),
```

### EditarContrasenaForm
Formulario completo para el cambio de contraseña:
- Tres campos: Contraseña Actual, Nueva Contraseña, Confirmar Nueva Contraseña
- Todos los campos con `obscureText: true` para seguridad
- Controllers configurables para cada campo
- Color primario customizable
- Espaciado optimizado

**Propiedades:**
- `primaryColor`: Color del tema (por defecto: Color(0xFF58E181))
- `contrasenaActualController`: Controller para contraseña actual
- `nuevaContrasenaController`: Controller para nueva contraseña
- `confirmarContrasenaController`: Controller para confirmar contraseña

**Uso:**
```dart
EditarContrasenaForm(
  contrasenaActualController: _contrasenaActualController,
  nuevaContrasenaController: _nuevaContrasenaController,
  confirmarContrasenaController: _confirmarContrasenaController,
)
```

### EditarContrasenaBotones
Widget que contiene los botones de acción para cambiar contraseña:
- Botón "Cambiar contraseña" verde con loading state
- Botón "Cancelar" rojo
- Estados de loading automáticos
- Callbacks personalizables
- Ancho completo para mejor UX

**Propiedades:**
- `onCambiar`: Callback para el botón cambiar
- `onCancelar`: Callback para el botón cancelar
- `isLoading`: Estado de carga (muestra spinner)

**Uso:**
```dart
EditarContrasenaBotones(
  onCambiar: _cambiarContrasena,
  isLoading: _isLoading,
)
```

### DatosAppBar
AppBar especializado para la pantalla de datos de perfil:
- Botón de retroceso usando `CustomBackButton`
- Título "Datos" centrado
- Botón de editar en la parte derecha
- Navegación automática a editar perfil
- Callback personalizable para el botón de editar

**Uso:**
```dart
appBar: const DatosAppBar(),

// Con callback personalizado
appBar: DatosAppBar(
  onEditPressed: () {
    // Acción personalizada
  },
),
```

### DatosLista
Widget que renderiza la lista de campos de datos del perfil:
- Lista configurable de campos
- Divisores automáticos entre campos
- Padding customizable
- Espaciado optimizado
- Reutiliza el widget `CamposDatos` legacy

**Propiedades:**
- `campos`: Lista de nombres de campos (por defecto: ["Nombre", "Apellido", "Telefono", "Email"])
- `padding`: Espaciado alrededor de la lista

**Uso:**
```dart
// Uso básico con campos predeterminados
const DatosPerfilLista(),

// Uso avanzado con campos personalizados
DatosLista(
  campos: ["Nombre", "Email", "Teléfono"],
  padding: EdgeInsets.all(20),
),
```

## Pantallas Principales

### MiCuentaScreen (CuentaScreen)
Pantalla principal que orquesta toda la funcionalidad de cuenta:
- **Navegación**: PopScope para controlar navegación hacia atrás
- **Estructura modular**: Usa todos los widgets modulares
- **Bottom Navigation**: Integración con HomeBottomNavigation
- **Estado actual**: Índice 3 (Cuenta) en la navegación inferior

#### Funcionalidades:
1. **Gestión de navegación**: Control de botón atrás del sistema
2. **Perfil visual**: Muestra información del usuario
3. **Acceso a configuraciones**: Enlaces a datos personales y seguridad
4. **Logout seguro**: Confirmación antes de cerrar sesión
5. **Navegación inferior**: Acceso rápido a otras secciones

### DatosPerfilScreen (DatosScreen)
Pantalla modularizada para mostrar y gestionar datos personales:
- **Estructura simple**: AppBar + Lista de datos
- **Navegación**: Botón atrás y editar integrados
- **Datos dinámicos**: Campos configurables
- **UX optimizada**: Espaciado y divisores automáticos

#### Funcionalidades:
1. **Visualización de datos**: Muestra información personal del usuario
2. **Navegación intuitiva**: Botón atrás y acceso a edición
3. **Estructura modular**: Componentes reutilizables
4. **Responsive**: Adapta espaciado según contenido

### EditarPerfilScreen
Pantalla modularizada para editar información personal del usuario:
- **Estado**: StatefulWidget con controllers para formularios
- **Carga de datos**: Método `_cargarDatosActuales()` para datos existentes
- **Validación**: Estados de loading y error handling
- **UX mejorada**: Feedback con SnackBars y estados visuales
- **Navegación**: Regreso automático tras guardado exitoso

#### Funcionalidades:
1. **Carga inicial**: Obtiene datos actuales del usuario
2. **Edición interactiva**: Formulario con validación en tiempo real
3. **Guardado asíncrono**: Procesamiento con loading states
4. **Feedback visual**: SnackBars de éxito y error
5. **Gestión de memoria**: Dispose automático de controllers

#### Estados de la pantalla:
- **Normal**: Formulario editable con botones habilitados
- **Loading**: Botón guardar con spinner, campos deshabilitados
- **Error**: SnackBar rojo con mensaje de error
- **Éxito**: SnackBar verde + navegación de regreso

### SeguridadScreen (PasswordScreen)
Pantalla modularizada para configuración de seguridad y contraseña:
- **Estructura simple**: AppBar + Info + Botón
- **Navegación directa**: Acceso a edición de contraseña
- **Design limpio**: Layout vertical ordenado
- **Reutilización**: Componentes modulares independientes

#### Funcionalidades:
1. **Visualización**: Muestra información de seguridad actual
2. **Acceso rápido**: Botón directo para cambiar contraseña
3. **Navegación intuitiva**: Botón atrás y acceso a edición
4. **Estructura modular**: Componentes reutilizables

#### Características:
- **Layout vertical**: Column con widgets apilados
- **Widgets const**: Todos los widgets son constantes para performance
- **Navegación**: Integración automática con `/editar-seguridad`
- **Consistencia**: Sigue patrones de diseño del módulo

## Características del Diseño

### Paleta de Colores
- **Fondo**: Blanco puro para claridad
- **Texto principal**: Negro para legibilidad
- **AppBar**: Fondo blanco con texto negro
- **Accent colors**: Verde (`#58E181`) para elementos interactivos

### Componentes de UI
- **Avatar circular**: Imagen de perfil destacada
- **Cards elevados**: Para opciones del menú
- **Espaciado consistente**: 30px entre secciones
- **Tipografía**: Google Fonts (Inter) para consistencia

### Navegación
- **PopScope moderno**: Reemplaza WillPopScope deprecado
- **Bottom Navigation**: Integración con widget reutilizable
- **Navegación automática**: Enlaces directos a pantallas relacionadas

## Opciones del Menú

### 1. Información Personal
- **Destino**: `/datos-perfil`
- **Icono**: `cedula.png`
- **Función**: Gestión de datos personales del usuario

### 2. Seguridad
- **Destino**: `/seguridad`
- **Icono**: `seguridad.png`
- **Función**: Configuración de contraseña y seguridad

### 3. Cerrar Sesión
- **Función**: Logout con confirmación
- **Icono**: `logout.png`
- **UX**: Diálogo de confirmación antes de ejecutar
- **Destino**: Splash screen (`/`)

## Flujo de Usuario

1. **Entrada**: Usuario accede desde bottom navigation
2. **Visualización**: Ve su avatar y nombre
3. **Navegación**: Selecciona opción del menú
4. **Configuración**: Modifica datos o seguridad
5. **Logout**: Confirma cierre de sesión si es necesario

## Integración con Otros Módulos

### Navegación entrante:
- Desde cualquier pantalla via `HomeBottomNavigation`
- Índice 3 en la navegación inferior

### Navegación saliente:
- A `/datos-perfil` - Gestión de información personal
- A `/seguridad` - Configuración de seguridad
- A `/` - Logout (Splash screen)
- A `/home` - Botón atrás del sistema

### Widgets compartidos:
- **HomeBottomNavigation**: Navegación inferior consistente
- **Widgets legacy**: `opcion.dart` y `camposDatos.dart` para compatibilidad

## Manejo de Estados

### Estados de UI:
- **Normal**: Todas las opciones habilitadas
- **Diálogo logout**: Modal de confirmación
- **Navegación**: Transiciones suaves entre pantallas

### Navegación controlada:
- **PopScope**: Controla comportamiento del botón atrás
- **Índice fijo**: Posición 3 en bottom navigation
- **Reemplazo**: Navigator.pushReplacementNamed para home

## Datos de Usuario

### Información mostrada:
```dart
// Datos por defecto
final userData = {
  'nombre': 'Nombre',
  'avatar': 'lib/resources/usuarioIMG.png',
  'opciones': [
    'Información personal',
    'Seguridad',
    'Cerrar sesión',
  ],
};
```

### Personalización:
- Avatar configurable desde assets
- Nombre dinámico (preparado para integración con backend)
- Opciones extensibles

## Mejoras Futuras

1. **Integración con backend**:
   - Cargar datos reales del usuario
   - Sincronización de cambios
   - Manejo de sesiones

2. **Funcionalidades adicionales**:
   - Configuración de notificaciones
   - Tema oscuro/claro
   - Idioma de la aplicación
   - Historial de actividad

3. **UX enhancements**:
   - Animaciones suaves
   - Estados de carga
   - Feedback haptico
   - Refresh pull-to-refresh

4. **Seguridad mejorada**:
   - Biometría para acceso
   - Verificación en dos pasos
   - Log de actividad
   - Dispositivos conectados

5. **Personalización**:
   - Múltiples avatares
   - Temas personalizados
   - Configuración de privacidad
   - Preferencias de usuario

## Archivos Legacy

El módulo mantiene compatibilidad con archivos existentes:
- `Perfil.dart`: Pantalla de perfil original
- `opcion.dart`: Widget de opción individual
- `camposDatos.dart`: Campos de formulario

Estos archivos pueden ser migrados gradualmente al nuevo sistema modular.

## Dependencias

- `flutter/material.dart`
- `google_fonts` para tipografía
- `HomeBottomNavigation` para navegación
- Widgets modulares internos

## Testing

Para testing futuro, considerar:
- Unit tests para lógica de navegación
- Widget tests para componentes individuales
- Integration tests para flujo completo de usuario
- Tests de diálogos y confirmaciones

## Migración desde Legacy

Si estás migrando desde el sistema anterior:

1. **Reemplazar imports**: Cambiar imports individuales por `widgets/widgets.dart`
2. **Actualizar constructor**: Usar nuevos widgets modulares
3. **Verificar navegación**: Asegurar que PopScope funcione correctamente
4. **Probar funcionalidades**: Verificar todas las opciones del menú