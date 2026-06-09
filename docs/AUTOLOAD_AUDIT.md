# Auditoría de Autoloads

Inspección en runtime (Godot 4.6 headless) de los 19 autoloads registrados en
`project.godot`.

## Orden de autoloads (project.godot)

| # | Autoload | Presente en runtime |
|---|----------|---------------------|
| 1 | GameData | SÍ |
| 2 | FactoryManager | SÍ |
| 3 | ProductionManager | SÍ |
| 4 | DesignManager | **NO** |
| 5 | SupplyManager | SÍ |
| 6 | LeaderManager | SÍ |
| 7 | TimeManager | SÍ |
| 8 | LeaderEventUI | SÍ |
| 9 | AgentManager | SÍ |
| 10 | NationalModifierManager | SÍ |
| 11 | NationalSpiritManager | SÍ |
| 12 | TradeManager | **NO** |
| 13 | MapManager | SÍ |
| 14 | TechnologyManager | SÍ |
| 15 | SaveLoadManager | SÍ |
| 16 | LocalizationSettings | SÍ |
| 17 | LanguageManager | SÍ |
| 18 | TranslationProvider | SÍ |
| 19 | Localization | SÍ |

Resultado: **17/19 presentes**. Ausentes: `DesignManager`, `TradeManager`.

## Orden de inicialización

Godot instancia los autoloads en el orden de la lista. El orden actual coloca
`FactoryManager` (#2) **antes** que `DesignManager` (#4), pese a que la producción
de diseños conceptualmente depende de `DesignManager`. Aunque `FactoryManager`
queda presente, esta inversión de orden es un riesgo de integración (ver más
abajo).

Los autoloads de localización (#16–#19) están al final, en orden correcto respecto
a sus dependencias internas.

## Dependencias en runtime

- `DesignManager` ← usado por `FactoryManager` y la cadena de producción.
- `TradeManager` ← usado por sistemas nacionales/diplomáticos.
- `TimeManager` ← inicializado por `ScenarioLoader` al cargar escenario.
- `MapManager` ← inicializado por `ScenarioLoader` con los datos de mapa.
- Localización (`Localization` → `LanguageManager`/`TranslationProvider` →
  `LocalizationSettings`): cadena interna correcta y aislada del resto.

## Dependencias circulares

No se detectaron dependencias circulares directas en runtime. El riesgo principal
no es circularidad sino **acoplamiento por cascada de compilación** (un script roto
arrastra a sus dependientes en la fase de recarga).

## Conflictos de nombres

- Localización: **resueltos** (se eliminó `class_name` de los 4 singletons; no hay
  colisión con los nombres de autoload).
- No se observaron nuevos conflictos `class_name` vs autoload en runtime.

## Dependencias inseguras

1. **`FactoryManager` presente con `DesignManager` ausente**: `FactoryManager`
   cargó, pero cualquier llamada en runtime a `DesignManager` (autoload ausente)
   provocará referencia nula. Riesgo alto en el flujo de diseño/producción.
2. **Orden #2 antes de #4**: `FactoryManager` se inicializa antes que
   `DesignManager`; si `FactoryManager` consultara `DesignManager` en su `_ready`,
   fallaría incluso con `DesignManager` sano.
3. **Inicialización dependiente de escenario**: `TimeManager` y `MapManager` quedan
   en estado por defecto hasta que `ScenarioLoader` los inicializa; sistemas que
   los usen antes de cargar escenario verán estado por defecto (p. ej. fecha
   1936-01-01).

## Conclusión

La mayoría de autoloads inicializa. Los dos ausentes (`DesignManager`,
`TradeManager`) se deben a errores de código y bloquean la producción de diseños y
el sistema de comercio. El acoplamiento por cascada y el orden de inicialización
son los riesgos arquitectónicos a vigilar.
