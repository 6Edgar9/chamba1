# Tarea ODD: Auditoría y Preparación para Desarrollo Colaborativo

**Objetivo:** Auditar el estado real de CHAMBA (frontend Flutter, backend NestJS, PostgreSQL con Prisma ORM, Postman) y preparar el repositorio para que cualquier integrante del equipo pueda clonar, instalar, ejecutar, migrar la base de datos y colaborar sin depender de la máquina del desarrollador principal.

**Ruta de Implementación:** Directa / Documental con verificaciones técnicas.
**TDD Runner:** `flutter test` (37 tests) / `npm run test:e2e` (11 tests).

---

## Tareas

- [x] **TASK-01: Auditoría Técnica con CodeGraph y Verificaciones Reales**
  - Exploración de arquitectura frontend/backend, endpoints REST reales (`/api/v1/auth/*`, `/api/v1/users/*`, `/api/v1/worker-profile/*`).
  - Verificación del estado de Git y ausencia de secretos rastreados.
  - Comprobación de estado de Prisma y migraciones (`prisma migrate status`).
  - *Evidencia:* CodeGraph blast radius analizado; 37/37 tests Flutter en verde; 11/11 tests e2e NestJS en verde; Prisma validado.

- [x] **TASK-02: Blindaje de Seguridad en `.gitignore` y Plantillas `.env.example`**
  - Exclusión de `.env`, `.env.*`, `.env.local`, `backups/`, `.dump`, `.tar`, `.bak`, `*.sql` (con excepción expresa de `!backend/prisma/migrations/**/*.sql`), certificados, keystores y claves.
  - Actualización de `backend/.env.example` para eliminar secretos predecibles y recomendar usuario dedicado `chamba_app`.
  - *Evidencia:* `git check-ignore` verificado para `.env` y migraciones Prisma.

- [x] **TASK-03: Actualización Integral de `README.md`**
  - Presentación oficial del marketplace CHAMBA (problema, público peruano, diferenciación real vs simulada).
  - Arquitectura modular, estructura de carpetas, tecnologías reales y estado exacto de desarrollo.
  - Enlaces a `HOW_TO_RUN.md` y `CONTRIBUTING.md`.
  - *Evidencia:* `README.md` actualizado con 12 secciones profesionales y tabla de estado por módulo.

- [x] **TASK-04: Actualización Exhaustiva de `HOW_TO_RUN.md`**
  - Guía paso a paso Windows para clonado, Antigravity/VS Code, Flutter, NestJS, PostgreSQL (`chamba_db`, usuario `chamba_app`), Prisma migrate/generate/seed.
  - Configuración de emulador Android (`10.0.2.2:3000`), Swagger (`/api/docs`), Postman, tests y APK debug.
  - *Evidencia:* `HOW_TO_RUN.md` actualizado con comandos exactos probados en PowerShell y solución de errores comunes.

- [x] **TASK-05: Creación de `CONTRIBUTING.md` para Trabajo Colaborativo**
  - Guía didáctica para estudiantes sobre ramas Git (`feature/*`, `fix/*`), Conventional Commits y Pull Requests.
  - Procedimiento riguroso de sincronización de base de datos con Prisma (`migrate dev` vs `migrate deploy`, seed).
  - Manejo de conflictos y disciplina de trabajo con ODD.
  - *Evidencia:* `CONTRIBUTING.md` creado con 9 secciones claras y tabla comparativa estructura vs datos vs dumps.

- [x] **TASK-06: Verificación Final del Repositorio**
  - `flutter analyze` (0 issues).
  - `flutter test` (37/37 tests aprobados).
  - `npm run build` y `npm run test:e2e` en backend (11/11 tests aprobados).
  - Validación de Prisma (`schema.prisma is valid 🚀`, migración sincronizada).
  - Estado limpio de Git: ningún push al remoto ejecutado.
  - *Evidencia:* Comandos ejecutados y verificados en terminal local.
