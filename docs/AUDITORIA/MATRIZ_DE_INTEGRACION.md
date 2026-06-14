# Matriz de integracion

## Cadena jugable principal

| Conexion | Estado | Evidencia |
|---|---|---|
| ScenarioLoader a MapManager (scenario_loaded) | ACTIVA | MapManager.gd:53-71 |
| TimeManager.game_day_advanced a MapManager (reparacion infra) | ACTIVA | MapManager.gd:49-51 |
| TimeManager.game_day_advanced a VictoryConditions | ACTIVA | VictoryConditions.gd _ready |
| TimeManager.game_day_advanced a NationalIncomeManager | ROTA HOY (cascada compilacion) | boot log: Failed to load NationalIncomeManager |
| TimeManager.game_day_advanced a EventManager | MUERTA (autoload no carga) | EventManager.gd:1 |
| TimeManager.game_day_advanced a AIManager | MUERTA (autoload no carga) | AIManager.gd:1 |
| Clic en mapa a UnitMovementSystem | ACTIVA | MapRenderer.gd _unhandled_input |
| UnitMovementSystem.move_completed a BattleManager | ACTIVA (verificada headless) | BattleManager.gd _ready |
| BattleManager.battle_resolved a BattleResultPopup | ROTA HOY (popup no parsea) | BattleResultPopup.gd:42-43 |
| BattleManager.province_captured a MapRenderer/TopInfoBar/VictoryConditions | CONECTADA | VictoryConditions.gd:64, MapRenderer.gd:187, TopInfoBar.gd:64 |
| VictoryConditions.victory_achieved a TopInfoBar / VictoryScreen | PARCIAL (VictoryScreen no parsea) | TopInfoBar.gd:61; VictoryScreen.gd:24 |
| MapManager.province_selected / province_hovered | SENAL NUNCA EMITIDA | scan mecanico: 0 emisiones |
| starting_forces (escenario) a despliegue de unidades | NO EXISTE CONSUMIDOR | scan: clave no leida en ningun .gd |
| NationalIncomeManager._ai_income a gasto de la IA | SIN CONSUMIDOR | AIManager no la lee |

## Senales emitidas sin listener (45) - backend sin UI

- `scripts/agents/AgentManager.gd` emite `agent_recruited` y nadie escucha
- `scripts/agents/AgentManager.gd` emite `agent_assigned_to_mission` y nadie escucha
- `scripts/agents/AgentManager.gd` emite `mission_completed` y nadie escucha
- `scripts/agents/AgentManager.gd` emite `agent_captured` y nadie escucha
- `scripts/agents/AgentManager.gd` emite `agent_killed` y nadie escucha
- `scripts/autoload/ProductionManager.gd` emite `line_registered` y nadie escucha
- `scripts/autoload/ProductionManager.gd` emite `line_removed` y nadie escucha
- `scripts/autoload/ProductionManager.gd` emite `stance_changed` y nadie escucha
- `scripts/autoload/ProductionManager.gd` emite `modifier_registered` y nadie escucha
- `scripts/autoload/ProductionManager.gd` emite `modifier_removed` y nadie escucha
- `scripts/autoload/ProductionManager.gd` emite `family_experience_changed` y nadie escucha
- `scripts/autoload/ProductionManager.gd` emite `production_progress_updated` y nadie escucha
- `scripts/autoload/ProductionManager.gd` emite `production_resource_shortage` y nadie escucha
- `scripts/autoload/ProductionManager.gd` emite `equipment_added_to_stockpile` y nadie escucha
- `scripts/autoload/ProductionManager.gd` emite `equipment_taken_from_stockpile` y nadie escucha
- `scripts/autoload/ProductionManager.gd` emite `unit_reinforced` y nadie escucha
- `scripts/events/EventManager.gd` emite `event_effect_applied` y nadie escucha
- `scripts/leaders/LeaderManager.gd` emite `leader_retired` y nadie escucha
- `scripts/leaders/LeaderManager.gd` emite `leader_experience_gained` y nadie escucha
- `scripts/map/MapManager.gd` emite `scenario_map_ready` y nadie escucha
- `scripts/map/MapManager.gd` emite `provinces_loaded` y nadie escucha
- `scripts/map/MapManager.gd` emite `province_owner_changed` y nadie escucha
- `scripts/military/UnitMovementSystem.gd` emite `move_order_issued` y nadie escucha
- `scripts/national/NationalSpiritManager.gd` emite `spirits_initialized` y nadie escucha
- `scripts/national/TradeManager.gd` emite `offer_created` y nadie escucha
- `scripts/national/TradeManager.gd` emite `deal_accepted` y nadie escucha
- `scripts/national/TradeManager.gd` emite `deal_rejected` y nadie escucha
- `scripts/national/TradeManager.gd` emite `offer_expired` y nadie escucha
- `scripts/production/FactoryManager.gd` emite `factory_captured` y nadie escucha
- `scripts/production/FactoryManager.gd` emite `factory_repaired` y nadie escucha
- `scripts/production/FactoryManager.gd` emite `factory_damaged` y nadie escucha
- `scripts/production/ProductionLine.gd` emite `template_changed` y nadie escucha
- `scripts/production/ProductionLine.gd` emite `refinement_started` y nadie escucha
- `scripts/production/ProductionLine.gd` emite `refinement_completed` y nadie escucha
- `scripts/supply/SupplyManager.gd` emite `network_rebuilt` y nadie escucha
- `scripts/supply/SupplyManager.gd` emite `route_updated` y nadie escucha
- `scripts/supply/SupplyManager.gd` emite `overlay_toggled` y nadie escucha
- `scripts/supply/SupplyManager.gd` emite `depot_stock_changed` y nadie escucha
- `scripts/technology/TechnologyManager.gd` emite `research_started` y nadie escucha
- `scripts/technology/TechnologyManager.gd` emite `technology_unlocked` y nadie escucha
- `scripts/ui/FormationPickerPopup.gd` emite `formation_assigned` y nadie escucha
- `scripts/ui/LeaderEventUI.gd` emite `news_posted` y nadie escucha
- `scripts/ui/LeaderPickerPopup.gd` emite `leader_selected` y nadie escucha
- `scripts/ui/MissionPickerPopup.gd` emite `mission_assigned` y nadie escucha
- `scripts/ui/NationSelectScreen.gd` emite `nation_selected` y nadie escucha

## Senales declaradas nunca emitidas (5)

- `scripts/leaders/LeaderManager.gd` declara `trait_leveled` (linea 13) y nunca la emite
- `scripts/leaders/LeaderManager.gd` declara `training_path_invested` (linea 14) y nunca la emite
- `scripts/leaders/LeaderManager.gd` declara `training_path_switched` (linea 15) y nunca la emite
- `scripts/map/MapManager.gd` declara `province_hovered` (linea 24) y nunca la emite
- `scripts/map/MapManager.gd` declara `province_selected` (linea 25) y nunca la emite
