# Matriz de contenido

| Contenido | Volumen | Consumido por codigo | Estado |
|---|---|---|---|
| Provincias base | 847 (IDs 1-847, unicos) | SI (ScenarioLoader) | OK; solo 107 con geometria dibujable |
| Geometria de provincias | 107 poligonos | SI (MapRenderer) | 740 provincias invisibles en el mapa |
| Adyacencia | 847 nodos, simetrica, 0 referencias rotas | SI (AdjacencySystem, UnitMovementSystem, AIManager) | OK |
| Estados | 75 (cobertura 847/847) | PARCIAL: se cargan pero no se exponen en runtime | deuda DT-P6-01 |
| Regiones estrategicas | 22 (cobertura total) | PARCIAL (igual que estados) | deuda DT-P6-01 |
| Escenario 1879 | 13 overrides + starting_forces/stockpiles/colors/war | PARCIAL: starting_forces NO consumido | ALTO |
| Paises 1879 | 9 archivos | SI (ScenarioCountryRuntime, AIManager) | HISTORICAL_REVIEW pendiente (Gemini) |
| Eventos 1879 | 6 archivos validos | SI en codigo (EventManager), autoload muerto | BLOQUEADO HOY |
| Plantillas de unidad 1879 | 9 (proxy ww1) | carga generica unit_templates | anacronismos documentados |
| Plantillas de unidad totales | 1031 | SI (ProductionManager) | mayoria fuera de epoca para 1879 |
| Modulos de equipo | 1082 | SI | sin modulos de epoca 1879 reales |
| Tecnologia inicial 1879 | 1 archivo (proxy industrial) | SI (TechnologyManager) | sin arbol tecnologico de epoca |
| Reglas de ingreso (data/economy) | 1 archivo | SI (NationalIncomeManager) | manager roto hoy por cascada |
| Lideres 1879 | 16 historicos | SI (LeaderManager) | OK |
| Localizacion en/es | 36 claves | infra SI; UI casi no la usa (5 usos vs 203 textos fijos) | MEDIO |
