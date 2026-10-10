<p align="center">
  <img src="assets/images/chamba.png" alt="CHAMBA Logo" width="120" style="border-radius: 20px; box-shadow: 0 4px 12px rgba(0,0,0,0.1);" />
</p>

<h1 align="center">CHAMBA Perú 🇵🇪</h1>

<p align="center">
  <strong>Plataforma móvil bajo demanda para servicios técnicos y oficios con modelo de negociación en tiempo real (estilo inDrive).</strong>
</p>

<p align="center">
  <a href="#-visión-del-producto"><img src="https://img.shields.io/badge/Platform-Flutter%20%7C%20Dart-02569B?logo=flutter&logoColor=white" alt="Flutter"></a>
  <a href="#-arquitectura--tecnologías"><img src="https://img.shields.io/badge/Architecture-Clean%20%2F%20Layered-173B4D" alt="Clean Architecture"></a>
  <a href="#-pruebas-y-calidad"><img src="https://img.shields.io/badge/Tests-14%20Passed-237553?logo=checkmarx&logoColor=white" alt="Tests"></a>
  <a href="#-licencia"><img src="https://img.shields.io/badge/License-MIT-B84A1C" alt="License"></a>
</p>

---

## 📌 Tabla de Contenidos

1. [Visión del Producto](#-visión-del-producto)
2. [El Modelo inDrive para Servicios](#-el-modelo-indrive-para-servicios)
3. [Características Principales](#-características-principales)
4. [Flujos de Usuario y Roles](#-flujos-de-usuario-y-roles)
5. [Arquitectura y Estructura](#-arquitectura-y-estructura)
6. [Sistema de Diseño (Tokens & UI)](#-sistema-de-diseño-tokens--ui)
7. [Tecnologías y Dependencias](#-tecnologías-y-dependencias)
8. [Instalación y Configuración](#-instalación-y-configuración)
9. [Pruebas y Calidad](#-pruebas-y-calidad)
10. [Roadmap](#-roadmap)

---

## 🎯 Visión del Producto

En el mercado peruano, contratar servicios técnicos (gasfitería, electricidad, cerrajería, pintura, albañilería) históricamente ha sufrido de **falta de transparencia en precios**, **desconfianza en la seguridad** e **ineficiencia en la comunicación**.

**CHAMBA** democratiza el acceso a servicios técnicos de calidad conectando a **Clientes** con **Especialistas y Maestros de Oficio**, utilizando un **mecanismo de contraoferta y negociación directa**, garantizando precios justos y acuerdos transparentes sin comisiones abusivas intermedias.

---

## ⚡ El Modelo inDrive para Servicios

A diferencia de las plataformas tradicionales de precios fijos o presupuestos ciegos, CHAMBA implementa un ciclo de vida transparente:

```
[1. Cliente publica necesidad + precio sugerido]
                      │
                      ▼
[2. Maestros cercanos envían ofertas / contraofertas]
                      │
                      ▼
[3. Negociación bidireccional (Aceptar / Contraofertar / Rechazar)]
                      │
                      ▼
[4. Confirmación de orden + Depósito en garantía (Escrow)]
                      │
                      ▼
[5. Seguimiento en vivo (En camino ➔ En progreso ➔ Finalizado)]
                      │
                      ▼
[6. Liberación de pago y Calificación bilateral]
```

---

## ✨ Características Principales

### 👤 Experiencia para Clientes
- **Publicación Intuitiva de Solicitudes:** Especificación de categoría, dirección en mapa, fecha/hora y presupuesto base estimado (S/).
- **Bandeja de Ofertas en Tiempo Real:** Visualización y comparación de ofertas de trabajadores con reputación, distancia y tarifa.
- **Contraoferta Rápida:** Botones de ajuste dinámico (+S/ 10, +S/ 20, etc.) o ingreso de monto personalizado.
- **Mapa en Vivo:** Geolocalización mediante OpenStreetMap (`flutter_map`) con cálculo de distancias.
- **Rastreo Paso a Paso:** Indicador de avance con estados en tiempo real (Acordado, En camino, En el sitio, Completado).
- **Chat Integrado:** Comunicación directa y segura dentro de la aplicación.

### 🛠️ Experiencia para Trabajadores y Maestros
- **Exploración de Trabajos Disponibles:** Filtros por especialidad, radio de cercanía y monto ofertado.
- **Envío Ágil de Propuestas:** Postulación con precio original o contraoferta justificada.
- **Gestión Integral de Agenda:** Pestaña "Mis Trabajos" para gestionar órdenes activas e historial completado.
- **Perfil Profesional y Reputación:** Portafolio de proyectos, sellos de verificación de identidad, certificados y reseñas de clientes.

---

## 👥 Flujos de Usuario y Roles

La aplicación implementa una arquitectura modular con dos interfaces principales (`ClientShell` y `WorkerShell`):

| Rol | Vistas Clave | Capacidades |
| :--- | :--- | :--- |
| **Cliente** | Inicio, Mis Solicitudes, Mensajes, Perfil | Publicar necesidades, evaluar presupuestos, negociar, rastrear servicio y calificar. |
| **Trabajador** | Trabajos Disponibles, Mis Trabajos, Mensajes, Perfil | Encontrar oportunidades, contraofertar, actualizar estado de llegada y cobrar. |

---

## 🏗️ Arquitectura y Estructura

El proyecto sigue los principios de **Clean Architecture** y separación por capas para maximizar escalabilidad y testeabilidad:

```text
lib/
├── core/
│   ├── theme/
│   │   ├── app_colors.dart         # Tokens de color institucionales
│   │   ├── app_typography.dart     # Escalas tipográficas con Google Fonts
│   │   └── app_theme.dart          # ThemeData unificado
│   └── widgets/
│       └── chamba_button.dart      # Componentes UI reutilizables
├── data/
│   ├── mock/
│   │   └── mock_data.dart          # Semillas de datos para desarrollo offline
│   └── models/
│       ├── job_model.dart          # Entidades: JobRequest, Bid, JobStatus
│       └── user_model.dart         # Entidades: UserProfile, WorkerProfile
├── presentation/
│   ├── screens/                    # 21 pantallas optimizadas
│   ├── state/
│   │   └── app_state.dart          # Gestión reactiva de estado (ValueNotifier)
│   └── widgets/                    # Componentes modulares de pantalla
└── main.dart                       # Punto de entrada y configuración global
```

---

## 🎨 Sistema de Diseño (Tokens & UI)

Diseñado con una identidad visual robusta y cálida orientada a generar confianza:

| Color | Hex | Rol en la UI |
| :--- | :--- | :--- |
| **Petroleum Blue** | `#173B4D` | Color primario institucional, botones principales, app bars. |
| **Brick Terracotta** | `#B84A1C` | Acentos de acción, contraofertas y alertas destacadas. |
| **Highland Green** | `#237553` | Indicadores de confirmación, acuerdos cerrados y escrow. |
| **Warm Canvas** | `#F8F6F1` | Fondo de pantallas para reducir fatiga visual. |
| **Card White** | `#FFFFFF` | Superficies de elevación y tarjetas de contenido. |

---

## 🚀 Tecnologías y Dependencias

- **Flutter SDK:** `^3.13.5`
- **Mapas y Geolocalización:**
  - [`flutter_map`](https://pub.dev/packages/flutter_map) + [`latlong2`](https://pub.dev/packages/latlong2): Renderizado de mapas vectoriales y tiles OpenStreetMap sin costo de API keys comerciales.
  - [`geolocator`](https://pub.dev/packages/geolocator): Localización precisa del dispositivo.
- **Tipografía y Estilos:**
  - [`google_fonts`](https://pub.dev/packages/google_fonts): Tipografía moderna y consistente.
  - [`intl`](https://pub.dev/packages/intl): Formateo de fechas y moneda (Soles peruanos).
- **Herramientas de Branding:**
  - [`flutter_launcher_icons`](https://pub.dev/packages/flutter_launcher_icons): Generación automatizada de iconos nativos en Android e iOS.

---

## 💻 Instalación y Configuración

### Prerrequisitos
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (versión 3.13 o superior)
- Dart SDK compatible
- Android Studio / VS Code con extensiones de Flutter
- Emulador Android / iOS o dispositivo físico configurado con depuración USB

### Pasos de Instalación

1. **Clonar el repositorio:**
   ```bash
   git clone https://github.com/Kasper85/chamba.git
   cd chamba
   ```

2. **Instalar dependencias:**
   ```bash
   flutter pub get
   ```

3. **Ejecutar la suite de pruebas:**
   ```bash
   flutter test
   ```

4. **Lanzar la aplicación:**
   ```bash
   flutter run
   ```

---

## 🧪 Pruebas y Calidad

El proyecto incluye pruebas automatizadas que validan:
- **Ciclo completo de vida de negociación inDrive:** Creación de solicitud ➔ Recepción de ofertas ➔ Contraoferta ➔ Aceptación ➔ Estados de llegada ➔ Finalización ➔ Calificación.
- **Flujos de cancelación y rechazo de ofertas.**
- **Centro de notificaciones y marcadores de lectura.**
- **Navegación completa entre pestañas de `ClientShell` y `WorkerShell`.**
- **Comportamiento y accesibilidad de los botones centrales.**

Para ejecutar los tests con detalle:
```bash
flutter test --reporter expanded
```

---

## 🗺️ Roadmap

- [x] Arquitectura base y diseño de pantallas completado (21 pantallas).
- [x] Máquina de estados inDrive con soporte de contraoferta bidireccional.
- [x] Integración de mapas interactivos y cálculo de rutas.
- [x] Suite de pruebas unitarias y de integración de widgets.
- [ ] Backend as a Service (BaaS) con Supabase / Firebase.
- [ ] Autenticación con validación de DNI peruano (Reniec API).
- [ ] Integración de billeteras digitales (Yape / Plin) con custodia de pagos.
- [ ] Notificaciones Push vía FCM (Firebase Cloud Messaging).

---

## 📄 Licencia

Este proyecto se distribuye bajo la licencia **MIT**. Consulta el archivo `LICENSE` para más detalles.
