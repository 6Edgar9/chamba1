# Feature: CHAMBA — Refactorización de la Interfaz del Chambeador (Mis Trabajos, Billetera, Perfil y Portafolio)

## Objective
Reorganizar la experiencia de usuario del Chambeador (trabajador técnico) eliminando la saturación visual, la duplicación masiva de paneles financieros entre pantallas y la sobreextensión de vistas. Se crean pantallas independientes dedicadas para **Mi Billetera** y **Mi Portafolio**, manteniendo exactamente 4 pestañas principales en `WorkerShell`, conservando la identidad del usuario autenticado, los componentes de diseño de CHAMBA (colores, sombras, tipografía, badges, comparador interactivo Antes/Después) e indicando claramente la naturaleza DEMO de los fondos y verificaciones sin servicios externos reales.

## Scope & Constraints
- Frontend: Flutter + Dart en Android (`Medium_Phone`).
- Sin cambios en el backend NestJS ni en PostgreSQL.
- Mantener exactamente 4 pestañas en la barra inferior del Chambeador (`WorkerShell`): Chambas, Mis Trabajos, Mensajes, Mi Perfil.
- No crear una quinta pestaña inferior para la Billetera; Billetera y Portafolio son pantallas secundarias con navegación AppBar y botón Atrás.
- Mantener el comparador interactivo `BeforeAfterSlider` intacto sin romper animaciones o gestos.
- Identificación visible de DEMO en la billetera y en los sellos de validación.
- Conservar los modelos y estado en `AppState`.

## Task Checklist
- [x] Task 1: Auditoría de widgets existentes y diseño de componentes desacoplados (`WorkerEarningsDashboard`, `BeforeAfterSlider`, `TrustShieldBadgesRow`).
- [x] Task 2: Creación de la pantalla independiente `WorkerWalletScreen` con saldos (Disponible y Escrow), tag DEMO, gráfico semanal interactivo, historial demostrativo, nivel Chamba y acciones financieras seguras.
- [x] Task 3: Adaptación de tarjeta financiera compacta (`WorkerEarningsCompactCard`) para acceso rápido a Mi Billetera sin saturar ni truncar títulos.
- [x] Task 4: Reorganización de `WorkerMyJobsScreen` (encabezado compacto, acceso a billetera, tabs visibles de inmediato y estados vacíos optimizados).
- [x] Task 5: Creación de la pantalla independiente `WorkerPortfolioScreen` con lista completa de trabajos y comparador interactivo Antes/Después.
- [x] Task 6: Reorganización de `WorkerProfileScreen` (cabecera con identidad real autenticada, acceso compacto a billetera, preview de 2 trabajos del portafolio con botón para ver todo, y lista ordenada de accesos navegables).
- [x] Task 7: Ajustes en navegación (`WorkerShell`) y manejo coherente del botón volver / pop en Android.
- [x] Task 8: Pruebas estáticas y unitarias (`flutter analyze` y `flutter test`).
- [x] Task 9: Validación visual en vivo con Mobile MCP en emulador `Medium_Phone` (capturas, recorrido completo de pantallas y prueba de cambio de rol).

## Verification Evidence
1. **Auditoría y Desacoplamiento (Task 1):**
   - Se identificó que `WorkerEarningsDashboard` (más de 500 líneas con gráfico de barras, gamificación y saldos) estaba duplicado e insertado tanto en `WorkerMyJobsScreen` como en `WorkerProfileScreen`.
   - Se resolvió el problema del título «Mi Billetera y Rendimientos» truncado integrando `FittedBox` y rediseñando la tarjeta compacta.
2. **Pantalla Independiente: Mi Billetera (Task 2):**
   - Creado `lib/presentation/screens/worker_wallet_screen.dart` con `AppBar` nativo, botón Atrás y badge visible «DEMO».
   - Incluye aviso explícito de entorno demostrativo, tarjetas de saldo Disponible (S/. 480.00) y En Custodia Escrow (S/. 220.00), modal de retiro simulado, gráfico semanal de barras interactivo con tooltip por día, nivel Plata con barra de progreso a Maestro Chamba Oro e historial de movimientos.
3. **Tarjeta Financiera Compacta (Task 3):**
   - `WorkerEarningsDashboard` actualizado con soporte de modo compacto (`compact: true`) que reduce la altura vertical de más de 450px a menos de 80px, sin truncar texto y con enlace directo a la billetera.
4. **Reorganización de Mis Trabajos (Task 4):**
   - `WorkerMyJobsScreen` ahora presenta un encabezado limpio con acceso compacto a la billetera y ubica de inmediato las pestañas «Activas (N)», «Negociando (N)» e «Historial (N)».
   - Estados vacíos contextuales y elegantes para cada pestaña.
5. **Pantalla Independiente: Mi Portafolio (Task 5):**
   - Creado `lib/presentation/screens/worker_portfolio_screen.dart` con lista completa de casos, metadata de tiempo y tarifa, y el comparador interactivo `BeforeAfterSlider`.
   - Incluye botón y modal para simular la adición de nuevas obras con fotos de antes y después.
   - `BeforeAfterSlider` optimizado con `FittedBox(fit: BoxFit.scaleDown)` para prevenir cualquier error de RenderFlex overflow en pantallas de cualquier tamaño.
6. **Reorganización de Mi Perfil del Chambeador (Task 6):**
   - Eliminado el dashboard financiero gigante; sustituido por una tarjeta compacta de acceso a Billetera y Ganancias.
   - Vista previa compacta de portafolio con botón para abrir `WorkerPortfolioScreen`.
   - Lista organizada de opciones: Mi Portafolio, Mi Billetera y Ganancias, Mis Servicios y Especialidades, Verificación de Identidad (con modal de estado demo honesto), Notificaciones, Configuración, Ayuda y Soporte, Elegir Modo de Uso y Cerrar Sesión con diálogo de confirmación.
7. **Navegación Consistente (Task 7):**
   - Se conservaron exactamente las 4 pestañas principales en `WorkerShell`: Chambas, Mis Trabajos, Mensajes, Mi Perfil.
   - `WorkerWalletScreen` y `WorkerPortfolioScreen` funcionan como rutas secundarias con `Navigator.push` y botón volver funcional.
8. **Pruebas Estáticas y Unitarias (Task 8):**
   - `flutter analyze`: 0 issues encontrados (código 100% limpio).
   - `flutter test`: 25/25 pruebas pasando exitosamente (incluyendo 4 nuevas pruebas en `test/presentation/worker_screens_refactor_test.dart`).
9. **Validación Visual en Emulador `Medium_Phone` via Mobile MCP (Task 9):**
   - Recorrido completo verificado con capturas de pantalla reales:
     - `Mis Trabajos`: resumen compacto, pestañas visibles arriba, navegación fluida a `WorkerWalletScreen`.
     - `Mi Billetera`: balances disponible/escrow, etiquetas DEMO, gráfico de barras, nivel Plata y botón volver funcional.
     - `Mi Perfil`: cabecera intacta, acceso compacto a billetera, comparador Antes/Después interactivo, tiles ordenados.
     - `Mi Portafolio`: lista completa de obras y deslizador interactivo probado con gestos de arrastre en vivo.
     - Alternancia de rol: de Trabajador a Cliente («Hola, Ana») y de regreso a Trabajador, conservando la identidad autenticada.

## Next Step
- Tarea finalizada con éxito. Presentar informe detallado de resultados y evidencias al usuario.
