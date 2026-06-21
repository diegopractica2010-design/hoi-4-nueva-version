# Caché de archivos — Fase 0

Este índice evita relecturas globales entre las fases 1 y 8.

| Ruta / grupo | Propósito | Dependencias / API | Riesgo conocido |
|---|---|---|---|
| project.godot | Configuración y 25 autoloads | Escena principal y orden global | Orden implícito |
| scenes/ui/StartMenu.tscn | Entrada de usuario | StartMenu.gd | Startup Windows/Android |
| scenes/TestScenario.tscn | Composición runtime 1879 | TestRunner, ScenarioLoader, WorldMap | Mezcla QA y gameplay |
| scripts/core/ScenarioLoader.gd | Carga autoritativa | DataResolver, ProvinceApplier, managers | Alto impacto |
| scripts/autoload/SaveLoadManager.gd | Persistencia | Todos los subsistemas con estado | Corrupción/versionado |
| scripts/ai/AIManager.gd | Decisiones IA | Scenario/Map/Combat/Economy | Deadlock/parálisis |
| scripts/supply/ | Red y tick de suministro | Map, formations, technology | Pathfinder/memoria |
| scripts/map/ProvinceInsight.gd | Consultas y texto provincial | MapManager y autoloads | 3.480 líneas |
| scripts/leaders/LeaderManager.gd | Roster, traits, training y lifecycle | Time, combat, saves | 2.944 líneas |
| scripts/map/MapRenderer.gd | Render, input y overlays | MapManager, supply, battle | 2.110 líneas y `_process` |
| scripts/core/*Test.gd | Pruebas heredadas | Production/Supply | No seleccionables |
| data/scenarios/1879/ | Fuente runtime principal | countries, provinces, leaders | Integridad histórica |
| data/localization/ | Diccionarios ES/EN | Localization facade | 36 claves por idioma |
| export_presets.cfg | Windows y Android | Templates/SDK externos | Android no instalado |

Releer un archivo completo solo si fue modificado, cambió una dependencia o un fallo lo implica. Para los tres monolitos usar búsqueda por símbolo y rangos dirigidos.
