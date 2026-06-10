# Reporte de estados historicos Fase 7

## Alcance

Se agregaron estados historicos al archivo runtime que ya consume `ScenarioLoader`: `data/provinces/province_states.json`.

No se creo una fuente paralela en `data/states` para evitar duplicar autoridad de estados.

## Estados creados

| ID | Estado | Provincias | Hub | Owner 1879 | Controller 1879 |
|---:|---|---|---:|---|---|
| 71 | Litoral Boliviano | 841 | 841 | BOL | CHL |
| 72 | Tarapaca | 842, 843 | 843 | PER | PER |
| 73 | Arica y Tacna | 844, 845 | 844 | PER | PER |
| 74 | La Paz | 846 | 846 | BOL | BOL |
| 75 | Chuquisaca | 847 | 847 | BOL | BOL |

## Soporte a sistemas futuros

La estructura agregada permite soporte futuro para:

- Ownership por estado.
- Ocupacion y control separado, especialmente Antofagasta.
- Supply hubs estatales.
- Condiciones de victoria por capitales regionales y puertos.
- Eventos regionales.
- Diplomacia y reclamos territoriales.

## Capitales estatales

- Litoral Boliviano: Antofagasta.
- Tarapaca: Iquique.
- Arica y Tacna: Tacna.
- La Paz: La Paz.
- Chuquisaca: Sucre.

## Validacion

Resultados estaticos:

- IDs de estados duplicados: 0.
- Provincias inexistentes en estados nuevos: 0.
- Supply hubs fuera de su estado: 0.
- Provincias historicas sin estado: 0.

## Limitacion

`ScenarioLoader` actualmente solo usa `id`, `name`, `province_ids` y `supply_hub_province_id`. Los campos historicos adicionales quedan disponibles como metadata de contenido hasta que arquitectura de estados los consuma.

