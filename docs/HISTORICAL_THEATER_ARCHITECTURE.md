# Arquitectura del Teatro Histórico — Fase 6

**Fecha:** 2026-06-09
**Track:** A (Claude)
**Teatro objetivo:** Guerra del Pacífico, 1879–1884
**Alcance:** preparar la arquitectura del mapa para futuras provincias históricas. Esta fase **no** crea provincias históricas; garantiza que añadirlas no genere deuda técnica.

---

## 1. Propiedad de cada sistema (Tarea 1)

Quién es la "fuente de verdad" de cada pieza del mapa.

| Concepto | Fuente de verdad (datos) | Cargador | Autoridad en runtime |
|---|---|---|---|
| **Provincias (identidad)** | `data/provinces/provinces_base.json` | `ScenarioLoader.load_base_provinces()` | `MapManager` (consultas) |
| **Geometría (polígonos)** | `data/provinces/provinces_geometry.json` | `ScenarioLoader.load_province_geometry()` | `MapManager._geometry` + `MapRenderer` (dibujo) |
| **Adyacencia** | `data/provinces/province_adjacency.json` | `ScenarioLoader._load_adjacency_layer()` → `AdjacencySystem` | `MapManager.get_adjacent_provinces()` (delega en `AdjacencySystem`) |
| **Estados** | `data/provinces/province_states.json` | `ScenarioLoader._load_state_and_region_layers()` | ⚠️ solo en `ScenarioLoader` (no expuesto) |
| **Regiones estratégicas** | `data/provinces/strategic_regions.json` | `ScenarioLoader._load_state_and_region_layers()` | ⚠️ solo en `ScenarioLoader` (no expuesto) |
| **Capas (terreno/ciudad/economía/recursos)** | `data/provinces/province_*_layer.json` | `ScenarioLoader._apply_layer_data_to_province()` | Atributos en `Province` |
| **Escenario (overrides 1879)** | `data/scenarios/1879/` (paquete) | `ScenarioDataResolver` + `ScenarioProvinceApplier` | `MapManager` tras `load_scenario()` |
| **Países** | `data/countries/*.json` (referenciados por `country_refs`) | `ScenarioCountryRuntime` | `MapManager._countries` |
| **Propiedad de provincia (owner/controller)** | base + overrides de escenario | `ScenarioProvinceApplier` | `MapManager.update_province_owner()` |
| **Sitios de proyecto** | `data/provinces/project_sites.json` | `ScenarioLoader._load_project_sites_layer()` | `ScenarioLoader.province_projects_by_id` |

---

## 2. Flujo de carga del mapa (runtime)

```
ScenarioLoader._ready()
  ├─ load_province_geometry()        (polígonos)
  ├─ load_province_layers()          (adyacencia, terreno, ciudad, economía, recursos, estados, regiones, sitios)
  └─ load_base_provinces()           (crea objetos Province base)

ScenarioLoader.load_scenario("1879")
  ├─ ScenarioDataResolver            (resuelve el paquete del escenario → datos)
  ├─ ScenarioCountryRuntime          (resuelve country_refs → registro de países)
  ├─ duplica provincias base
  ├─ ScenarioProvinceApplier         (aplica overrides del escenario por provincia)
  ├─ _rebuild_adjacency_system()     (AdjacencySystem desde las provincias)
  ├─ spawn de fábricas / líderes / tecnología / formaciones
  └─ emite scenario_loaded()
        └─ MapManager.initialize_from_map_data(MapScenarioData)   ← autoridad central
```

`MapManager` es el **único punto de acceso** recomendado en runtime (consultas de provincia, vecinos, centroides, picking, efectos, mutaciones). `MapScenarioData` es la "foto" que viaja de `ScenarioLoader` a `MapManager`.

---

## 3. Soporte requerido para el teatro histórico (Tarea 3)

Para representar la Guerra del Pacífico 1879 con fidelidad, la arquitectura debe soportar:

### 3.1 Provincias históricas
- **Estado actual:** soportado a nivel de dato. Cada provincia nueva requiere: entrada en `provinces_base.json`, polígono en `provinces_geometry.json`, adyacencias simétricas, y opcionalmente capas (terreno/economía/recursos).
- **Requisito de arquitectura:** ✅ cumplido. El cargador acepta cualquier número de provincias por datos, sin lógica codificada.

### 3.2 Estados históricos (p. ej. Tarapacá, Antofagasta, Tacna)
- **Estado actual:** los estados se cargan (`province_states.json`, 75 estados) pero **no se exponen** a `MapManager` ni a `Province`.
- **Requisito de arquitectura:** ⚠️ pendiente. `Province` necesita un campo `state_id` y `MapManager` una consulta `get_provinces_in_state()`. (Deuda DT-P6-01.)

### 3.3 Regiones estratégicas históricas (frentes: litoral, sierra, marítimo)
- **Estado actual:** cargadas (`strategic_regions.json`, 22 regiones) pero no expuestas.
- **Requisito de arquitectura:** ⚠️ pendiente, igual que los estados. (Deuda DT-P6-01.)

### 3.4 Capitales históricas (Lima, Santiago, La Paz, Sucre)
- **Estado actual:** la capital es una *feature* por provincia (`special_features["capital"]`).
- **Requisito de arquitectura:** ✅ funciona por datos. Recomendación: helper `get_capital_of(tag)` para no recorrer todas las provincias.

### 3.5 Propiedad histórica (owner/controller iniciales)
- **Estado actual:** soportado vía overrides del escenario (`owner_tag`, `controller_tag`, `core_for_tags`).
- **Requisito de arquitectura:** ✅ cumplido.

### 3.6 Transferencias de provincias (tratados/anexiones)
- **Estado actual:** `MapManager.update_province_owner()` transfiere **una** provincia y dispara captura de fábricas + señal `province_data_changed`.
- **Requisito de arquitectura:** ⚠️ parcial. No existe transferencia **a nivel de estado** (anexar Tarapacá completo = bucle manual provincia a provincia). Requiere primero exponer los estados en runtime. (Deuda DT-P6-03.)

---

## 4. Dependencias del sistema de mapa

**`MapManager` usa:** `ScenarioLoader` (señal `scenario_loaded`), `MapScenarioData`, `AdjacencySystem`, `MapPickGrid`, `ProvinceEffects`, `Province`, `TimeManager` (reparación diaria de infraestructura).
**`MapManager` es usado por:** `MapRenderer`, capas de overlay (Agent/Conflict/Supply), UI de provincia, sistemas de combate/abastecimiento (en transición), `FactoryManager` (al capturar provincia).

**`ScenarioLoader` usa:** `ScenarioDataResolver`, `ScenarioCountryRuntime`, `ScenarioProvinceApplier`, `ScenarioFactoryBootstrap`, `AdjacencySystem`, `Province`, `TimeManager`, `LeaderManager`, `TechnologyManager`, `FormationSpawner`.
**`ScenarioLoader` es usado por:** `MapManager`, `SaveLoadManager` (metadatos), arranque del juego.

---

## 5. Conclusión

La arquitectura **soporta por datos** provincias, capitales y propiedad histórica sin código codificado. Las dos carencias de arquitectura que deben resolverse antes de un teatro histórico completo son: **(1)** exponer estados y regiones en runtime y **(2)** transferencia a nivel de estado. Ambas están documentadas como deuda (DT-P6-01, DT-P6-03) y son de Track A en una fase futura. La cobertura de geometría (107/847) es un asunto de datos (otro track). Detalle en `HISTORICAL_THEATER_READINESS_REPORT.md`.
