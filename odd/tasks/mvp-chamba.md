# Feature: MVP CHAMBA Mobile App

## Objective
Desarrollar el MVP de la aplicación móvil CHAMBA en Flutter + Dart orientado a Android, replicando con alta fidelidad las 12 pantallas y el sistema de diseño de Google Stitch, con arquitectura modular por capas (UI, Domain/Models, Repositories/State), datos mockeados realistas peruanos (Soles S/., distritos como Chiclayo/Lima) y navegación fluida entre los flujos Cliente y Trabajador.

## Scope & Constraints
- Flutter 3.47+ / Dart 3.13+
- Estilo y tokens exactos de Stitch (Manrope + DM Sans, Petroleum Blue `#173B4D`, Brick Terracotta `#B84A1C`, Highland Green `#237553`, Warm Canvas `#F8F6F1`, White `#FFFFFF`)
- 12 Pantallas funcionales e integradas:
  1. Bienvenida e Identidad
  2. Elegir Modo de Uso
  3. Inicio Cliente
  4. Publicar Solicitud
  5. Ofertas Recibidas
  6. Perfil del Trabajador
  7. Chat y Negociación
  8. Mi Servicio y Seguimiento
  9. Crear Perfil de Trabajador
  10. Chambas Disponibles
  11. Enviar Oferta
  12. Mis Trabajos
- State management reactivo y limpio con ChangeNotifier/Provider o ValueNotifier estructurado sin sobreingeniería
- Verificación mediante `flutter analyze` y `flutter test`

## Task Checklist
- [x] Task 1: Scaffold del proyecto Flutter y dependencias (google_fonts, intl)
- [x] Task 2: Sistema de diseño CHAMBA (colores Stitch, tipografía Manrope/DM Sans, temas, componentes atómicos: ChambaButton, ChambaCard, ChambaBadge, PriceDialStepper)
- [x] Task 3: Capa de Dominio y Estado Mock (Modelos: JobRequest, WorkerProfile, Bid, Message; Repositorios Mock reactivos para Cliente y Trabajador)
- [x] Task 4: Flujo Base y Navegación (01 Bienvenida e Identidad, 02 Selector de Modo Cliente/Trabajador con persistencia de rol activo)
- [x] Task 5: Flujo Cliente Parte 1 - Publicación (03 Inicio Cliente con categorías y solicitudes activas, 04 Publicar Solicitud con stepper de presupuesto en S/.)
- [x] Task 6: Flujo Cliente Parte 2 - Negociación y Seguimiento (05 Ofertas Recibidas con contraofertas, 06 Perfil del Trabajador con reseñas y badges, 07 Chat y Negociación interactiva, 08 Mi Servicio y Seguimiento con timeline de estado)
- [x] Task 7: Flujo Trabajador - Oportunidades y Postulación (09 Crear/Ver Perfil de Trabajador con oficios y radio, 10 Chambas Disponibles con filtro por distancia y distrito, 11 Enviar Oferta con dial de contraoferta rápida +/- S/.5 y S/.10, 12 Mis Trabajos con métricas y tabs de estado)
- [x] Task 8: Validación integral de calidad con `flutter analyze` y suite de tests unitarios/widget

## Verification Evidence
- `flutter analyze`: 0 issues found across all modules and screens.
- `flutter test`: 9/9 tests passing (AppState domain tests, Theme & Widget tests, App Smoke test).
- Emulador Android `Medium_Phone` lanzado.
- Fidelidad visual con Google Stitch (proyecto 12752052940306496834):
  - Colores: Petroleum Blue `#173B4D`, Brick Terracotta `#B84A1C`, Highland Green `#237553`, Warm Canvas `#F8F6F1`, Card White `#FFFFFF`.
  - Tipografía: Manrope (titulares y valores numéricos en S/.) + DM Sans (cuerpo y controles).
  - 12 Pantallas implementadas y enlazadas con navegación bidireccional.

## Next Step
- MVP completado y verificado. Listo para demostración interactiva o integración gradual con servicios externos (Firebase / Auth / Mapas).
