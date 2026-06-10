# Reporte de provincias historicas Fase 7

## Alcance

Fase 7 crea contenido historico de mapa para el teatro de la Guerra del Pacifico sin modificar arquitectura de mapa ni sistemas runtime.

## Provincias creadas

Se agregaron siete provincias historicas al catalogo base y a las capas runtime:

| ID | Provincia | Pais historico 1879 | Control inicial | Rol |
|---:|---|---|---|---|
| 841 | Antofagasta | Bolivia | Chile | Puerto litoral boliviano ocupado el 14 de febrero de 1879 |
| 842 | Tarapaca | Peru | Peru | Zona salitrera interior |
| 843 | Iquique | Peru | Peru | Puerto de exportacion salitrera y guanera |
| 844 | Arica | Peru | Peru | Puerto militar y enlace hacia Tacna |
| 845 | Tacna | Peru | Peru | Centro regional sur peruano |
| 846 | La Paz | Bolivia | Bolivia | Centro politico y logistico del altiplano |
| 847 | Sucre | Bolivia | Bolivia | Capital constitucional boliviana |

## Archivos de provincia modificados

- `data/provinces/provinces_base.json`
- `data/provinces/provinces_geometry.json`
- `data/provinces/province_adjacency.json`
- `data/provinces/province_city_layer.json`
- `data/provinces/province_economy_layer.json`
- `data/provinces/province_resources_layer.json`
- `data/provinces/province_terrain_layer.json`

## Recursos historicos preparados

Se prepararon recursos de mapa para soporte futuro, sin implementar economia nueva:

- Salitre: Antofagasta, Tarapaca, Iquique, Arica, Tacna.
- Guano: Tarapaca, Iquique, Arica.
- Mineria: Antofagasta, La Paz, Sucre.
- Puertos: Antofagasta, Iquique, Arica.
- Ferrocarriles/nodos: Antofagasta, Tarapaca, Iquique, Arica, Tacna.

## Terreno

- Costa desertica: Antofagasta, Iquique, Arica.
- Desierto: Tarapaca.
- Colinas deserticas: Tacna.
- Montanas: La Paz, Sucre.

## Capitales

- Chile conserva capital nacional en Santiago, provincia 90.
- Peru conserva capital nacional en Lima, provincia 71.
- Bolivia queda alineada a Sucre, provincia 847, como capital constitucional.
- La Paz queda registrada como centro politico y logistico, no como capital nacional runtime.

## Integracion con escenario 1879

`data/scenarios/1879/scenario.json` ahora referencia las provincias historicas 841-847 y reemplaza los overrides abstractos previos usados para Bolivia y el sur peruano.

## Validacion

Resultados estaticos:

- IDs de provincias duplicados: 0.
- Provincias historicas faltantes en capas: 0.
- Referencias rotas desde escenario 1879: 0.
- Referencias de ownership rotas: 0.
- Adyacencias asimetricas: 0.

## Limitacion

La geometria es una representacion operacional aproximada sobre el mapa existente. No constituye cartografia historica fina ni frontera exacta.

