<p align="center">
  <img src="assets/images/chamba.png" alt="CHAMBA Logo" width="120" style="border-radius: 20px; box-shadow: 0 4px 12px rgba(0,0,0,0.1);" />
</p>

<h1 align="center">CHAMBA Perú 🇵🇪</h1>

<p align="center">
  <strong>Plataforma móvil bajo demanda para servicios técnicos y oficios en el hogar con modelo de negociación en tiempo real (estilo inDrive) y arquitectura Full Stack.</strong>
</p>

<p align="center">
  <a href="https://flutter.dev"><img src="https://img.shields.io/badge/Frontend-Flutter%20%7C%20Dart-02569B?logo=flutter&logoColor=white" alt="Flutter"></a>
  <a href="https://nestjs.com"><img src="https://img.shields.io/badge/Backend-NestJS%2012%20%7C%20TypeScript-E0234E?logo=nestjs&logoColor=white" alt="NestJS"></a>
  <a href="https://www.postgresql.org"><img src="https://img.shields.io/badge/Database-PostgreSQL%20%2B%20Prisma%20ORM-336791?logo=postgresql&logoColor=white" alt="PostgreSQL"></a>
  <img src="https://img.shields.io/badge/Flutter%20Tests-37%20Passed-237553?logo=checkmarx&logoColor=white" alt="Flutter Tests">
  <img src="https://img.shields.io/badge/Backend%20Tests-12%20Passed-237553?logo=vitest&logoColor=white" alt="Backend Tests">
  <img src="https://img.shields.io/badge/License-MIT-B84A1C" alt="License">
</p>

---

## 📌 Tabla de Contenidos

