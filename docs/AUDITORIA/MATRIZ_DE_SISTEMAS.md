# Matriz de sistemas (estado real verificado, Fase 3)

Clasificación: EXISTE / PARCIAL / NO USADO / DESCONECTADO / FUNCIONA / INTEGRADO / LISTO-PROD.
"Hoy" = estado en el arranque capturado en `_boot_actual.log` (2026-06-12).

| Sistema | Archivo principal (líneas) | Estado | Evidencia | Hallazgos |
|---|---|---|---|---|
| Calendario (TimeManager) | scripts/autoload/TimeManager.gd (281) | INTEGRADO·FUNCIONA | señales día/mes/año consumidas por 8+ sistemas | H-0031 |
| Carga de escenario (ScenarioLoader+4 aux) | scripts/core/ScenarioLoader.gd (545) | INTEGRADO·FUNCIONA | 1879 carga 847 prov/9 países (runtime) | H-0007 |
| Mapa (MapManager) | scripts/map/MapManager.gd (~830) | INTEGRADO·FUNCIONA | autoridad central, picking, owner API | H-0022 |
| Render de mapa (MapRenderer) | scripts/map/MapRenderer.gd (~2300) | FUNCIONA | 107 polígonos, overlays, iconos unidad | H-0008 |
| Movimiento de unidades | scripts/military/UnitMovementSystem.gd | FUNCIONA·INTEGRADO | verificado headless (selección/mover/rechazo) | H-0006 |
| Batallas (BattleManager) | scripts/military/BattleManager.gd | FUNCIONA·INTEGRADO | batalla real verificada headless | H-0024, H-0025 |
| Condiciones de victoria | scripts/core/VictoryConditions.gd | FUNCIONA | 5 condiciones, chequeo diario | H-0005 (UI rota) |
| Ingreso nacional | scripts/national/NationalIncomeManager.gd | **ROTO HOY** (cascada) | verificado antes: +291 oro CHL/mes | H-0003, H-0012 |
| Eventos (EventManager) | scripts/events/EventManager.gd (226) | **EXISTE·MUERTO** (no carga) | 7 efectos implementados; autoload falla | H-0001 |
| IA (AIManager) | scripts/ai/AIManager.gd (491) | **EXISTE·MUERTO** (no carga) | objetivos+órdenes escritos; autoload falla | H-0002 |
| Guardado/carga (SaveLoadManager) | scripts/autoload/SaveLoadManager.gd (~800) | **ROTO HOY** (cascada) | 13 secciones serializadas | H-0003, H-0009, H-0023 |
| Producción (ProductionManager) | scripts/autoload/ProductionManager.gd | FUNCIONA·SUB-INTEGRADO | stockpile único (jugador); 9 señales sin UI | H-0012, H-0021 |
| Fábricas (FactoryManager) | scripts/production/FactoryManager.gd | INTEGRADO | captura por provincia conectada a batallas | H-0015 |
| Diseños (DesignManager) | scripts/production/DesignManager.gd | FUNCIONA | reparado en Fase 4; conectado al año | — |
| Suministro (SupplyManager) | scripts/supply/SupplyManager.gd | FUNCIONA·PARCIAL | depósitos/sabotaje; integración combate en transición | — |
| Líderes (LeaderManager) | scripts/leaders/LeaderManager.gd (2700+) | FUNCIONA·MONOLITO | 16 líderes 1879; demasiadas responsabilidades | H-0009, H-0030 |
| Agentes/espionaje (AgentManager) | scripts/agents/AgentManager.gd | FUNCIONA·SIN UI | 5 señales sin listener | H-0021 |
| Tecnología (TechnologyManager) | scripts/technology/TechnologyManager.gd | FUNCIONA | starting tech 1879 aplicada (9 países) | H-0019 |
| Comercio (TradeManager) | scripts/national/TradeManager.gd | FUNCIONA (reparado en sesión) | 5 errores de tipo corregidos | — |
| Modificadores nacionales | scripts/national/NationalModifierManager.gd | INTEGRADO | usado por mapa/combate/eventos | H-0027 |
| Espíritus nacionales | scripts/national/NationalSpiritManager.gd | EXISTE·POCO USADO | consumidor principal sería EventManager (muerto) | H-0001 |
| Localización (4 autoloads) | scripts/localization/* | EXISTE·NO ADOPTADO | infra completa; UI no la usa | H-0013 |
| Selección de nación | scripts/ui/NationSelectScreen.gd | FUNCIONA·INTEGRADO | redirección verificada en runtime | — |
| UI barra superior (TopInfoBar) | scripts/ui/TopInfoBar.gd | FUNCIONA·PARCIAL | menú con TODO; textos EN/ES mezclados | H-0020, H-0013 |
| Popup resultado batalla | scripts/ui/BattleResultPopup.gd | **ROTO HOY** (no parsea) | líneas 42-43 | H-0004 |
| Pantalla de victoria | scripts/ui/VictoryScreen.gd | **ROTO HOY** (no parsea) | línea 24 | H-0005 |
| Validador de mapa | scripts/map/MapDataValidator.gd | EXISTE·NO USADO | 0 referencias | H-0017 |
| Tests headless (3) | scripts/core/Headless*.gd | EXISTEN·HUÉRFANOS | sin runner | H-0016 |
| Spawner fábricas legado | scripts/scenarios/ScenarioFactorySpawner.gd | NO USADO (paralelo) | 0 referencias | H-0015 |

## Lectura global
- **Listo para producción:** ninguno (faltan tests automatizados y arranque estable sostenido).
- **Núcleo sano y verificado:** calendario, escenario, mapa, movimiento, batalla, victoria, producción, líderes.
- **Escritos pero muertos hoy:** eventos, IA, guardado, ingresos, popups de batalla/victoria — todos por 2 líneas (`class_name`) + 3 líneas (`:=`).
