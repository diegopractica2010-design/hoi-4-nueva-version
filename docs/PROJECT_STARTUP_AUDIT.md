# Auditoría de Arranque del Proyecto

Ejecución real con **Godot 4.6 (headless)**. Se capturó toda la salida del motor
(errores, avisos y trazas) durante el arranque y la inicialización de autoloads.

## Secuencia de arranque observada

1. Reescaneo/recarga de scripts (fase de compilación).
2. Instanciación de autoloads en el orden de `project.godot`.
3. Carga de datos base por varios managers:
   - `Equipment modules loaded: 1082`
   - `Unit templates loaded: 1022`
   - `Sustainment equipment loaded: 4`
   - `Production line rules loaded`
   - `Loaded 68 leaders (25 in pool) ... year 1936`
   - `TimeManager: Initialized (default 1936-01-01)`
   - `AgentManager: Loaded 11 mission definitions`
   - `TechnologyManager: Loaded 23 technology nodes`
   - `SaveLoadManager: Initialized (JSON format v1, user://saves/)`

## Errores de arranque (críticos)

| # | Script | Línea | Error |
|---|--------|-------|-------|
| 1 | `scripts/production/DesignManager.gd` | 417 | Parse Error: se esperaba `)` tras los argumentos de la llamada |
| 2 | `scripts/national/TradeManager.gd` | 412, 502, 503, 559, 1168, 1181 | Parse Error: no se puede inferir el tipo de variable con `:=` |
| 3 | `scripts/map/ProvinceInsight.gd` | 1469, 1471 | Parse Error: no se puede asignar `Color` a `String` |

Consecuencia directa:

- `ERROR: Failed to instantiate an autoload, script 'DesignManager.gd' does not
  inherit from 'Node'` → **autoload `DesignManager` NO se instancia.**
- `ERROR: Failed to instantiate an autoload, script 'TradeManager.gd' does not
  inherit from 'Node'` → **autoload `TradeManager` NO se instancia.**

## Errores en cascada (durante la recarga)

El error de sintaxis de `DesignManager.gd` propaga `Compile Error: Failed to
compile depended scripts` a una docena de scripts que dependen de él vía
`class_name`/tipos: `FactoryManager`, `MapTechnologyContext`, `TechnologyManager`,
`NationalModifierManager`, `NationalSpiritManager`, `ProvinceEffects`,
`SupplyManager`, `LeaderManager`, `TimeManager`, `ProductionManager`, `GameData`.

> Importante: la mayoría de esos autoloads **sí terminó presente en runtime** (ver
> `docs/AUTOLOAD_AUDIT.md`). Los errores en cascada aparecen en la fase de recarga,
> pero solo `DesignManager` y `TradeManager` quedaron realmente caídos.

## Avisos de arranque

- `WARNING: TechnologyManager: No starting tech file for scenario '1879', using
  minimal defaults` (al cargar escenario).
- `WARNING: ObjectDB instances leaked at exit`.
- `ERROR: 3 resources still in use at exit`.

## Recursos / scripts / escenas

- No se detectaron escenas faltantes en este arranque.
- Recurso con UID inválido detectado durante import:
  `WorldMap.tscn:3 - ext_resource, invalid UID: uid://c6uhgynax25qv` (se resuelve
  por ruta de texto, pero indica un UID roto).
- Geometría de provincias: `Province geometry loaded: 100` frente a
  `Base provinces loaded: 840` → cobertura de geometría parcial.

## Conclusión

El proyecto **arranca**, pero con **dos autoloads caídos** (`DesignManager`,
`TradeManager`) por errores de sintaxis/tipos, además de un script de mapa roto
(`ProvinceInsight`). El resto del arranque es funcional y la mayoría de sistemas
inicializa correctamente.
