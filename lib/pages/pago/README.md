# Módulo Pago

Este módulo contiene toda la funcionalidad relacionada con el procesamiento de pagos y finalización de pedidos en la aplicación MiMercado.

## Estructura del Módulo

```
lib/pages/pago/
├── PagoScreen.dart             # Pantalla principal de procesamiento de pago
├── widgets/
│   ├── PagoAppBar.dart         # AppBar específico para la pantalla de pago
│   ├── DireccionEnvio.dart     # Widget para mostrar y seleccionar dirección
│   ├── PagoResumen.dart        # Widget de resumen de costos del pedido
│   ├── MetodosPago.dart        # Widget para selección de método de pago
│   ├── PagoBotonPedido.dart    # Botón para realizar el pedido
│   └── widgets.dart            # Archivo de exportación de widgets
└── README.md                   # Este archivo
```

## Widgets Principales

### PagoAppBar
AppBar consistente que utiliza widgets globales:
- CustomBackButton para navegación hacia atrás
- PageTitle para el título "Pago"
- Diseño limpio y consistente

### DireccionEnvio
Widget que muestra la dirección de entrega seleccionada:
- Diseño atractivo con fondo verde
- Icono de ubicación
- Opción de editar/cambiar dirección
- Callback para navegación a selección de direcciones

**Uso:**
```dart
DireccionEnvio(
  direccion: "Carrera 15 #123-45, Chapinero, Bogotá",
  onTap: () => Navigator.pushNamed(context, '/direcciones'),
)
```

### MetodosPago
Widget interactivo para selección del método de pago:
- Lista de métodos disponibles (Efectivo, Tarjeta, Nequi, Daviplata)
- Selección mediante radio buttons
- Iconos descriptivos para cada método
- Estado visual diferenciado para método seleccionado
- Callback para manejar cambios de selección

**Uso:**
```dart
MetodosPago(
  metodoSeleccionado: _metodoSeleccionado,
  onMetodoChanged: (metodo) {
    setState(() {
      _metodoSeleccionado = metodo;
    });
  },
)
```

### PagoResumen
Componente que presenta el desglose detallado de costos:
- Subtotal de productos
- Costo de domicilio
- Tarifa de servicio
- Total destacado en contenedor negro
- Diseño con fondo semi-transparente verde

**Uso:**
```dart
PagoResumen(
  subtotal: 24000,
  domicilio: 2000,
  servicio: 2000,
  total: 28000,
  showTotal: true,
)
```

### PagoBotonPedido
Botón principal para finalizar el pedido:
- Diseño outlined con borde verde
- Estado de carga con spinner
- Icono de carrito de compras
- Texto personalizable
- Manejo de estados (habilitado/deshabilitado/cargando)

**Uso:**
```dart
PagoBotonPedido(
  isLoading: _isLoading,
  texto: "Realizar pedido",
  onPressed: _realizarPedido,
)
```

## Pantalla Principal

### PagoScreen
Pantalla principal que orquesta todo el flujo de pago:
- **Estado**: StatefulWidget para manejar método seleccionado y loading
- **Scroll**: SingleChildScrollView para contenido extenso
- **Navegación**: Integración con direcciones y pedidos
- **Validación**: Manejo de estados de carga y errores
- **UX**: Feedback visual con SnackBars

#### Funcionalidades:
1. **Selección de dirección**: Navegación a pantalla de direcciones
2. **Métodos de pago**: Selección entre múltiples opciones
3. **Resumen detallado**: Desglose completo de costos
4. **Procesamiento**: Simulación de proceso de pago
5. **Feedback**: Mensajes de éxito y error
6. **Navegación**: Redirección a pedidos tras éxito

## Características del Diseño

### Paleta de Colores
- **Verde primario**: `Color(0xFF58E181)` - Para elementos destacados
- **Fondos**: Semi-transparentes para mejor legibilidad
- **Contraste**: Negro para totales, gris para secundarios
- **Estados**: Verde para éxito, rojo para errores

