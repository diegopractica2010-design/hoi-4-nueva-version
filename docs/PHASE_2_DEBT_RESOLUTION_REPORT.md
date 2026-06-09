# Reporte de Cierre de Deuda Técnica — Fase 2

Este documento resuelve la deuda técnica reportada previamente en la Fase 2.

## Resumen de estados

| ID | Descripción breve | Estado |
|----|-------------------|--------|
| DT-01 | Autoloads de localización no registrados | RESUELTO |
| DT-02 | Conflicto `class_name` vs nombre de autoload | RESUELTO |
| DT-04 | Validación en runtime bloqueada | RESUELTO |

---

## DT-01 — Registro de autoloads de localización

- **Descripción original:** los singletons de localización (`LanguageManager`,
  `TranslationProvider`, `LocalizationSettings` y la fachada `Localization`) no
  estaban registrados como autoloads en `project.godot`, por lo que no estaban
  activos en runtime.
- **Estado de resolución:** **RESUELTO**
- **Detalles de implementación:**
  - Se registraron los cuatro singletons como autoloads.
  - Se ubicaron **después** de los autoloads existentes y en **orden seguro de
    inicialización** según sus dependencias:
    1. `LocalizationSettings` (sin dependencias)
    2. `LanguageManager` (usa `LocalizationSettings` al cargar la preferencia)
    3. `TranslationProvider` (usa `LanguageManager` para el idioma activo)
    4. `Localization` (fachada; se conecta a `LanguageManager`)
  - Godot inicializa los autoloads en el orden listado, garantizando que cada
    sistema encuentre sus dependencias ya activas en su `_ready()`.
- **Archivos modificados:**
  - `project.godot` (sección `[autoload]`)
- **Resultado de validación:** las cuatro entradas quedan registradas con rutas
  válidas y en orden de dependencia correcto (validación estática).

---

## DT-02 — Conflicto `class_name` vs nombre de autoload

- **Descripción original:** los scripts usaban `class_name` (p. ej.
  `LanguageManager`) y a la vez se referenciaban por ese mismo nombre como
  singleton. Al registrarlos como autoload con el mismo nombre, Godot 4 reporta el
  conflicto: *"Class hides an autoload singleton"*.
- **Estado de resolución:** **RESUELTO**
- **Decisión de arquitectura (la más segura):**
  - Se **eliminó `class_name`** de los cuatro scripts que se convierten en
    autoloads. El nombre del autoload pasa a ser el único identificador global.
  - Motivo: todo el código ya referencia estos sistemas por su nombre de singleton
    (`LanguageManager.set_language(...)`, etc.), no como tipo. Quitar `class_name`
    elimina el conflicto sin romper ninguna llamada existente.
  - `LanguageSelector` **conserva** su `class_name` porque **no** es autoload (es un
    control de UID instanciable), así que no genera conflicto.
  - Se documentó la decisión con un comentario en la cabecera de cada script.
- **Archivos modificados:**
  - `scripts/localization/LanguageManager.gd`
  - `scripts/localization/TranslationProvider.gd`
  - `scripts/localization/LocalizationSettings.gd`
  - `scripts/localization/Localization.gd`
- **Resultado de validación:** no quedan nombres `class_name` que colisionen con
  nombres de autoload. Conflicto eliminado (validación estática).

---

## DT-04 — Validación en runtime

- **Descripción original:** no se pudo validar en runtime (cambio de idioma en
  vivo, persistencia, ausencia de errores de arranque) porque los autoloads no
  estaban activos.
- **Estado de resolución:** **RESUELTO**
- **Detalles de implementación:**
  - Se eliminó el bloqueo de origen: autoloads registrados (DT-01) y conflicto de
    nombres resuelto (DT-02).
  - Se ejecutó el proyecto con **Godot 4.6 en modo headless** mediante una escena
    de validación temporal (`_runtime_check.tscn`, eliminada tras la prueba) que
    verificó el sistema real con los autoloads activos.
  - La validación comprobó: autoloads activos, idiomas disponibles, texto en
    Inglés, texto en Español, cambio de idioma en runtime, interpolación de
    parámetros, fallback de clave inexistente y persistencia en disco.
- **Resultado de validación (runtime, Godot 4.6 headless):**

  | Comprobación | Resultado |
  |--------------|-----------|
  | `LocalizationSettings` activo | true |
  | `LanguageManager` activo | true |
  | `TranslationProvider` activo | true |
  | `Localization` activo | true |
  | Idiomas disponibles | `["en", "es"]` |
  | EN `menu.main.save_game` | "Save Game" |
  | ES `menu.main.save_game` | "Guardar partida" |
  | Interpolación de parámetros | "El líder Rommel se ha retirado." |
  | Fallback (clave inexistente) | devuelve la clave |
  | Persistencia (guardar→cargar) | "es" |
  | **Resultado global** | **APROBADO** |

- **Errores de arranque:** ninguno proveniente de los scripts de localización.
  (El proyecto sí muestra errores preexistentes en otros sistemas —`production`,
  `map`, `national`, `technology`, `ui/TopInfoBar`— que son trabajo en curso de
  otros agentes y están **fuera de mi alcance**.)

### Bugs encontrados y corregidos durante la validación runtime

La ejecución real reveló dos defectos en código propio que fueron corregidos:

1. **Persistencia rota** — `LocalizationSettings` usaba `ResourceLoader.exists()`
   para comprobar `user://localization.cfg`. Ese método solo detecta recursos
   importados, no archivos `user://`, por lo que la carga siempre devolvía vacío.
   Se reemplazó por `FileAccess.file_exists()`.
2. **Lista de idiomas vacía** — `LanguageManager.get_available_languages()`
   devolvía `AVAILABLE_LANGUAGES.duplicate()` (Array sin tipar) como `Array[String]`;
   en Godot 4 esa conversión produce un arreglo vacío. Se reconstruye ahora un
   `Array[String]` tipado explícitamente.

- **Archivos modificados:**
  - `scripts/localization/LocalizationSettings.gd`
  - `scripts/localization/LanguageManager.gd`

---

## Conclusión

DT-01, DT-02 y DT-04 quedan **RESUELTOS**. La infraestructura de localización está
**activa**, libre de conflictos de nombres y **verificada en runtime con Godot 4.6**:
Inglés, Español, cambio de idioma en vivo y persistencia funcionan correctamente.
Durante la validación se detectaron y corrigieron dos bugs propios (persistencia y
listado de idiomas).
