# Fase 6 — Deuda Técnica

**Fecha:** 2026-06-09
**Alcance:** deuda **creada o descubierta durante esta fase**. No es una auditoría de todo el proyecto.

Campos por ítem: ID · Severidad · Descripción · Evidencia · Impacto · Estado de bloqueo.

---

## DT-P6-01 — Estados y regiones no expuestos en runtime
- **Severidad:** media.
- **Descripción:** `ScenarioLoader` carga estados (`province_states.json`) y regiones estratégicas (`strategic_regions.json`) en `province_state_by_id` / `province_region_by_id`, pero no los entrega a `MapManager` ni los guarda en `Province` (no existe campo `state_id`/`region_id`).
- **Evidencia:** validación runtime — "estados cargados=847, regiones cargadas=847" en `ScenarioLoader`, pero `Province.gd` y `MapManager.gd` no tienen `state_id`/`region_id` (búsqueda directa: sin coincidencias).
- **Impacto:** no se puede consultar "qué provincias forman un estado" en el juego; bloquea mecánicas históricas a nivel de estado.
- **Bloqueo:** no bloquea esta fase. Trabajo futuro de Track A (`scripts/core`/`scripts/data`/`scripts/map`).

## DT-P6-02 — Cobertura de geometría parcial (740/847 sin polígono)
- **Severidad:** media.
- **Descripción:** solo 107 de 847 provincias tienen geometría; el resto no se dibuja.
- **Evidencia:** `MapDataValidator` → `[WARNING] GEO_COVERAGE: 740 de 847`.
- **Impacto:** la mayoría de provincias son invisibles/no seleccionables en el mapa.
- **Bloqueo:** `data/provinces/provinces_geometry.json` — **propiedad ajena** (no Track A). Documentado también en hallazgos cruzados.

## DT-P6-03 — Sin transferencia de provincias a nivel de estado
- **Severidad:** media.
- **Descripción:** `MapManager.update_province_owner()` transfiere una provincia a la vez; no hay operación para transferir un estado completo (anexiones históricas).
- **Evidencia:** `MapManager.gd` líneas 411-434 (API por provincia única).
- **Impacto:** las anexiones de la Guerra del Pacífico requieren bucles manuales; depende de DT-P6-01.
- **Bloqueo:** no bloquea esta fase. Trabajo futuro de Track A.

## DT-P6-04 — Precedencia de capas no documentada (shadowing silencioso)
- **Severidad:** baja.
- **Descripción:** los atributos de provincia se construyen en cadena base → capas (terreno/economía/recursos) → overrides de escenario; cada fuente puede sobrescribir silenciosamente a la anterior sin aviso ni registro de precedencia.
- **Evidencia:** `ScenarioLoader._apply_layer_data_to_province()` y `ScenarioProvinceApplier._apply_province_override()`.
- **Impacto:** un cambio en una capa puede quedar anulado por el escenario sin que sea evidente; riesgo de confusión al añadir datos históricos.
- **Bloqueo:** no bloquea. Recomendación: documentar el orden de precedencia en `SCHEMA.md` (datos) o en comentarios del cargador.

## DT-P6-05 — `ProvinceInsight.gd` tenía error de tipo (CORREGIDO esta fase)
- **Severidad:** alta (estaba activa) → resuelta.
- **Descripción:** líneas 1469/1471 asignaban `Color("#...")` a una variable BBCode de tipo texto, rompiendo la compilación de todo el módulo de mapa.
- **Evidencia:** "Cannot assign a value of type Color as String" en el primer log de validación.
- **Impacto (antes):** impedía compilar `MapManager` y la cadena del mapa.
- **Bloqueo:** **resuelto** — corregido a `"[color=#ff8888]"` / `"[color=#5ae6b8]"`. Archivo dentro de la propiedad de Track A en esta fase.

## DT-P6-06 — El escenario 1879 usa provincias genéricas, no históricas
- **Severidad:** media (histórica/jugabilidad).
- **Descripción:** las naciones del Pacífico se colocan sobre IDs genéricos reutilizados (71=Lima, 90=Santiago, etc.); Antofagasta/Tarapacá/Iquique/Arica/Tacna/La Paz/Sucre no existen como provincias.
- **Evidencia:** `data/scenarios/1879/scenario.json` (13 overrides sobre IDs genéricos); búsqueda de nombres sin coincidencias en `provinces_base.json`.
- **Impacto:** el teatro aún no es históricamente fiel.
- **Bloqueo:** `data/provinces/*` y `data/scenarios/*` — **propiedad ajena**. Detalle en `HISTORICAL_THEATER_READINESS_REPORT.md`.

## DT-P6-07 — El validador no está integrado en el arranque/CI
- **Severidad:** baja.
- **Descripción:** `MapDataValidator` existe como herramienta reutilizable pero debe invocarse manualmente; no corre automáticamente al iniciar ni en integración continua.
- **Evidencia:** `scripts/map/MapDataValidator.gd` (sin enganche en arranque).
- **Impacto:** una regresión de datos podría no detectarse hasta una ejecución manual.
- **Bloqueo:** no bloquea. Recomendación futura: invocarlo en una prueba automatizada.

---

## Resumen

- **Creada y resuelta en esta fase:** DT-P6-05.
- **Deuda nueva de Track A (futuro):** DT-P6-01, DT-P6-03, DT-P6-04, DT-P6-07.
- **Deuda de propiedad ajena (documentada, no tocada):** DT-P6-02, DT-P6-06.