1. [Visión del Producto y Problema que Resuelve](#-visión-del-producto-y-problema-que-resuelve)
2. [El Modelo de Negociación Justa (Estilo inDrive)](#-el-modelo-de-negociación-justa-estilo-indrive)
3. [Estado Real del Desarrollo por Módulos](#-estado-real-del-desarrollo-por-módulos)
4. [Experiencia y Funcionalidades por Rol](#-experiencia-y-funcionalidades-por-rol)
5. [Arquitectura y Estructura del Repositorio](#-arquitectura-y-estructura-del-repositorio)
6. [Tecnologías Utilizadas](#-tecnologías-utilizadas)
7. [Diseño Visual y Optimización Responsive](#-diseño-visual-y-optimización-responsive)
8. [Inicio Rápido](#-inicio-rápido)
9. [Pruebas Automatizadas y Calidad](#-pruebas-automatizadas-y-calidad)
10. [Guías de Colaboración y Ejecución](#-guías-de-colaboración-y-ejecución)
11. [Roadmap y Próximas Fases](#-roadmap-y-próximas-fases)
12. [Licencia](#-licencia)

---

## 🎯 Visión del Producto y Problema que Resuelve

En el mercado peruano (iniciando con validación en Chiclayo y Lambayeque), contratar un servicio técnico para el hogar (gasfitería, electricidad, cerrajería, pintura, albañilería) históricamente ha sufrido de:
- **Precios arbitrarios e inflados** sin un estándar orientativo claro.
- **Desconfianza y temores de seguridad** al dejar entrar a un técnico desconocido a casa.
- **Canales informales y dispersos** (avisos en postes, grupos de Facebook o recomendaciones sin trazabilidad).
- **Márgenes abusivos de intermediación** de empresas tradicionales.

**CHAMBA** democratiza el acceso a servicios de confianza conectando directamente a **Clientes** con **Maestros de Oficio y Especialistas**, mediante un **mecanismo de contraoferta bidireccional transparente**, donde el cliente propone su presupuesto inicial en Soles y los trabajadores postulan con ofertas o contraofertas justificadas.

---

## ⚡ El Modelo de Negociación Justa (Estilo inDrive)

A diferencia de modelos de tarifa rígida o presupuestos ciegos, el ciclo de vida en CHAMBA se estructura de la siguiente manera:

```
[1. Publicación de Necesidad] ──> Cliente describe el trabajo + foto + presupuesto sugerido (S/)
            │
            ▼
[2. Postulación en Tiempo Real] ──> Técnicos cercanos reciben la alerta y envían su propuesta/contraoferta
            │
            ▼
[3. Negociación Abierta] ──> Cliente compara ofertas por distancia, precio y reputación (Acepta o Negocia)
            │
            ▼
[4. Confirmación de Servicio] ──> Orden acordada con protección demostrativa de pago
            │
            ▼
[5. Rastreo del Servicio] ──> Estados visuales: En camino ➔ Llegó al sitio ➔ En progreso ➔ Completado
            │
            ▼
[6. Cierre y Calificación] ──> Conformidad del cliente, liberación de saldo y reseña mutua
```

---

## 📊 Estado Real del Desarrollo por Módulos

Para máxima claridad técnica del equipo docente y colaboradores, se desglosa con exactitud el nivel de implementación:

| Módulo / Capacidad | Estado de Implementación | Nivel de Persistencia / Backend |
| :--- | :--- | :--- |
| **Autenticación (Registro/Login)** | ✅ **Completo y Conectado** | API REST NestJS + PostgreSQL + JWT + Hash bcrypt + Almacenamiento seguro en Flutter (`flutter_secure_storage`). |
| **Sesiones y Roles** | ✅ **Completo y Conectado** | Usuario único con alternancia dinámica entre **Modo Cliente** y **Modo Trabajador**, persistencia de sesión local y token en cabeceras. |
| **Perfil de Usuario / Trabajador** | ✅ **Híbrido** | Lectura/edición base conectada a `/api/v1/users/me` y `/api/v1/worker-profile/me`. Campos avanzados de experiencia gestionados en estado de sesión. |
| **Publicación y Cotizaciones inDrive** | 🔄 **Funcional en Estado Local** | Flujo completo de publicación, semáforo de precios, recepción de cotizaciones y contraofertas gestionado reactivamente en `AppState` (mocks integrados). |
| **Rastreo de Servicios y Chat** | 🔄 **Funcional en Estado Local** | Simulación de estados de servicio y mensajería en vivo en memoria local para pruebas de flujo. |
| **Mi Billetera e Historial Financiero** | 🔄 **Demostrativo / Simulado** | Pantalla independiente con saldos, estados de cuenta, gráfico semanal y movimientos simulados (marcado expresamente como DEMO). **No procesa pagos bancarios reales.** |
| **Mi Portafolio (Antes/Después)** | 🔄 **Demostrativo / Simulado** | Pantalla independiente con slider táctil interactivo de comparativa antes y después. |
| **Verificación RENIEC / Antecedentes PNP** | 📋 **Demostrativo / UI Mock** | Badges y modal informativo de demostración visual. En proceso de integración en futuras fases. |
| **Servicio SOS de Urgencias (< 30 min)** | 📋 **Demostrativo / UI Mock** | Botones de tarifa dinámica SOS y categorización urgente con temporizador visual. |
| **Sincronización Multiusuario WebSockets** | ⏳ **Roadmap (Fase Futura)** | Actualmente cada cliente opera en su entorno local/emulador. |

---

## 👥 Experiencia y Funcionalidades por Rol

La aplicación utiliza dos interfaces modulares independientes coordinadas por `AppState`:

### 👤 Modo Cliente (`ClientShell`)
- **Inicio y Categorías:** Grilla responsiva de servicios con íconos vectoriales y banner de solicitud rápida SOS.
- **Publicación de Solicitudes (`PostJobScreen`):** Selección de especialidad, geolocalización en mapa interactivo OpenStreetMap, diagnóstico orientativo y ajuste de presupuesto con semáforo interactivo de precios (`PriceDialStepper`).
- **Mis Solicitudes (`ClientMyRequestsScreen`):** Seguimiento de órdenes activas, negociación y archivo histórico.
- **Bandeja de Ofertas (`ReceivedBidsScreen`):** Comparación transparente de técnicos postulantes con calificación, distancia y propuesta económica.
- **Rastreo y Chat (`JobTrackingScreen`, `ChatScreen`):** Vista de progreso del técnico y mensajería.
- **Perfil de Usuario (`UserProfileScreen`):** Datos personales, verificación y acceso al cambio de rol.

### 🛠️ Modo Trabajador (`WorkerShell`)
- **Chambas Disponibles (`AvailableJobsScreen`):** Lista filtrable por oficio (Gasfitería, Electricidad, etc.), distancia y etiqueta SOS urgente. Switch de disponibilidad para recibir ofertas.
- **Detalle y Envío de Propuesta (`SendBidScreen`):** Envío de presupuesto formal con opción de contraoferta justificada.
- **Mis Trabajos (`WorkerMyJobsScreen`):** Pestañas inmediatas (**Activas**, **Negociando**, **Historial**) sin elementos duplicados, con listados filtrados y estados vacíos amigables.
- **Mi Perfil (`WorkerProfileScreen`):** Tarjeta de identidad técnica, badges de confianza, botón directo para alternar a Cliente y lista de accesos independientes.
- **Mi Billetera (`WorkerWalletScreen`):** Pantalla secundaria dedicada con desglose de saldo disponible, saldo en custodia (Escrow demo), gráfico de ingresos semanales y niveles de gamificación (Nivel Plata).
- **Mi Portafolio (`WorkerPortfolioScreen`):** Pantalla secundaria dedicada para exhibir trabajos culminados mediante el control interactivo Antes/Después (`BeforeAfterSlider`).

---

## 🏗️ Arquitectura y Estructura del Repositorio

El proyecto mantiene una estricta separación de responsabilidades entre el frontend móvil y el backend de servicios:

```text
CHAMBA/
├── .env.example                    # Plantilla base de variables de entorno (sin secretos)
├── .gitignore                      # Reglas de exclusión seguras para Flutter, Node y PostgreSQL
├── CONTRIBUTING.md                 # Guía para el trabajo colaborativo en equipo con Git
├── HOW_TO_RUN.md                   # Manual detallado de instalación y ejecución en Windows
├── README.md                       # Documento principal de presentación
├── pubspec.yaml                    # Dependencias y configuración de Flutter
│
├── backend/                        # Backend REST API con NestJS y Prisma ORM
│   ├── .env.example                # Plantilla de entorno local para NestJS/PostgreSQL
│   ├── package.json                # Dependencias npm y scripts (build, test, migrate)
│   ├── tsconfig.json               # Configuración TypeScript moderna (ESNext)
│   ├── prisma/
│   │   ├── schema.prisma           # Esquema de datos (User, WorkerProfile, AccountStatus)
│   │   ├── seed.ts                 # Datos de prueba (Ana García, José Torres, Carlos Ramírez)
│   │   └── migrations/             # Migraciones SQL versionadas
│   ├── src/
│   │   ├── main.ts                 # Bootstrap de NestJS, Swagger (/api/docs), CORS y prefijo /api/v1
│   │   ├── app.module.ts           # Módulo raíz de la aplicación
│   │   ├── auth/                   # Autenticación JWT, guards, decoradores y DTOs
│   │   ├── users/                  # Endpoints de consulta y actualización de usuario (/api/v1/users)
│   │   ├── worker-profile/         # Gestión de perfil de especialista (/api/v1/worker-profile)
│   │   └── prisma/                 # Servicio de conexión y ciclo de vida de PrismaClient
│   └── test/                       # Pruebas e2e con Vitest (app.e2e-spec.ts, auth.e2e-spec.ts)
│
├── lib/                            # Código fuente de la aplicación Flutter
│   ├── main.dart                   # Punto de entrada, verificación de sesión e inicialización
│   ├── core/                       # Núcleo de diseño, temas y widgets transversales
│   │   ├── theme/                  # AppColors (paleta institucional), AppTypography y AppTheme
│   │   └── widgets/                # ChambaButton, ChambaCard, ChambaBadge, PriceDialStepper, BeforeAfterSlider
│   ├── data/                       # Capa de datos y persistencia
│   │   ├── models/                 # Modelos serializables: UserAccount, JobRequest, Bid, etc.
│   │   ├── services/               # AuthApiService (cliente HTTP REST) y SessionStorage (Secure Storage)
│   │   └── mock/                   # MockData para desarrollo de flujos offline
│   └── presentation/               # Capa de interfaz de usuario
│       ├── state/                  # AppState (gestor reactivo centralizado con ValueNotifier)
│       ├── screens/                # 21 pantallas optimizadas y adaptables
│       └── widgets/                # Componentes modulares y hojas modales (Notifications, AI Diagnosis)
│
├── odd/                            # Registros de Organic Driven Development (ODD)
│   └── tasks/                      # Tareas de arquitectura, seguridad, refactorización y responsive
│
├── postman/                        # Herramientas de prueba de endpoints REST
│   ├── CHAMBA_API.postman_collection.json
│   └── CHAMBA_Environment.postman_environment.json
│
└── test/                           # Pruebas automatizadas de Flutter
    ├── core/                       # Pruebas de tokens, temas y widgets base
    ├── data/                       # Pruebas de modelos y ciclo de vida de estado
    └── presentation/               # Pruebas de integración, navegación y responsive layout
```

---

## 🛠️ Tecnologías Utilizadas

### Frontend Móvil
- **Framework:** Flutter SDK `^3.13.5` + Dart.
- **Gestión de Estado:** `ValueNotifier` reactivo centralizado en [`AppState`](file:///c:/Users/Julio/Desktop/Proyectos/CHAMBA/lib/presentation/state/app_state.dart).
- **Seguridad en Dispositivo:** `flutter_secure_storage` para almacenamiento protegido de tokens JWT.
- **Consumo HTTP:** `http` con decodificación UTF-8, manejo de timeouts y headers de autorización Bearer.
- **Mapas y Geolocalización:** `flutter_map` (OpenStreetMap libre de costos) + `latlong2` + `geolocator`.
- **Diseño y Tipografía:** `google_fonts` (Manrope para interfaz y DM Sans para datos/cifras) e `intl` (formato Soles S/.).

### Backend y Base de Datos
- **Entorno:** Node.js v24 (LTS) + TypeScript moderno.
- **Framework:** NestJS 12 modular con validación estricta de DTOs (`class-validator`, `class-transformer`).
- **Base de Datos:** PostgreSQL (`chamba_db`).
- **ORM:** Prisma 6.x con migraciones automáticas versionadas y tipado seguro en tiempo de compilación.
- **Criptografía y Sesiones:** `bcrypt` (10 rounds de salt) y `@nestjs/jwt` con firma criptográfica de tokens.
- **Documentación de API:** Swagger / OpenAPI disponible en `/api/docs`.

---

## 🎨 Diseño Visual y Optimización Responsive

CHAMBA utiliza un sistema de diseño institucional inspirado en tonos peruanos:
- **Petroleum Blue (`#173B4D`):** Identidad, cabeceras y botones principales.
- **Brick Terracotta (`#B84A1C`):** Acentos de negociación, contraofertas y llamadas a la acción.
- **Highland Green (`#237553`):** Estados de éxito, acuerdos confirmados y saldos.
- **Warm Canvas (`#F8F6F1`):** Fondo cálido que previene la fatiga visual.

### Adaptabilidad Android
La interfaz ha sido sometida a una auditoría responsive para garantizar que **no existan desbordamientos (`RenderFlex overflow`)** en ningún dispositivo Android:
- **Resoluciones comprobadas:** Compacto (320 × 568 dp), Pequeño (360 × 640 dp), Mediano (393 × 852 dp), Grande (412 × 915 dp) y Grande Ancho (430 × 932 dp).
- **Accesibilidad:** Soporta aumentos de tamaño de fuente del sistema (1.3x y 1.5x) mediante contenedores con `Wrap` y `Flexible`.
- **Comportamiento con Teclado:** Pantallas de formulario con `SingleChildScrollView` y respeto de `viewInsets.bottom`.

---

## 🚀 Inicio Rápido

### 1. Iniciar el Backend
```bash
cd backend
npm install
# Asegúrate de configurar backend/.env a partir de .env.example
npx prisma migrate deploy
npx prisma db seed
npm run start:dev
```
- API REST: `http://localhost:3000/api/v1`
- Swagger Docs: `http://localhost:3000/api/docs`

### 2. Iniciar el Frontend Flutter
```bash
# En la raíz del proyecto
flutter pub get
flutter run
```

---

## 🧪 Pruebas Automatizadas y Calidad

El proyecto cuenta con suites de pruebas verificadas en verde:

```bash
# 1. Pruebas del Frontend Flutter (37 tests)
flutter test

# 2. Análisis estático del código Dart (0 errores)
flutter analyze

# 3. Pruebas de integración E2E del Backend (11 tests)
cd backend
npm run test:e2e

# 4. Pruebas unitarias del Backend (1 test)
npm run test
```

---

## 📚 Guías de Colaboración y Ejecución

Para profundizar en el trabajo con el repositorio, consulta la documentación dedicada:

- 📖 **[HOW_TO_RUN.md](HOW_TO_RUN.md):** Manual completo paso a paso para clonar, configurar PostgreSQL en Windows, correr migraciones, vincular el emulador Android (`10.0.2.2:3000`) y compilar la APK debug.
- 🤝 **[CONTRIBUTING.md](CONTRIBUTING.md):** Estándares de trabajo colaborativo para el equipo (ramas, Conventional Commits, Pull Requests, sincronización de Prisma sin perder datos y resolución de conflictos).

---

## 🗺️ Roadmap y Próximas Fases

- [x] **Fase 1:** Arquitectura Flutter, 21 pantallas, estado reactivo `AppState`, backend NestJS, base de datos PostgreSQL, migraciones Prisma, autenticación JWT y optimización responsive.
- [ ] **Fase 2:** Conexión completa de los endpoints de solicitudes de chambas, cotizaciones y negociación al backend NestJS.
- [ ] **Fase 3:** WebSockets con Socket.io en NestJS para actualización bidireccional inmediata de cotizaciones y chat.
- [ ] **Fase 4:** Integración de pasarela de pagos digitales (Yape / Plin) con custodia en garantía (Escrow) real.
- [ ] **Fase 5:** Validación automatizada de identidad peruana (DNI RENIEC y antecedentes PNP).
- [ ] **Fase 6:** Notificaciones Push nativas vía Firebase Cloud Messaging (FCM).

---

## 📄 Licencia

Este proyecto se distribuye bajo la licencia **MIT**. Consulta el archivo `LICENSE` para más detalles.
