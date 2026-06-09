# Deuda Técnica — Fase 2 (Localización)

> Regla de la fase: la deuda **no se corrige**, solo se documenta.
> Estado de todos los ítems: **PENDIENTE**.

## DT-01 — Registro de autoloads en `project.godot`

- **Descripción:** `Localization`, `LanguageManager`, `TranslationProvider` y
  `LocalizationSettings` deben registrarse como autoloads (singletons globales)
  para que el resto del juego pueda invocarlos por nombre.
- **Motivo de no corrección:** `project.godot` está fuera del alcance de archivos
  permitidos en esta fase.
- **Impacto:** sin el registro, los scripts existen pero no están activos como
  singletons en runtime.
- **Estado:** PENDIENTE

## DT-02 — Conflicto potencial `class_name` vs nombre de autoload

- **Descripción:** los scripts usan `class_name` (p. ej. `LanguageManager`) y a la
  vez se referencian por ese mismo nombre como singleton. Al registrarlos como
  autoload con el mismo nombre, Godot puede reportar conflicto de nombres.
- **Motivo de no corrección:** depende de decisiones sobre `project.godot` (DT-01),
  fuera de alcance.
- **Impacto:** posible necesidad de renombrar la clase o el autoload al integrar.
- **Estado:** PENDIENTE

## DT-03 — Externalización de textos existentes del juego

- **Descripción:** los textos actuales (menús, HUD, tooltips, eventos) siguen
  embebidos en escenas/scripts del juego y aún no usan claves de localización.
- **Motivo de no corrección:** dichas escenas/scripts están fuera del alcance de
  archivos permitidos en esta fase.
- **Impacto:** el juego no muestra texto traducido hasta migrar esos textos a
  claves (Fases 2.1–2.3 del plan de migración).
- **Estado:** PENDIENTE

## DT-04 — Validación interactiva en el editor de Godot

- **Descripción:** no se ejecutó prueba en runtime dentro del editor (cambio de
  idioma en vivo, persistencia entre sesiones) porque depende de DT-01.
- **Motivo de no corrección:** requiere autoloads activos.
- **Impacto:** la validación actual es estática; falta confirmación interactiva.
- **Estado:** PENDIENTE

## DT-05 — Cobertura limitada de claves

- **Descripción:** los archivos `en.json`/`es.json` contienen un conjunto base de
  claves representativas, no la totalidad de textos del juego.
- **Motivo de no corrección:** el inventario completo de textos depende de la
  migración (DT-03), fuera de alcance.
- **Impacto:** faltan claves por agregar conforme se externalicen textos.
- **Estado:** PENDIENTE
