# Reparaciones aplicadas tras el testing

Fecha: 2026-06-12 · Todas verificadas ejecutando el motor (no "debería funcionar").

## Bugs del testing reparados

| Bug | Severidad | Archivo:línea | Arreglo | Verificación |
|---|---|---|---|---|
| BUG-0001 | CRÍTICO | EventManager.gd:1, AIManager.gd:1, BattleResultPopup.gd:42-43, VictoryScreen.gd:24 | quitar `class_name` + tipos explícitos | boot 0 errores |
| BUG-0011 | ALTO | TopInfoBar.gd:271-275 | `theme_override_colors` → `add_theme_color_override` | boot 0 errores |
| BUG-0003 | MEDIO | AgentManager.gd:99-101 | construir `Array[Agent]` tipado en vez de castear `[] as Array[Agent]` | `get_agents_for_country('CHL')=0` sin error |
| BUG-0005 | ALTO | ScenarioLoader.gd (nuevo `_deploy_starting_forces`) | consumir `starting_forces` y colocar formaciones en sus provincias | **11 formaciones colocadas**: Santiago(90)×3, Lima(71)×3, Antofagasta(841)×2, Arica(844), La Paz(846), Sucre(847) |
| BUG-0002 | ALTO | LeaderManager.gd get_save_data/apply_save_data | serializar/restaurar `formations` con `province_id`/`is_moving` | **save→mover→load restaura provincia 846** (restaurada=true) |
| BUG-0007 | MEDIO | TimeManager.gd + SaveLoadManager.gd | semilla de RNG registrada por partida y restaurada al cargar | `game_seed` no-cero y persistido en el save |

## Bugs ADICIONALES descubiertos y reparados durante la reparación
(El bug de `traits` abortaba la restauración del guardado ANTES de llegar a las formaciones — por eso BUG-0002 no se arreglaba solo con serializar.)

| Archivo:línea | Problema | Arreglo |
|---|---|---|
| LeaderManager.gd:2703 (`traits`) | asignar `Array` a `Array[String]` abortaba `apply_save_data` | construir `Array[String]` tipado |
| LeaderManager.gd:2773-2775 (`pending_retirements`, `pending_leader_replacements`) | mismo patrón, `Array[String]`/`Array[Dictionary]` | rebuild tipado |
| FactoryManager.gd:345 (`assigned_lines`) | mismo patrón, `Array[String]` | rebuild tipado |

Estos 3 eran **bugs latentes de guardado/carga**: cualquier partida con líderes (todas) corrompía la restauración silenciosamente. Ahora la carga es limpia (0 errores).

## Bloqueos NO reparables en código (quedan documentados)
- **I-3** (suite de tests): el proyecto no tiene GUT/addons. Requiere instalar un framework.
- **B11** (export): no existe `export_presets.cfg`. Hay que crear un preset de exportación.
- **B2/A15 visual**, estética del mapa, fluidez a velocidad máxima, resolución: requieren ojos humanos (instrucciones en INFORME_FINAL.md).
- **BUG-0013**: resultó NO ser un cuelgue, sino lentitud acumulada de instanciación (18 escenas en 90s). Relacionado con BUG-0004 (rendimiento).

## Estado final verificado
- Arranque: **0 errores** (`_boot_final_repaired.log`).
- Guardar/cargar: **íntegro**, incluyendo posición de ejércitos (antes se perdía).
- Fuerzas iniciales históricas: **colocadas en el mapa** (antes ninguna).
- Carga de partida: **sin errores de tipo** (antes corrompía líderes/fábricas en silencio).
