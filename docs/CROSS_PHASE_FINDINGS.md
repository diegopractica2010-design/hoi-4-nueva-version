# Hallazgos cross-phase

## Alcance

Este documento registra hallazgos observados fuera del ownership directo de Fase 5. No contiene fixes ni refactors.

## BLOCKED_BY_OWNERSHIP: produccion y bootstrap de fabricas

System: Produccion / escenarios

File: `scripts/scenarios/ScenarioFactorySpawner.gd`

Description: el spawner existente lee escenarios planos directamente y no consume datos normalizados desde `ScenarioLoader`.

Impact: obliga a mantener `ScenarioFactoryBootstrap` en `scripts/core/ScenarioFactoryBootstrap.gd` para que paquetes modulares y `country_refs` funcionen sin tocar archivos fuera de alcance.

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
