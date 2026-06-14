# Matriz de duplicidad de carpetas

Fecha: 2026-06-12

| Metrica | epochs-of-ascendancy | hoi-4-nueva-version |
|---|---|---|
| Archivos | 2459 | 2608 |
| Modificacion mas reciente | 2026-05-27 00:32 | 2026-06-11 23:22 |
| Repositorio git | NO | SI (origin=GitHub) |

## Veredicto

**hoi-4-nueva-version es la version VIVA** (git activo, modificaciones recientes, escenario 1879, 847 provincias).
**epochs-of-ascendancy es residual** (sin git, ultima actividad 2026-05-27 00:32).

## Comparacion archivo a archivo

- Solo en epochs-of-ascendancy: **0**
- Solo en hoi-4-nueva-version: **149**
- En ambas, identicos (hash): **2433**
- En ambas, DIVERGENTES: **26**
  - mas nuevos en epochs: 0
  - mas nuevos en hoi-4: 26

## Archivos divergentes donde EPOCHS es mas nuevo (posible trabajo en riesgo)

(ninguno)

## Archivos divergentes (hoi-4 mas nuevo) — primeros 60

- `.gitignore`
- `README.md`
- `data/provinces/province_adjacency.json`
- `data/provinces/province_city_layer.json`
- `data/provinces/province_economy_layer.json`
- `data/provinces/province_resources_layer.json`
- `data/provinces/province_states.json`
- `data/provinces/province_terrain_layer.json`
- `data/provinces/provinces_base.json`
- `data/provinces/provinces_geometry.json`
- `data/provinces/strategic_regions.json`
- `project.godot`
- `scenes/TestScenario.tscn`
- `scenes/ui/TopInfoBar.tscn`
- `scripts/autoload/SaveLoadManager.gd`
- `scripts/core/ScenarioLoader.gd`
- `scripts/core/TestRunner.gd`
- `scripts/formations/Formation.gd`
- `scripts/map/MapManager.gd`
- `scripts/map/MapRenderer.gd`
- `scripts/map/ProvinceInsight.gd`
- `scripts/national/TradeManager.gd`
- `scripts/production/DesignManager.gd`
- `scripts/scenarios/ScenarioFactorySpawner.gd`
- `scripts/ui/MainMenu.gd`
- `scripts/ui/TopInfoBar.gd`

## Contenido SOLO en epochs-of-ascendancy (codigo/datos/escenas/docs): 0 archivos


## Recomendacion de consolidacion segura

1. NO borrar epochs-of-ascendancy todavia.
2. Revisar la lista 'epochs mas nuevo' y la lista 'solo en epochs' (arriba) y portar lo valioso a hoi-4-nueva-version.
3. Crear una rama/tag de respaldo: comprimir epochs-of-ascendancy a un zip de archivo historico fuera del repo.
4. Tras portar y verificar arranque, eliminar la carpeta residual del disco (no esta en git, no afecta al repositorio).
