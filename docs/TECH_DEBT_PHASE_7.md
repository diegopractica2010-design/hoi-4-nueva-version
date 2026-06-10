# Deuda tecnica Fase 7

## TD7-001

Severity: Alta

Description: no se pudo ejecutar validacion runtime real con Godot.

Evidence: `godot`, `godot4`, `godot4.6` y `godot_console` no estan disponibles en PATH.

Impact: errores de GDScript, autoloads, render o secuencia de carga solo detectables por el motor pueden quedar sin certificar.

Blocking Status: NON_BLOCKING

## TD7-002

Severity: Media

Description: la geometria del teatro historico es operacional y aproximada.

Evidence: las provincias 841-847 usan poligonos simples sobre el mapa existente.

Impact: el teatro es usable para MVP, pero no representa fronteras ni costa historica con precision cartografica.

Blocking Status: NON_BLOCKING

## TD7-003

Severity: Media

Description: no existen provincias maritimas especificas del Pacifico sur.

Evidence: Fase 7 preparo regiones costeras, pero no agrego zonas de mar dedicadas.

Impact: operaciones navales futuras dependen de Phase 6/map architecture o de una fase naval de datos.

Blocking Status: NON_BLOCKING

## TD7-004

Severity: Media

Description: estados y regiones contienen metadata historica que el runtime actual no consume.

Evidence: `owner_tag_1879`, `controller_tag_1879`, `state_capital_province_id`, `region_type` e `historical_role` son campos de contenido ignorados por `ScenarioLoader`.

Impact: la informacion queda preparada para eventos, diplomacia y victoria, pero no tiene efecto runtime hasta futuras fases.

Blocking Status: NON_BLOCKING

## TD7-005

Severity: Baja

Description: los reportes formales de Fase 6 aparecieron sin respaldo Git al inicio de la revision de Fase 7.

Evidence: `HISTORICAL_THEATER_ARCHITECTURE.md`, `HISTORICAL_THEATER_READINESS_REPORT.md`, `MAP_VALIDATION_REPORT.md`, `PHASE_6_RUNTIME_VALIDATION.md` y `TECH_DEBT_PHASE_6.md` estaban como archivos no trackeados.

Impact: la trazabilidad entre Fase 6 y Fase 7 dependia de archivos locales no respaldados hasta este cierre.

Blocking Status: NON_BLOCKING
