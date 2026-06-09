# Plan de Migración de Localización — Fase 2

## Objetivo

Construir una infraestructura de localización lista para producción que soporte
**Inglés** y **Español**, donde agregar idiomas futuros requiera **solo cambios de
datos** (un nuevo archivo JSON), nunca cambios de código.

## Arquitectura

La infraestructura se compone de cuatro scripts y una fachada única:

| Componente | Archivo | Responsabilidad |
|------------|---------|-----------------|
| Fachada | `scripts/localization/Localization.gd` | Punto de entrada único para todos los sistemas |
| Gestor de idioma | `scripts/localization/LanguageManager.gd` | Idioma actual, cambio en runtime, señal de cambio |
| Proveedor de traducción | `scripts/localization/TranslationProvider.gd` | Carga de JSON, resolución de claves, fallback |
| Persistencia | `scripts/localization/LocalizationSettings.gd` | Guardar/cargar preferencia en disco |
| Datos | `data/localization/en.json`, `es.json` | Pares clave → texto traducido |
| UI | `scripts/ui/LanguageSelector.gd` + `.tscn` | Selector de idioma en runtime |

### Flujo

1. Todo sistema del juego pide texto con `Localization.get_text("clave")`.
2. `Localization` enruta a `TranslationProvider`.
3. `TranslationProvider` busca la clave en el idioma activo; si falta, usa el
   idioma de respaldo (Inglés); si tampoco existe, devuelve la clave como texto.
4. `LanguageManager` controla el idioma activo y emite `language_changed`.
5. `LocalizationSettings` guarda la elección en `user://localization.cfg`.

## Cómo agregar un idioma futuro (solo datos)

1. Crear `data/localization/<código>.json` con las mismas claves que `en.json`.
2. Agregar el código a `AVAILABLE_LANGUAGES` y un nombre visible en
   `get_language_display_name()` dentro de `LanguageManager.gd`.

> Nota: el paso 2 es una línea de configuración, no lógica nueva. El motor de
> traducción no cambia al agregar idiomas.

## Fases de migración de texto existente

| Fase | Alcance | Estado |
|------|---------|--------|
| 2.0 | Infraestructura base (este entregable) | COMPLETADO |
| 2.1 | Externalizar textos de menús a claves | PENDIENTE |
| 2.2 | Externalizar textos de HUD y tooltips | PENDIENTE |
| 2.3 | Externalizar mensajes de eventos/diplomacia | PENDIENTE |

Las fases 2.1–2.3 quedan fuera de este entregable y se documentan como deuda
técnica en `docs/TECH_DEBT_PHASE_2.md`.

## Registro como Autoload (dependencia externa)

Para que `Localization`, `LanguageManager`, `TranslationProvider` y
`LocalizationSettings` funcionen como singletons globales, deben registrarse como
**autoloads** en `project.godot`. Ese archivo **no pertenece al alcance de esta
fase** y no fue modificado. Ver deuda técnica DT-01.
