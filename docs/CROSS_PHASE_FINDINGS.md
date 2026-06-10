# Hallazgos cross-phase

## Alcance

Este documento registra hallazgos observados fuera del ownership directo de Fase 5. No contiene fixes ni refactors.

## BLOCKED_BY_OWNERSHIP: produccion y bootstrap de fabricas

System: Produccion / escenarios

File: `scripts/scenarios/ScenarioFactorySpawner.gd`

Description: el spawner existente lee escenarios planos directamente y no consume datos normalizados desde `ScenarioLoader`.

Impact: obliga a mantener `ScenarioFactoryBootstrap` en `scripts/core/ScenarioFactoryBootstrap.gd` para que paquetes modulares y `country_refs` funcionen sin tocar archivos fuera de alcance.

Severity: Media

## BLOCKED_BY_OWNERSHIP: reportes formales de Fase 6 sin respaldo inicial

System: Mapa / documentacion de fase

File: `docs/*`

Description: Fase 7 debia revisar requisitos de teatro historico, reportes de validacion de mapa y readiness report de Fase 6. Esos documentos aparecieron como archivos no trackeados durante la revision.

Impact: la ausencia inicial de respaldo reducia trazabilidad entre arquitectura de mapa y datos historicos. Al estar en `docs/*`, se clasifican como trabajo valido que debe respaldarse sin modificar su contenido.

Severity: Media

## BLOCKED_BY_OWNERSHIP: trabajo de mapa fuera de Fase 7

System: Mapa

File: `scripts/map/ProvinceInsight.gd`, `scripts/map/MapDataValidator.gd`, `scripts/map/_phase6_check.gd`, `scripts/map/_phase6_check.tscn`, `p6_run.log`, `p6_run2.log`, `p6_import.log`, `p6_final.log`

Description: se observaron cambios y artefactos fuera del ownership de Fase 7 durante el cierre.

Impact: pueden representar trabajo valido de Phase 6 o de otro agente. Fase 7 no los modifica ni los respalda para evitar violar ownership.

Severity: Media

## HISTORICAL_REVIEW_REQUIRED: calibracion historica del teatro 1879

System: Datos historicos de mapa

File: `data/provinces/*`, `data/scenarios/1879/scenario.json`

Description: las provincias 841-847 modelan recursos, poblacion, infraestructura y control inicial con escala de gameplay MVP.

Impact: Gemini debe revisar precision historica fina antes de usar estos valores como base de balance, eventos o diplomacia.

Severity: Media

## BLOCKED_BY_OWNERSHIP: cambios de produccion fuera de Fase 5

System: Produccion

File: `scripts/production/DesignManager.gd`

Description: se observo trabajo de otro flujo en el historial cercano a Fase 5. El archivo esta fuera del ownership de esta fase.

Impact: cualquier regresion o deuda asociada debe ser auditada por el owner de produccion.

Severity: Media

## BLOCKED_BY_OWNERSHIP: configuracion del proyecto

System: Proyecto Godot

File: `project.godot`

Description: se observo trabajo de otro flujo en el historial cercano a Fase 5. El archivo esta fuera del ownership de esta fase.

Impact: cambios de autoloads, escenas o configuracion pueden afectar arranque y validacion runtime de escenarios.

Severity: Alta

## BLOCKED_BY_OWNERSHIP: artefactos de validacion de otra fase

System: Validacion temporal

File: `scripts/core/_phase4_check.gd`, `scripts/core/_phase4_check.tscn`, `p4_run.log`

Description: existen artefactos asociados a validacion de otra fase en el historial. No pertenecen al ownership funcional de Fase 5.

Impact: pueden confundir auditorias futuras si no se clasifican como herramientas temporales o se documenta su proposito.

Severity: Baja

## BLOCKED_BY_OWNERSHIP: validacion runtime con Godot

System: Runtime / entorno local

File: `project.godot`

Description: no hay binario Godot disponible en PATH para ejecutar arranque o carga real del escenario.

Impact: Fase 5 queda con validacion estatica y compatibilidad por contrato, pero sin certificacion runtime real.

Severity: Alta

## BLOCKED_BY_OWNERSHIP: archivos de mapa sin respaldo dentro del workspace

