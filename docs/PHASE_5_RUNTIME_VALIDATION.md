# Validacion runtime Fase 5

## Alcance

Validacion de la refactorizacion de arquitectura de escenarios, con foco en carga de escenario, integracion de paises, compatibilidad de managers y datos 1879.

## Resultado ejecutivo

La validacion estatica de datos paso. La validacion runtime con Godot no pudo ejecutarse porque el entorno no tiene binario `godot`, `godot4`, `godot4.6` ni `godot_console` disponible en PATH.

## Validacion de arranque

Estado: no ejecutada.

Causa: no hay ejecutable Godot disponible en el entorno local.

Impacto: no se puede certificar arranque real del proyecto desde esta terminal.

Recomendacion: ejecutar arranque headless en un entorno con Godot instalado antes de abrir nuevas fases de gameplay.

## Validacion de carga de escenario

Estado: validacion estatica exitosa.

Comprobaciones realizadas:

- `data/scenarios/1879.json` parsea como JSON valido.
- `data/scenarios/1879/manifest.json` parsea como JSON valido.
- `data/scenarios/1879/scenario.json` parsea como JSON valido.
- `data/scenarios/1879.json` redirige a `res://data/scenarios/1879/scenario.json`.
- `data/scenarios/1879/manifest.json` declara `loader_entry` hacia `res://data/scenarios/1879/scenario.json`.
- `data/scenarios/1879/scenario.json` usa `country_refs`.
- `data/scenarios/1879/scenario.json` no duplica bloque runtime `countries`.

Resultado: OK en validacion estatica.

## Validacion de paises

Estado: validacion estatica exitosa.

Paises cargables desde `country_refs`:

- `CHL`
- `PER`
- `BOL`
- `ARG`
- `BRA`
- `USA`
- `ENG`
- `FRA`
- `GER`

Paises jugables validados:

- `CHL`
- `PER`
- `BOL`

Resultado: OK en validacion estatica.

## Validacion de fabricas

Estado: compatibilidad estatica revisada.

`ScenarioFactoryBootstrap` consume los paises ya resueltos por `ScenarioCountryRuntime` y mantiene los campos que necesita la ruta de fabricas:

- `key_provinces`
- `industrial_weight`
- `major_power`
- `naval_power`
- `tag`

Limitacion: no se pudo confirmar generacion real dentro del motor.

## Validacion de lideres

Estado: compatibilidad estatica revisada.

`ScenarioLoader` mantiene la llamada:

- `LeaderManager.load_leaders_for_scenario(scenario_name, start_year)`

Limitacion: no se pudo confirmar carga real dentro del motor.

## Validacion de tecnologia

Estado: compatibilidad estatica revisada.

`ScenarioLoader` mantiene la llamada:

- `TechnologyManager.apply_scenario_starting_tech(scenario_name, tags, start_year)`

Los tags se derivan desde `countries.keys()` despues de resolver `data/countries`.

Limitacion: no se pudo confirmar aplicacion real dentro del motor.

## Validacion de MapManager

Estado: compatibilidad estatica revisada.

`ScenarioLoader` mantiene:

- `get_map_data()`
- `MapScenarioData.new(provinces, build_geometry_dict_for_map(), adjacency_system, countries)`
- `MapManager.initialize_from_map_data(map_data)`

Limitacion: no se pudo confirmar render ni inicializacion real dentro del motor.

## Validacion de ProductionManager

Estado: compatibilidad estatica revisada.

`ScenarioLoader` mantiene limpieza de caches mediante:

- `ProductionManager.clear_all_caches()`

Limitacion: no se pudo confirmar flujo real dentro del motor.

## Integridad de datos

Resultados:

- Errores JSON: 0.
- Tags de pais duplicados en `data/countries`: 0.
- Provincias duplicadas en `data/scenarios/1879/scenario.json`: 0.
- `country_refs` duplicados en 1879: 0.

Observacion: el identificador `1879` aparece en `manifest.json`, `scenario.json` y `1879.json`. Esto se considera metadata de paquete/redireccion y no una duplicacion de payload runtime, porque solo `scenario.json` contiene los datos autoritativos del escenario.

## Errores encontrados

No se encontraron errores en validacion estatica.

## Advertencias encontradas

- Validacion runtime real no ejecutada por ausencia de Godot en PATH.
- El ID `1879` aparece en tres archivos de soporte del paquete modular; debe mantenerse documentado como paquete, payload y redireccion legacy.

## Limitaciones conocidas

- Sin ejecucion del motor no se certifican errores de GDScript, autoloads ni secuencia real de arranque.
- La compatibilidad con managers fue revisada por contrato y llamadas existentes, no por ejecucion integrada.

