# ODD Task: Auditoría y Optimización Responsive de Flutter

## Objetivo
Optimizar la adaptabilidad de toda la aplicación CHAMBA para que funcione de manera impecable y sin desbordamientos (`RenderFlex overflow`) en múltiples resoluciones de dispositivos Android (desde compacto 320×568 hasta grande ancho 430×932), escalas de texto aumentadas (1.3x y 1.5x) y con el teclado virtual abierto.

## Alcance y Restricciones
- Conservar la identidad visual, tipografías, colores de marca y sombras existentes.
- Mantener las rutas, arquitectura y refactorizaciones recientes del Chambeador (`WorkerWalletScreen`, `WorkerPortfolioScreen`, etc.).
- Sin modificaciones al backend NestJS, Prisma o PostgreSQL.
- Prohibido el escalado global de interfaz (`FittedBox` envolviendo pantallas completas). Emplear `Wrap`, `Flexible`, `Expanded`, `LayoutBuilder`, `MediaQuery` y scrolls estructurados.

## Checklist de Tareas
- [x] TASK-1: Optimización responsive del flujo de Autenticación (`welcome_screen`, `login_screen`, `register_screen`, `role_selection_screen`).
  * Evidencia: Links y banderas envueltos con `Wrap`, `LayoutBuilder` con `minHeight` en selección de roles, scroll seguro ante teclado virtual.
- [x] TASK-2: Optimización responsive de pantallas de Cliente (`client_home_screen`, `post_job_screen`, `received_bids_screen`, `client_my_requests_screen`, `job_tracking_screen`).
  * Evidencia: `childAspectRatio` dinámico en cuadrícula de categorías, banner SOS adaptable con Wrap, títulos y badges con Flexible y TextOverflow.ellipsis.
- [x] TASK-3: Optimización responsive de pantallas de Trabajador (`available_jobs_screen`, `send_bid_screen`, `worker_my_jobs_screen`, `worker_wallet_screen`, `worker_profile_screen`, `worker_portfolio_screen`).
  * Evidencia: Gráfico semanal en `WorkerWalletScreen` con LayoutBuilder y scroll horizontal, botones de acción en tarjetas de trabajo con apilamiento vertical adaptativo en anchos menores a 360dp, badges y textos envueltos con Wrap y Flexible.
- [x] TASK-4: Optimización de componentes compartidos y navegación (`role_switcher_pill`, `chamba_button`, `price_dial_stepper`, `chamba_badge`, `client_shell`, `worker_shell`).
  * Evidencia: `ChambaButton` con `minHeight` flexible, tamaño de fuentes de BottomNavigationBar fijado en 11dp, semáforo de precios con LayoutBuilder para pantallas menores a 280dp.
- [x] TASK-5: Batería de pruebas automatizadas responsive en `test/presentation/responsive_layout_test.dart` (320x568, 360x640, 393x852, 412x915, 430x932 con escalado 1.0, 1.3 y 1.5).
  * Evidencia: 12 tests responsive ejecutados y 100% aprobados; suite completa de 37 tests pasando sin errores.
- [x] TASK-6: Verificación visual con Mobile MCP y emulador Android en caliente (capturas y recorrido de flujos).
  * Evidencia: Capturas registradas en WelcomeScreen, RoleSelectionScreen, ClientHomeScreen, AvailableJobsScreen, WorkerMyJobsScreen y WorkerWalletScreen en emulador `Medium_Phone`.
- [x] TASK-7: Compilación de APK Debug y documentación de compatibilidad Android en `HOW_TO_RUN.md`.
  * Evidencia: Binario generado en `build/app/outputs/flutter-apk/app-debug.apk` y Sección 10 agregada en `HOW_TO_RUN.md` con guía de instalación paso a paso en celular físico.

## Verificaciones Requeridas
- `flutter analyze`: 0 issues found (ran in 2.9s).
- `flutter test`: 37 de 37 tests aprobados (100% passing).
- Ausencia total de RenderFlex overflow en todas las resoluciones evaluadas y con escalado 1.5x de texto.