System: Mapa

File: `scripts/map/MapDataValidator.gd`, `scripts/map/_phase6_check.gd`, `scripts/map/_phase6_check.tscn`, `p6_run.log`

Description: durante la verificacion final aparecieron archivos sin track en `scripts/map`, ruta prohibida para Fase 5.

Impact: pueden representar trabajo valido de otra fase que necesita respaldo por su owner. Fase 5 no puede clasificarlos ni commitearlos sin violar ownership.

Severity: Media

## HISTORICAL_REVIEW_REQUIRED: datos nacionales 1879

System: Datos historicos

File: `data/countries/*.json`

Description: los campos `stability`, `war_support`, `industrial_weight`, `current_tech_level` y `strategic_role` son datos de modelado para runtime, no una validacion historiografica final.

Impact: Gemini o el owner historico debe revisar calibracion antes de balance de gameplay.

Severity: Media

---

# Fase 6 (Track A / Claude) — Hallazgos

Solo hallazgos. Sin correcciones ni refactor fuera de la propiedad de Fase 6.

## BLOCKED_BY_OWNERSHIP: TradeManager no compila y contamina el arranque

System: Comercio nacional (autoload `TradeManager`)

File: `scripts/national/TradeManager.gd` (lineas 412, 502, 503, 1168, 1181)

Description: variables sin tipo inferido provocan error de parseo; el autoload no se instancia ("does not inherit from 'Node'") y arrastra la cadena de compilacion, dejando indeclarables varios `class_name` globales (`ScenarioDataResolver`, etc.).

Impact: impide el arranque completo del juego en headless; la validacion de mapa de Fase 6 tuvo que aislarse con `preload` por ruta y reimportacion. Afecta a cualquier fase que dependa del arranque integro.

Severity: Alta

## Cobertura de geometria parcial

System: Datos del mapa

File: `data/provinces/provinces_geometry.json`

Description: 740 de 847 provincias carecen de poligono; no se dibujan. Detectado por `MapDataValidator` (Fase 6).

Impact: la mayoria del mapa es invisible/no seleccionable. No tocado (propiedad de datos). Tambien en deuda DT-P6-02.

Severity: Media

## Escenario 1879 sin provincias historicas reales

System: Datos de escenario

File: `data/scenarios/1879/scenario.json`, `data/provinces/provinces_base.json`

Description: las naciones del Pacifico se ubican sobre provincias genericas reutilizadas; no existen Antofagasta, Tarapaca, Iquique, Arica, Tacna, La Paz ni Sucre como provincias con nombre.

Impact: el teatro no es historicamente fiel todavia. No tocado (propiedad de datos/historia). Detalle en `HISTORICAL_THEATER_READINESS_REPORT.md`.

Severity: Media

## Trabajo de datos sin confirmar en el arbol de trabajo (respaldado)

System: Datos de provincias, paises y escenario

File: `data/provinces/*`, `data/countries/{bolivia,chile,peru}.json`, `data/scenarios/1879/scenario.json`

Description: al iniciar Fase 6 habia trabajo valido de otros tracks sin confirmar (provincias 840->847, estados 70->75, regiones 20->22, geometria 100->107). La validacion confirma integridad (0 errores).

Impact: riesgo de perdida si no se respalda. Observado integro (0 errores). Su track propietario (Fase 7) ya lo tiene en `git add` y lo confirma en su propio commit; Fase 6 NO lo respalda por separado para no interferir con el commit en curso de su owner ni violar propiedad. Ver `GIT_PHASE_6_REPORT.md`.

Severity: Media

## Nota: artefactos temporales de Fase 6 eliminados

System: Validacion temporal

File: `scripts/map/_phase6_check.gd`, `scripts/map/_phase6_check.tscn`, `p6_run.log`, `p6_run2.log`, `p6_import.log`, `p6_final.log`

Description: los artefactos temporales que otras fases observaron sin poder clasificar fueron herramientas de validacion de Fase 6. Ya estan **eliminados**. El trabajo permanente de Fase 6 es `scripts/map/MapDataValidator.gd` (validador reutilizable) y la correccion de `scripts/map/ProvinceInsight.gd`.

Severity: Baja
