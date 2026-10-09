# Feature: Pruebas Funcionales y Visuales de CHAMBA con Mobile MCP y Stitch

## Objective
Realizar pruebas interactivas de extremo a extremo en el emulador Android `Medium_Phone` utilizando Mobile MCP, comparando contra el diseño oficial de Google Stitch (proyecto 12752052940306496834), verificando las 12 pantallas, integrando navegación inferior completa (Bottom Navigation) para Cliente y Trabajador, y corrigiendo cualquier error de interacción o visual.

## Test Matrix & Scope
- [x] Test 1: Navegación Inferior (Bottom Navigation Bar) en Flujo Cliente (`Inicio`, `Solicitudes`, `Mensajes`, `Perfil`) y Trabajador (`Chambas`, `Mis Trabajos`, `Mensajes`, `Mi Perfil`).
- [x] Test 2: Flujo Onboarding y Selección de Rol (Pantalla 01 Bienvenida e Identidad, Pantalla 02 Modo de Uso: conmutación entre Cliente y Especialista).
- [x] Test 3: Flujo Cliente - Publicación Interactiva (Pantalla 03 Inicio -> Pantalla 04 Formulario de Publicación con dial numérico de presupuesto S/. y publicación reactiva en memoria).
- [x] Test 4: Flujo Cliente - Negociación y Seguimiento (Pantalla 05 Ofertas Recibidas -> Pantalla 06 Perfil Técnico con métricas -> Modal de Contraoferta en S/. -> Pantalla 08 Seguimiento con PIN 5821 -> Pantalla 07 Chat interactivo con envío de mensajes vía Mobile MCP).
- [x] Test 5: Flujo Trabajador - Postulación y Gestión (Pantalla 10 Chambas Disponibles con switch de disponibilidad -> Pantalla 11 Enviar Cotización y Contraoferta -> Pantalla 12 Mis Trabajos con métricas e ingresos -> Pantalla 09 Perfil de Especialista y guardado).
- [x] Test 6: Verificación de Calidad y Cierre (`flutter analyze` limpio con 0 issues, `flutter test` con 9/9 pruebas pasando, capturas validadas con Stitch).

## Bugs Corregidos Durante las Pruebas
1. **Desbordamiento de texto en WelcomeScreen (Pantalla 01)**: Se implementó `SingleChildScrollView` para garantizar visualización perfecta en cualquier altura de pantalla móvil sin overflow.
2. **Desbordamiento horizontal en botón "Contraofertar" (Pantalla 05)**: En layouts con columnas divididas `Row` (como botones `Aceptar` y `Contraofertar`), se ajustó `ChambaButton` para permitir flexibilidad de texto y padding adaptable de 12px, eliminando un desbordamiento de 33px.
3. **Navegación Inferior ausente**: Se agregó e integró `BottomNavigationBar` de 4 pestañas tanto en la vista del Cliente (`ClientHomeScreen`) como del Trabajador (`AvailableJobsScreen`), con redirección a solicitudes activas, chat, historial de trabajos y conmutador de perfil.
4. **Compatibilidad Gradle y NDK**: Se fijó `ndkVersion = "28.2.13676358"` en `android/app/build.gradle.kts` para garantizar compilaciones inmediatas de menos de 10 segundos en Android 16 API 36.

## Verification Evidence
- **Device**: Android Emulator `Medium_Phone` (Android 16 API 36, 1080x2400).
- **Package**: `pe.chamba.chamba`.
- **Flutter Analyzer**: 0 issues encontrados (`No issues found!`).
- **Flutter Unit & Widget Tests**: 9/9 pasando (`All tests passed!`).
- **Mobile MCP Actions Realizadas**:
  - `mobile_launch_app` para arrancar la app.
  - `mobile_click_on_screen_at_coordinates` para pulsar botones, seleccionar roles, aceptar ofertas, cambiar tabs y conmutar vistas.
  - `mobile_swipe_on_screen` para desplazarse verticalmente y revisar contenido inferior.
  - `mobile_type_keys` para escribir mensajes interactivos en el chat.
  - `mobile_take_screenshot` para auditar visualmente cada una de las 12 pantallas y validar coincidencia estética con tokens de Stitch (Petroleum Blue `#173B4D`, Brick Terracotta `#B84A1C`, Highland Green `#237553`, Warm Canvas `#F8F6F1`).
