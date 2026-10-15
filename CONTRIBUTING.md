# Guía de Contribución y Trabajo Colaborativo — CHAMBA 🤝

¡Bienvenido al equipo de desarrollo de **CHAMBA**! Esta guía establece los estándares y procedimientos para que todos los integrantes del equipo puedan trabajar simultáneamente en el proyecto, abrir ramas, realizar commits claros, colaborar mediante Pull Requests y mantener sincronizada la base de datos PostgreSQL con Prisma sin pisar el trabajo de los demás.

---

## 📌 Tabla de Contenidos

1. [Principios de Colaboración del Equipo](#1-principios-de-colaboración-del-equipo)
2. [Nomenclatura de Ramas (Branching Strategy)](#2-nomenclatura-de-ramas-branching-strategy)
3. [Flujo de Trabajo Paso a Paso (Git Workflow)](#3-flujo-de-trabajo-paso-a-paso-git-workflow)
4. [Estándar de Commits (Conventional Commits)](#4-estándar-de-commits-conventional-commits)
5. [Apertura y Revisión de Pull Requests (PR)](#5-apertura-y-revisión-de-pull-requests-pr)
6. [Resolución de Conflictos Básicos en Git](#6-resolución-de-conflictos-básicos-en-git)
7. [PostgreSQL y Actualizaciones Compartidas con Prisma](#7-postgresql-y-actualizaciones-compartidas-con-prisma)
8. [Verificación Obligatoria Antes de Integrar Cambios](#8-verificación-obligatoria-antes-de-integrar-cambios)
9. [Mantenimiento y Actualización Documental](#9-mantenimiento-y-actualización-documental)

---

## 1. Principios de Colaboración del Equipo

Para garantizar que el repositorio se mantenga limpio y funcional en todo momento:

- **La rama `main` siempre debe ser estable y funcional:** Nunca trabajes directamente sobre `main` ni hagas commits o push directos a esta rama.
- **Todo cambio pasa por una rama de trabajo y un Pull Request:** Cada funcionalidad o corrección vive en su propia rama aislada.
- **Verifica localmente antes de compartir:** Ejecuta los tests del frontend (`flutter test`) y del backend (`npm run test:e2e`) antes de solicitar revisión.
- **Ningún secreto en Git:** Nunca agregues archivos `.env`, contraseñas reales ni certificados al control de versiones.
- **Desarrollo Guiado por ODD (Organic Driven Development):** Plantea el problema, explora el código existente y avanza paso a paso registrando tus tareas en `odd/tasks/`.

---

## 2. Nomenclatura de Ramas (Branching Strategy)

Crea ramas con nombres descriptivos en minúsculas, separadas por barras y guiones según el tipo de cambio:

| Prefijo | Propósito | Ejemplo |
|---|---|---|
| `feature/` | Nueva funcionalidad o módulo | `feature/auth-jwt`, `feature/solicitudes`, `feature/chat` |
| `fix/` | Corrección de un error o bug de layout | `fix/overflow-available-jobs`, `fix/login-validation` |
| `refactor/` | Reorganización de código sin alterar comportamiento | `refactor/worker-profile-ui`, `refactor/clean-state` |
| `test/` | Nuevas pruebas unitarias o de integración | `test/responsive-layout`, `test/worker-e2e` |
| `docs/` | Actualización de documentación | `docs/how-to-run-update`, `docs/api-contracts` |

---

## 3. Flujo de Trabajo Paso a Paso (Git Workflow)

Sigue este ciclo en cada tarea que desarrolles:

### Paso 1: Actualizar tu rama `main` local
Antes de empezar a programar, asegúrate de tener la versión más reciente del equipo:
```powershell
git checkout main
git pull origin main
```

### Paso 2: Crear tu rama de trabajo
```powershell
git checkout -b feature/nombre-de-tu-funcionalidad
```

### Paso 3: Desarrollar la funcionalidad
Implementa tus cambios en Flutter o NestJS siguiendo las buenas prácticas de arquitectura y adaptabilidad responsive.

### Paso 4: Validar pruebas locales
Asegúrate de que no haya errores estáticos ni tests rotos:
```powershell
# En Flutter:
flutter analyze
flutter test

# En Backend:
cd backend
npm run build
npm run test:e2e
cd ..
```

### Paso 5: Confirmar tus cambios locales
Agrega solo los archivos modificados que pertenezcan a tu tarea:
```powershell
git add .
git commit -m "feat(auth): add password confirmation validation in register screen"
```

### Paso 6: Subir tu rama a GitHub
```powershell
git push -u origin feature/nombre-de-tu-funcionalidad
```

### Paso 7: Abrir un Pull Request (PR)
Entra a GitHub ([https://github.com/Kasper85/chamba](https://github.com/Kasper85/chamba)), selecciona tu rama y pulsa **Compare & pull request**.

---

## 4. Estándar de Commits (Conventional Commits)

Utilizamos el estándar internacional **Conventional Commits** para mantener un historial claro, profesional y fácil de auditar:

```text
<tipo>(<alcance opcional>): <descripción corta en imperativo o pasado claro>
```

### Tipos permitidos:
- **`feat:`** Una nueva funcionalidad para el usuario (ejemplo: `feat(jobs): add category filter to available jobs screen`).
- **`fix:`** Corrección de un defecto o desbordamiento (ejemplo: `fix(ui): eliminate RenderFlex overflow in worker wallet chart`).
- **`refactor:`** Reestructuración de widgets o servicios sin cambios de lógica (ejemplo: `refactor(worker): extract independent portfolio screen`).
- **`test:`** Adición o corrección de pruebas (ejemplo: `test(responsive): add compact screen test suite for auth flow`).
- **`docs:`** Cambios exclusivamente en documentación (ejemplo: `docs(contributing): add prisma database sync instructions`).
- **`chore:`** Tareas de mantenimiento de configuración o dependencias (ejemplo: `chore(deps): update prisma to version 6.19.3`).

> ⛔ **Regla de oro:** No agregues firmas tipo `"Co-Authored-By"` ni atribuciones automáticas innecesarias en los commits.

---

## 5. Apertura y Revisión de Pull Requests (PR)

Al abrir un PR en GitHub:

1. **Título claro:** Utiliza el mismo formato de commit (ejemplo: `feat(client): implement job request creation flow`).
2. **Descripción estructurada:**
   - **¿Qué problema resuelve o qué añade?**
   - **¿Qué pantallas o endpoints fueron modificados?**
   - **¿Qué pruebas se ejecutaron y cuál fue el resultado?**
   - **Capturas de pantalla o videos breves (si hay cambios de interfaz).**
3. **Revisión por pares (Code Review):** Al menos un compañero debe revisar el código antes del merge.
4. **Merge no destructivo:** Una vez aprobado, se integra a `main` mediante la opción *Squash and merge* o *Rebase and merge*.

---

## 6. Resolución de Conflictos Básicos en Git

Cuando dos integrantes modifican líneas cercanas del mismo archivo (por ejemplo, `app_state.dart` o `main.dart`):

### 6.1 Sincronizar tu rama con `main`
```powershell
git checkout main
git pull origin main
git checkout feature/tu-rama
git merge main
```

### 6.2 Identificar los archivos en conflicto
Si Git indica que hay conflictos, ejecuta `git status`. Los archivos contendrán bloques delimitados por marcas de conflicto:
```text
  [Conflicto en tu rama HEAD]
  Text('Mi Tarifa', style: AppTypography.titleSm);
  -----------------------------------------------
  [Cambios entrantes desde main]
  Text('Tarifa Orientativa S/.', style: AppTypography.titleSm);
```
*(Git utiliza marcas con signos menor que, igual y mayor que para señalar el inicio, separación y fin del bloque en conflicto).*

### 6.3 Resolver el conflicto en tu editor
1. Abre el archivo en Antigravity IDE o VS Code.
2. Habla con tu compañero para acordar cuál versión es la correcta o cómo combinarlas.
3. Elimina las líneas marcadoras `<<<<<<<`, `=======` y `>>>>>>>`.
4. Ejecuta las pruebas para verificar que el código compila y pasa:
   ```powershell
   flutter test
   ```
5. Confirma la resolución del conflicto:
   ```powershell
   git add .
   git commit -m "chore(merge): resolve conflict with main"
   git push origin feature/tu-rama
   ```

---

## 7. PostgreSQL y Actualizaciones Compartidas con Prisma

Este apartado es fundamental para que el equipo entienda cómo conviven la base de datos y el código:

> ⚠️ **REGLA FUNDAMENTAL:**
> **GitHub NO sincroniza automáticamente los registros ni las tablas de PostgreSQL.**
> Git almacena únicamente archivos de texto (código fuente y scripts SQL de migración). La base de datos `chamba_db` de cada desarrollador se ejecuta de manera local e independiente en su propia máquina.

### 7.1 Los 4 Componentes de Prisma en el Repositorio
Para que todos los integrantes tengan exactamente la misma estructura de base de datos sin enviarse volcados pesados, compartimos:
1. `backend/prisma/schema.prisma`: El modelo declarativo de entidades (User, WorkerProfile, Enums).
2. `backend/prisma/migrations/`: El historial cronológico de archivos SQL versionados que Prisma ejecuta en orden.
3. `backend/prisma/seed.ts`: El script automatizado que inserta datos demo seguros y consistentes para todo el equipo.
4. `package.json`: La versión fijada del cliente y CLI de Prisma.

---

### 7.2 Procedimiento A: Cuando TÚ agregas una nueva tabla o columna

Si tu tarea requiere agregar un campo (por ejemplo, `dni` en `User` o una nueva tabla `jobs`):

```
1. Editas schema.prisma  ──>  2. npx prisma migrate dev  ──>  3. Commit de schema + migración  ──>  4. Pull Request
```

1. **Modificar `backend/prisma/schema.prisma`:**
   Agrega tu nuevo campo o modelo con sus tipos correspondientes.
2. **Crear y aplicar la migración localmente con un nombre descriptivo:**
   ```powershell
   cd backend
   npx prisma migrate dev --name agregar_campo_dni_usuario
   ```
   *¿Qué hace este comando?*
   - Detecta la diferencia entre tu `schema.prisma` y tu base de datos local.
   - Crea automáticamente una carpeta dentro de `prisma/migrations/` con un archivo `migration.sql`.
   - Aplica el SQL en tu base de datos `chamba_db`.
   - Regenera el cliente TypeScript (`npx prisma generate`).
3. **Probar el cambio localmente:**
   Verifica tus endpoints con Postman o Swagger y ejecuta `npm run test:e2e`.
4. **Incluir la migración en tu commit:**
   ```powershell
   git add prisma/schema.prisma prisma/migrations/
   git commit -m "feat(db): add dni field to users table"
   ```
5. **Subir tu rama y abrir el Pull Request.**

---

### 7.3 Procedimiento B: Cuando un COMPAÑERO agregó una migración a `main`

Cuando descargues los cambios más recientes del repositorio y veas que se añadieron nuevos archivos en `prisma/migrations/`:

```
1. git pull origin main  ──>  2. npx prisma migrate deploy  ──>  3. npx prisma generate
```

1. **Actualizar tu repositorio local:**
   ```powershell
   git checkout main
   git pull origin main
   ```
2. **Aplicar las migraciones pendientes sin alterar tus datos existentes:**
   ```powershell
   cd backend
   npx prisma migrate deploy
   ```
   > 💡 **¿Por qué `migrate deploy` en lugar de `migrate dev`?**
   > `migrate deploy` es el comando seguro para aplicar migraciones ya creadas por otros integrantes. No te pedirá nombres de migración ni reseteará la base de datos.
3. **Regenerar el cliente de Prisma para tener los tipos TypeScript actualizados:**
   ```powershell
   npx prisma generate
   ```
4. **(Opcional) Si la migración incluyó nuevos seeds:**
   ```powershell
   npx prisma db seed
   ```

---

### 7.4 Comprobar el Estado de las Migraciones
Si tienes dudas sobre si tu base de datos local está al día o le falta alguna migración:
```powershell
cd backend
npx prisma migrate status
```
Prisma te informará:
- Si tu base de datos está completamente sincronizada (`Database schema is up to date!`).
- O si hay migraciones pendientes por aplicar.

---

### 7.5 Diferencia entre Estructura, Datos Ficticios y Respaldos

Para evitar confusiones en el equipo:

| Concepto | ¿Qué contiene? | ¿Cómo se comparte en el equipo? | ¿Se sube a GitHub? |
|---|---|---|:---:|
| **Estructura (Esquema)** | Definición de tablas, columnas, tipos e índices. | A través de `schema.prisma` y `prisma/migrations/`. | ✅ **SÍ** |
| **Datos Ficticios (Seed)** | Cuentas demo (Ana García, José Torres) para pruebas. | A través del script `backend/prisma/seed.ts`. | ✅ **SÍ** |
| **Respaldos (Dumps)** | Copia binaria o SQL de todos los registros reales de una PC. | Exportados localmente con `pg_dump`. | ❌ **NUNCA** |
| **Base de Datos Centralizada** | Instancia en la nube (ej. Supabase, RDS, Neon). | Compartida vía URL remota en fases avanzadas del proyecto. | ❌ (Solo credenciales privadas) |

---

### 7.6 Procedimiento Opcional de Backup y Restauración Local

Si un integrante necesita respaldar su base de datos local antes de una prueba crítica:

#### Crear un respaldo local (backup):
```powershell
pg_dump -U postgres -h localhost -p 5432 -F c -b -v -f "chamba_db_backup.dump" chamba_db
```

#### Restaurar un respaldo local:
```powershell
pg_restore -U postgres -h localhost -p 5432 -d chamba_db -v "chamba_db_backup.dump"
```

> ⚠️ **Seguridad:** Los archivos `.dump`, `.bak`, `.backup` y `*.sql` están estrictamente ignorados en `.gitignore` para evitar filtraciones de datos locales en GitHub.

---

## 8. Verificación Obligatoria Antes de Integrar Cambios

Antes de solicitar la integración de tu rama a `main`, ejecuta esta lista de verificación rápida:

- [ ] `flutter analyze` reporta **0 errores ni advertencias**.
- [ ] `flutter test` pasa al **100% de tests en verde**.
- [ ] `cd backend && npm run build` compila TypeScript sin errores.
- [ ] `cd backend && npm run test:e2e` aprueba todos los tests de API.
- [ ] `npx prisma validate` confirma que el esquema es válido.
- [ ] `git status` no muestra archivos `.env` sin ignorar ni artefactos temporales.

---

## 9. Mantenimiento y Actualización Documental

Cada vez que tu equipo termine una fase o añada nuevas capacidades, es responsabilidad del autor actualizar los documentos correspondientes:

1. **`README.md`:** Si se añaden nuevas capacidades funcionales, cambia la arquitectura o se conectan nuevos servicios.
2. **`HOW_TO_RUN.md`:** Si se añaden dependencias de sistema, cambian los comandos o las variables de entorno.
3. **`backend/.env.example`:** Si el backend requiere una nueva variable de configuración (siempre con valores dummy, nunca con secretos).
4. **`postman/`:** Si se agregan o modifican endpoints REST en el backend, exporta y actualiza la colección.
5. **`odd/tasks/`:** Registra la tarea culminada en el directorio ODD como constancia de la evolución técnica del proyecto.
