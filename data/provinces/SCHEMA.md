# Province Data Schema

All layer files are keyed by stable `province_id` values.

## `provinces_base.json`
- `provinces`: array
  - `id`: int
  - `name`: string
  - `terrain`: string
  - `core_for_tags`: string[]
  - `natural_resources`: dictionary
  - `population_base`: int
  - `special_features`: string[]
  - `special_levels`: dictionary

## `provinces_geometry.json`
- `meta`:
  - `version`: int
  - `map_texture`: string
  - `texture_size`: [int, int]
  - `coordinate_space`: `background_pixels`
  - `target_province_count`: int
- `provinces`: array
  - `id`: int
  - `name`: string
  - `points`: `[x, y][]` (>=3 points, map pixel coordinates)
  - `label_anchor`: `[x, y]`

## `province_adjacency.json`
- `version`: int
- `adjacency`: object `{ "<province_id>": int[] }`

## `province_terrain_layer.json`
- `version`: int
- `provinces`: object `{ "<province_id>": { terrain, movement_cost, combat_modifier } }`

## `province_city_layer.json`
- `version`: int
- `provinces`: object `{ "<province_id>": { cities: City[] } }`
  - `City`:
    - `id`: string
    - `name`: string
    - `position`: `[x, y]` in map pixel coordinates
    - `population`: int
    - `port_level`: int
    - `airport_level`: int
    - `industry_slots`: int

## `province_resources_layer.json`
- `version`: int
- `provinces`: object `{ "<province_id>": { resources, resource_score, primary_resource } }`

## `province_economy_layer.json`
- `version`: int
- `provinces`: object `{ "<province_id>": { population, factories, infrastructure, development_level, resources } }`

## `province_states.json`
- `version`: int
- `states`: array
  - `id`: int
  - `name`: string
  - `province_ids`: int[]
  - `supply_hub_province_id`: int

## `strategic_regions.json`
- `version`: int
- `regions`: array
  - `id`: int
  - `name`: string
  - `province_ids`: int[]

## `project_sites.json`
- `version`: int
- `sites`: array
  - `province_id`: int
  - `project_type`: string
  - `max_level`: int
