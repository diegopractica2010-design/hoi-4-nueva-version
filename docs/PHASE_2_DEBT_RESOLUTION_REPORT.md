# Reporte de Cierre de Deuda Técnica — Fase 2

Este documento resuelve la deuda técnica reportada previamente en la Fase 2.

## Resumen de estados

| ID | Descripción breve | Estado |
|----|-------------------|--------|
| DT-01 | Autoloads de localización no registrados | RESUELTO |
| DT-02 | Conflicto `class_name` vs nombre de autoload | RESUELTO |
| DT-04 | Validación en runtime bloqueada | PARCIALMENTE RESUELTO |

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
- **Estado de resolución:** **PARCIALMENTE RESUELTO**
- **Detalles de implementación:**
  - Se eliminó el bloqueo de origen: los autoloads ya están registrados (DT-01) y
    el conflicto de nombres está resuelto (DT-02), por lo que el sistema **ya es
    ejecutable** en runtime.
  - Se ejecutó **validación estática automatizada** de los datos:
    - Parseo JSON de `en.json` y `es.json`: **OK** en ambos.
    - Conteo de claves: **36 / 36**.
    - Paridad de claves (faltantes/sobrantes en Español): **0 / 0**.
- **Por qué NO está totalmente resuelto:**
  - El **ejecutable de Godot no está instalado/disponible** en este equipo (no se
    encontró en PATH, rutas comunes ni registro), por lo que **no fue posible
    lanzar el motor** para la verificación interactiva.
  - La persona usuaria optó explícitamente por **validación estática** dado que no
    hay Godot disponible en este momento.
- **Archivos modificados:** ninguno adicional (validación, no cambios de código).
- **Resultado de validación:**
  - Verificación estática: **APROBADA**.
  - Verificación interactiva en el editor (cambio de idioma en vivo + persistencia
    entre sesiones): **PENDIENTE DE EJECUCIÓN** por ausencia del binario de Godot.

### Cómo completar la validación interactiva (cuando haya Godot)

1. Abrir el proyecto en Godot 4.6.
2. Confirmar que no aparecen errores de arranque en la consola.
3. Instanciar `scripts/ui/LanguageSelector.tscn` en una escena y cambiar el idioma.
4. Reiniciar y confirmar que el idioma elegido persiste
   (`user://localization.cfg`).

---

## Conclusión

DT-01 y DT-02 quedan **RESUELTOS**: la infraestructura de localización está
**activa** y libre de conflictos de nombres. DT-04 queda **PARCIALMENTE RESUELTO**:
el bloqueo técnico desapareció y la validación estática es satisfactoria, pero la
confirmación interactiva no pudo ejecutarse porque el ejecutable de Godot no está
disponible en este equipo.
