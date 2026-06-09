# Auditoría Runtime del Escenario 1879

Validación real con **Godot 4.6 (headless)**: se instanció `ScenarioLoader`, se
ejecutó su `_ready()` (geometría + capas + provincias base) y luego
`load_scenario("1879")`.

## Resultados

| Pregunta | Resultado | Evidencia |
|----------|-----------|-----------|
| ¿Carga correctamente? | **SÍ** | `load_scenario('1879') ok=true` |
| ¿Provincias cargadas? | **SÍ — 840** | `Provinces: 840` |
| ¿Países cargados? | **SÍ — 9** | `Countries: 9` (ARG, BOL, BRA, CHL, ENG, FRA, GER, PER, USA) |
| ¿Líderes cargados? | **SÍ — 16** | `16 active, 0 pooled` (`historical_leaders_1879.json`) |
| ¿Fábricas cargadas? | **SÍ — 76 + 3 astilleros** | `1879 — 76 factories, 3 shipyards across 13 province entries` |
| ¿Tecnologías cargadas? | **PARCIAL (fallback)** | sin archivo de tech para 1879; aplica defaults mínimos a 9 países |
| ¿Suministro inicializado? | **NO confirmado** | `SupplyManager` presente, sin inicialización explícita de hubs en el log |
| ¿Mapa inicializado? | **SÍ** | `MapManager initialized with 840 provinces`; `MapPickGrid 840 provinces, 90 cells` |
| ¿Avisos en runtime? | **SÍ** | "No starting tech file for scenario '1879'" |
| ¿Errores en runtime? | **NO durante la carga** | la carga del escenario no produjo errores propios |
| ¿Comportamiento de fallback? | **SÍ** | tecnología cae a defaults mínimos cuando falta el archivo |

## Detalle relevante

- **Provincias base:** se cargaron 840 provincias base; los overrides del escenario
  aplican correctamente (capitales de GER, FRA, ENG con puerto, USA).
- **Geometría parcial:** `Province geometry loaded: 100` frente a 840 provincias →
  **740 provincias sin geometría**. La carga lógica funciona, pero la cobertura
  visual del mapa es incompleta.
- **Formaciones de prueba:** el log muestra `Spawned 4 test formations for <país>`
  para los 9 países. Es código de prueba/relleno en la ruta de carga del escenario,
  no contenido histórico real.
- **Fecha:** `TimeManager: Scenario start date set to 1879-02-14 (year 1879)` — la
  fecha del escenario se aplica correctamente por encima del default 1936-01-01.
- **Tecnología 1879:** no existe archivo de tecnología inicial para 1879; el sistema
  no falla, aplica un conjunto mínimo por defecto (fallback correcto, pero sin
  contenido histórico de la época).

## Sistemas dependientes (estado tras la carga)

| Sistema | Estado |
|---------|--------|
| LeaderManager | presente, con datos de líderes |
| FactoryManager | presente (pero `DesignManager` ausente → riesgo en diseño) |
| TechnologyManager | presente, con fallback de tech |
| SupplyManager | presente, inicialización de suministro no verificada |
| MapManager | presente e inicializado con 840 provincias |

## Conclusión

El escenario 1879 **se carga con éxito** pese a que `DesignManager` y `TradeManager`
están caídos: la carga de provincias, países, líderes, fábricas, formaciones, fecha
y mapa funciona. Las limitaciones son: tecnología por fallback (sin archivo 1879),
geometría parcial (100/840) y formaciones de prueba en lugar de contenido real. El
suministro no pudo confirmarse como inicializado en esta corrida.
