# Plan de implementacion del escenario 1879

## Objetivo

Crear una fundacion historica cargable para la Guerra del Pacifico con Chile, Peru y Bolivia como paises jugables, mas seis paises de IA diplomatica: Argentina, Brasil, Estados Unidos, Reino Unido, Francia y Alemania.

## Arquitectura observada

`ScenarioLoader` carga escenarios desde `res://data/scenarios/<nombre>.json`. El archivo debe contener `start_date`, `provinces` y `countries`. Las provincias se aplican como overrides sobre `data/provinces/provinces_base.json`, por lo que el escenario puede cambiar propietario, controlador, fabricas, desarrollo, infraestructura, poblacion, recursos, terreno, puerto y rasgos especiales sin modificar el mapa base.

`MapManager` recibe los datos del loader mediante `initialize_from_map_data`. Por eso el escenario debe entregar tags de pais consistentes, colores validos y provincias existentes en el mapa base.

`LeaderManager` busca rosters por nombre de escenario mediante `res://data/leaders/historical_leaders_<escenario>.json`. Para 1879 la ruta compatible es `data/leaders/historical_leaders_1879.json`.

`TechnologyManager` busca tecnologias iniciales en `data/technology/starting/<escenario>.json`. Ese directorio esta fuera del alcance de propiedad de esta fase, por lo que 1879 queda compatible por fallback interno: el manager aplica tecnologia minima y emite advertencia si no existe paquete especifico.

`FactoryManager` y `ProductionManager` dependen del bloque `countries` y de `key_provinces` para que `ScenarioFactorySpawner` genere fabricas iniciales. Los paises navales usan `naval_power` y provincias con puerto.

`SupplyManager` usa datos de mapa, presencia y plantillas ya existentes. La fase 3 no crea nuevas plantillas fuera de alcance.

## Decisiones de implementacion

- Crear `data/scenarios/1879.json` como archivo cargable real, porque el loader actual no soporta directorios por escenario.
- Crear `data/scenarios/1879/manifest.json` como raiz documental del paquete 1879.
- Crear definiciones pasivas en `data/countries/*.json` para los nueve paises del escenario.
- Crear `data/leaders/historical_leaders_1879.json` con campos soportados por `LeaderGenerator`.
- Usar solo rasgos existentes de `data/leaders/traits.json`.
- Mantener textos en ASCII para evitar problemas de codificacion.
- No modificar scripts ni archivos de localizacion.

## Modelo territorial inicial

El mapa base actual tiene provincias globales abstractas y pocas provincias sudamericanas. La fase usa:

- `90` como Santiago y nucleo chileno.
- `71` como Lima y centro peruano.
- `91` como enclave salitrero peruano abstracto.
- `83` como capital andina boliviana abstracta.
- `92` como litoral boliviano abstracto.
- `28` y `89` para Argentina.
- `29` y `70` para Brasil.
- `6`, `5`, `4` y `2` para potencias diplomaticas externas.

## Compatibilidad por sistema

- ScenarioLoader: carga `1879.json`, aplica overrides y paises.
- MapManager: recibe provincias, geometria base, adyacencias y paises.
- LeaderManager: carga roster 1879 por convencion de nombre.
- TechnologyManager: usa fallback minimo por falta de paquete propio dentro del alcance.
- FactoryManager: genera fabricas desde `key_provinces`.
- ProductionManager: limpia caches tras cargar el escenario.
- SupplyManager: puede operar sobre provincias cargadas sin nuevos datos.

## Riesgos

- El loader plano contradice parcialmente la carpeta asignada `data/scenarios/1879/*`.
- Bolivia requiere abstraccion territorial porque el mapa base no contiene La Paz, Sucre, Antofagasta ni Atacama como provincias nombradas.
- La tecnologia inicial de 1879 no puede crearse sin tocar `data/technology/starting`.
- No hay sistema diplomatico profundo expuesto en los archivos permitidos.

## Criterio de cierre

La fase se considera cerrada cuando el JSON valida, el escenario 1879 existe, Chile/Peru/Bolivia existen, el roster historico carga y los informes oficiales quedan creados.