### Componentes de UI
- **Cards elevados**: Para secciones importantes
- **Bordes redondeados**: 12px radius consistente
- **Espaciado**: 24px entre secciones principales
- **Iconos**: Descriptivos y consistentes con Material Design

### Tipografía
- **Google Fonts (Inter)**: Para consistencia con la app
- **Jerarquía clara**: Títulos bold, contenido regular
- **Tamaños**: 18px títulos, 16px contenido, 14px secundario

## Métodos de Pago Disponibles

1. **Efectivo**
   - Pago contra entrega
   - Icono: `Icons.money`
   - ID: `'efectivo'`

2. **Tarjeta**
   - Visa, Mastercard
   - Icono: `Icons.credit_card`
   - ID: `'tarjeta'`

3. **Nequi**
   - Pago móvil
   - Icono: `Icons.phone_android`
   - ID: `'nequi'`

4. **Daviplata**
   - Billetera digital
   - Icono: `Icons.account_balance_wallet`
   - ID: `'daviplata'`

## Flujo de Usuario

1. **Entrada**: Usuario llega desde carrito
2. **Dirección**: Muestra dirección por defecto, permite cambiar
3. **Método**: Selecciona método de pago preferido
4. **Revisión**: Ve resumen detallado de costos
5. **Confirmación**: Presiona botón "Realizar pedido"
6. **Procesamiento**: Loading state durante simulación
7. **Resultado**: Mensaje de éxito/error
8. **Navegación**: Redirección a pedidos si exitoso

## Integración con Otros Módulos

### Navegación entrante:
- Desde `/carrito` - Usuario procede al pago
- Argumentos: Datos del carrito (productos, totales)

### Navegación saliente:
- A `/direcciones` - Cambiar dirección de entrega
- A `/pedidos` - Tras pago exitoso
- Regreso con `Navigator.pop()` - Cancelar pago

### Datos compartidos:
- **Carrito**: Productos y totales
- **Direcciones**: Dirección seleccionada
- **Usuario**: Información de facturación

## Manejo de Estados

### Estados locales:
- `_metodoSeleccionado`: Método de pago actual
- `_isLoading`: Estado de procesamiento

### Estados de UI:
- **Normal**: Todos los campos habilitados
- **Cargando**: Botón deshabilitado con spinner
- **Error**: SnackBar rojo con mensaje
- **Éxito**: SnackBar verde + navegación

## Datos de Ejemplo

```dart
// Costos de ejemplo
final costos = {
  'subtotal': 24000.0,
  'domicilio': 2000.0,
  'servicio': 2000.0,
  'total': 28000.0,
};

// Dirección de ejemplo
final direccion = "Carrera 15 #123-45, Chapinero, Bogotá";

// Método por defecto
final metodoDefault = 'efectivo';
```

## Mejoras Futuras

1. **Integración real de pagos**:
   - Pasarelas de pago (PayU, Mercado Pago)
   - Validación de tarjetas
   - Procesamiento real

2. **Validaciones mejoradas**:
   - Verificar disponibilidad de productos
   - Validar dirección de entrega
   - Confirmar método de pago

3. **UX enhancements**:
   - Progreso visual del pago
   - Guardado de métodos favoritos
   - Historial de transacciones

4. **Funcionalidades adicionales**:
   - Cupones de descuento
   - Propinas para delivery
   - Múltiples direcciones

5. **Seguridad**:
   - Encriptación de datos sensibles
   - Tokenización de tarjetas
   - Verificación en dos pasos

## Dependencias

- `flutter/material.dart`
- `google_fonts` para tipografía
- Widgets globales compartidos
- Navegación entre módulos

## Testing

Para testing futuro, considerar:
- Unit tests para lógica de cálculos
- Widget tests para componentes individuales
- Integration tests para flujo completo
- Tests de navegación entre pantallas