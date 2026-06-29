# Ledger congelado de 25 hallazgos

Línea base: `68f36ef` + working tree existente al iniciar la certificación.  
Estados permitidos: `PENDING`, `PASS`, `FIXED`, `NOT_REPRODUCIBLE`.

| ID | Severidad | Hallazgo / validación de cierre | Estado |
|---|---|---|---|
| 01 | Crítica | Importación y parser del estado actual terminan sin errores. | FIXED |
| 02 | Crítica | Las 28 escenas y todos sus recursos cargan sin referencias rotas. | FIXED |
| 03 | Crítica | La escena principal arranca y sale limpiamente en headless. | FIXED |
| 04 | Crítica | ProductionManager conserva acceso válido y lazy a FactoryManager. | FIXED |
| 05 | Crítica | AIManager recibe el estado de guerra sin depender de un `/root/ScenarioLoader` inexistente. | FIXED |
| 06 | Crítica | ScenarioLoader rechaza fechas inválidas sin dejar estado parcial. | FIXED |
| 07 | Crítica | TestRunner puede ejecutarse sin navegación UI ni bloqueo indefinido. | PENDING |
| 08 | Alta | Los 25 autoloads inicializan en orden y exponen su API mínima. | PENDING |
| 09 | Alta | WorldMap y TestScenario no emiten UID inválido. | PASS |
| 10 | Alta | El plugin exportador no rompe editor/importación headless. | PENDING |
| 11 | Crítica | Save→load preserva un hash canónico del estado 1879. | PENDING |
| 12 | Crítica | Saves inválidos o de versión anterior fallan/migran sin corrupción. | PENDING |
| 13 | Alta | TradeManager carga y ejecuta ofertas sin errores de inferencia/tipo. | PENDING |
| 14 | Alta | BattleManager resuelve combate y bajas sin referencias nulas. | PENDING |
| 15 | Alta | VictoryConditions termina una campaña y no duplica señales. | PENDING |
| 16 | Crítica | AIManager produce actividad y no queda paralizado durante 50 turnos. | PENDING |
| 17 | Alta | SupplyManager avanza sin ciclos infinitos ni estado inválido. | PENDING |
| 18 | Alta | La eliminación de 549 perfiles AI legacy no deja consumidores vivos. | PASS |
| 19 | Alta | ES/EN tienen paridad, fallback e interpolación válidos. | PENDING |
| 20 | Alta | El runner QA acepta suite, test, seed, turn-limit y reporte JSON. | PENDING |
| 21 | Crítica | ProvinceInsight queda como fachada compatible <1.000 líneas, con módulos <800. | PENDING |
| 22 | Crítica | LeaderManager queda como fachada/autoload compatible <1.000 líneas, con módulos <800. | PENDING |
| 23 | Crítica | MapRenderer queda como fachada Node2D compatible <1.000 líneas, con módulos <800. | PENDING |
| 24 | Alta | Instrumentación mide startup/save/load/ticks/combate/memoria contra presupuestos. | PENDING |
| 25 | Alta | Windows exporta/arranca y Android genera APK debug reproducible para emulador. | PENDING |

Cada fila se cerrará individualmente con comando, log, prueba y referencia al cambio. No se inventará una corrección si el problema no es reproducible.
