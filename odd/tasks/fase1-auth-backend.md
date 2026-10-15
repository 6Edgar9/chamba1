# Feature: CHAMBA Fase 1 — Backend, Base de Datos y Autenticación Real

## Objective
Implementar la Fase 1 de CHAMBA: Arquitectura frontend/backend completa con NestJS, TypeScript, PostgreSQL (`chamba_db`), Prisma ORM con migraciones versionadas y seeds, autenticación JWT con contraseñas con hash (bcrypt), unificación de la identidad del usuario en Flutter (eliminando perfiles mock divergentes al alternar entre Cliente y Trabajador), persistencia de sesión segura, colección Postman y documentación paso a paso para el equipo.

## Scope & Constraints
- Backend: NestJS 10+ / 11+, TypeScript, Node.js v24+, REST API con prefijo `/api/v1`.
- Database: PostgreSQL 18 local (`chamba_db`), Prisma ORM, migraciones versionadas sin destrucción de datos.
- Auth: JWT (Bearer tokens), bcrypt para hash de contraseñas, validación DTO con `class-validator`.
- Identity: Un único usuario conserva id, nombre y correo tanto en modo Cliente como en modo Trabajador.
- Frontend: Flutter (Android / Medium_Phone), `http` package, persistencia segura de token, manejo de errores 401 y expiración.
- Seguridad: `.env` ignorado por git, `.env.example` público sin credenciales reales, sin secretos en commits ni logs.
- Documentación: `README.md` y `HOW_TO_RUN.md` en español con guías reproducibles para colaboradores.

## Task Checklist
- [x] Task 1: Configuración de seguridad y entorno (.gitignore completo, .env.example, estructura `backend/`, configuración de conexión a `chamba_db` sin filtrar secretos).
- [x] Task 2: Scaffold del Backend NestJS y dependencias (TypeScript, Prisma, bcrypt, JWT, Passport, class-validator, Swagger).
- [x] Task 3: Modelado de datos en Prisma, Migraciones y Seed (Entidades User y WorkerProfile, migración inicial versionada en PostgreSQL `chamba_db`, seed de prueba).
- [x] Task 4: Módulos de Autenticación, Usuarios y Perfil de Trabajador (`/api/v1/auth/register`, `/api/v1/auth/login`, `/api/v1/users/me`, `/api/v1/worker-profile/me` con DTOs y guards).
- [x] Task 5: Colección Postman y Pruebas Automatizadas de API (`CHAMBA API.postman_collection.json`, plantilla de entorno, tests unitarios/e2e de endpoints).
- [x] Task 6: Integración en Flutter — Cliente API, Almacenamiento Seguro y Unificación de Identidad (Servicio API HTTP, almacenamiento seguro de sesión, corrección del cambio de rol en `AppState` para mantener la misma identidad).
- [x] Task 7: Pantallas de Registro, Login y Gestión de Sesión en Flutter (Flujo de bienvenida -> Registro / Login -> Validación -> Guardar sesión -> Restaurar al abrir -> Cerrar sesión).
- [x] Task 8: Pruebas Integrales de Verificación y Validación en Emulador (Pruebas backend, `flutter analyze`, verificación de persistencia en PostgreSQL y validación en emulador Medium_Phone).
- [x] Task 9: Documentación y Guías de Colaboración (`README.md` actualizado, `HOW_TO_RUN.md` detallado en español para el equipo de desarrollo).

## Verification Evidence
1. **Seguridad y Git:**
   - `.gitignore` protege `.env`, `.env.*` (salvo `.env.example`), `backend/.env`, `node_modules/`, `build/`.
   - `git check-ignore backend/.env .env` confirmó que los secretos nunca se suben a Git.
   - Archivo [.env.example](file:///c:/Users/Julio/Desktop/Proyectos/CHAMBA/.env.example) creado con plantilla no sensible.
2. **Backend NestJS & PostgreSQL:**
   - Base de datos `chamba_db` en PostgreSQL 18 local activa.
   - Migración Prisma versionada: `20261015163847_init_users_and_worker_profiles`.
   - Seed ejecutado con éxito: Ana García (`ana@chamba.pe`), José Torres (`jose@chamba.pe`), Carlos Ramírez (`carlos@chamba.pe`).
   - Contraseñas protegidas mediante `bcrypt` (10 rounds de salt, hashes con prefijo `$2b$10$...`).
   - 11/11 pruebas automatizadas e2e pasando en Vitest (`backend/test/auth.e2e-spec.ts`).
   - Documentación Swagger interactiva en `http://localhost:3000/api/docs`.
3. **Colección Postman:**
   - Colección [CHAMBA API.postman_collection.json](file:///c:/Users/Julio/Desktop/Proyectos/CHAMBA/postman/CHAMBA_API.postman_collection.json) y entorno [CHAMBA_Environment.postman_environment.json](file:///c:/Users/Julio/Desktop/Proyectos/CHAMBA/postman/CHAMBA_Environment.postman_environment.json) creados con scripts automáticos para guardar el token JWT en variables de entorno.
4. **Frontend Flutter & Identidad Unificada:**
   - `flutter analyze`: 0 issues encontrados.
   - `flutter test`: 21/21 tests pasando exitosamente.
   - Unificación de Identidad: `AppState` mantiene un único `UserAccount` y `WorkerProfile`. Al alternar entre Cliente y Trabajador, el usuario conserva su id, nombre (`clientName` y `currentWorkerProfile.name`), distrito e iniciales.
   - Persistencia segura con `FlutterSecureStorage` (restauración automática de sesión y logout seguro).
5. **Validación en Emulador Android (Medium_Phone via Mobile MCP):**
   - Escenario 1 y 2: Formulario de registro con validaciones de campos obligatorios, contraseñas coincidentes y formato de correo.
   - Escenario 3 y 4: Inicio de sesión como Ana y José en emulador; alternancia entre Cliente y Trabajador validada visualmente con capturas de pantalla manteniendo la identidad.
   - Escenario 5 y 6: Cierre de sesión y nuevo inicio de sesión con José Torres; se cargaron sus datos y avatar `JT`.
   - Escenario 7: Persistencia al reiniciar la aplicación comprobada mediante card de sesión activa en la pantalla de bienvenida.
   - Escenario 8: Rechazo de credenciales incorrectas verificado en vivo con error 401 y banner en pantalla.
   - Escenario 9: Acceso denegado (401) en endpoints protegidos sin token verificado por tests automatizados.
   - Escenario 10: Usuarios persistidos en `chamba_db` y contraseñas hasheadas en base de datos verificado con consulta Prisma.
6. **Documentación:**
   - [HOW_TO_RUN.md](file:///c:/Users/Julio/Desktop/Proyectos/CHAMBA/HOW_TO_RUN.md) y [README.md](file:///c:/Users/Julio/Desktop/Proyectos/CHAMBA/README.md) en español con guías paso a paso de instalación, PostgreSQL, migraciones, seed, backend, frontend y Postman.

## Next Step
- Fase 1 completada al 100%. Preparar entrega al usuario con resumen técnico detallado.
