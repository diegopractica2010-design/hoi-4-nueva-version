# Reporte de arquitectura de escenarios

## Alcance de Fase 5

Esta fase corrige debilidades arquitectonicas de escenarios sin crear mapa historico, tecnologia, diplomacia ni sistemas nuevos de gameplay. El objetivo fue estabilizar `ScenarioLoader`, permitir paquetes modulares y mantener compatibilidad con escenarios planos existentes.

## Responsabilidades que manejaba ScenarioLoader

Antes del refactor, `ScenarioLoader` concentraba estas responsabilidades:

- Cargar geometria de provincias.
- Cargar capas de provincias: adyacencia, terreno, ciudades, recursos, economia, estados, regiones y sitios de proyecto.
- Cargar provincias base.
- Duplicar provincias base para cada escenario.
- Leer el JSON plano del escenario.
- Parsear y validar parcialmente el JSON del escenario.
- Aplicar overrides de provincias.
- Construir paises runtime desde el bloque `countries`.
- Parsear colores de pais.
- Reconstruir adyacencias.
- Inferir acceso a puertos.
- Disparar creacion de fabricas.
- Inicializar fecha en `TimeManager`.
- Cargar lideres historicos.
- Aplicar tecnologia inicial.
- Generar formaciones de prueba.
- Limpiar caches de produccion.
- Emitir senal de escenario cargado.
- Inicializar `MapManager`.

## Separaciones implementadas

### `ScenarioDataResolver`

Responsabilidad: resolver y cargar datos de escenario desde paquetes modulares o archivos planos legacy.

Soporta:

- `data/scenarios/<scenario>/scenario.json`
- `data/scenarios/<scenario>/main.json`
- `data/scenarios/<scenario>/manifest.json`
- `data/scenarios/<scenario>.json`
- redirecciones por `loader_entry` o `scenario_file`

### `ScenarioCountryRuntime`

Responsabilidad: resolver paises runtime desde referencias a `data/countries` o desde bloques inline legacy.

Soporta:

- `country_refs`
- `countries` como array de strings
- `countries` como array de objetos inline
- `countries` como diccionario legacy
- referencias por nombre de archivo, ruta o tag

### `ScenarioProvinceApplier`

Responsabilidad: aplicar overrides de provincias sobre instancias ya duplicadas del mapa base.

Campos soportados:

- propietario
- controlador
- fabricas
- desarrollo
- infraestructura
- poblacion
- puntos de victoria
- cores
- tags
- terreno
- mar/tierra
- puerto
- recursos
- rasgos especiales

### `ScenarioFactoryBootstrap`

Responsabilidad: generar fabricas iniciales desde datos de pais ya resueltos.

Motivo: `ScenarioFactorySpawner` lee directamente `data/scenarios/<scenario>.json`; eso impide funcionar con paquetes modulares y paises externos sin tocar `scripts/scenarios`, que estaba fuera del alcance permitido.

## Compatibilidad mantenida

- `ScenarioLoader.load_scenario(nombre)` conserva la misma firma.
- `ScenarioLoader.provinces` conserva el contrato de diccionario de provincias.
- `ScenarioLoader.countries` conserva el contrato de diccionario por tag.
- `get_country(tag)` y `get_map_data()` se mantienen.
- Escenarios planos `1918.json`, `1936.json` y `2026.json` siguen soportados.
- `1879.json` se conserva como archivo legacy de redireccion.
- Lideres y tecnologia siguen recibiendo el mismo `scenario_name`.

## Arquitectura modular resultante

El paquete 1879 ahora vive en:

- `data/scenarios/1879/scenario.json`
- `data/scenarios/1879/manifest.json`

El archivo:

- `data/scenarios/1879.json`

queda como redireccion de compatibilidad.

## Limitaciones restantes

- `ScenarioLoader` aun carga geometria, capas y provincias base. Eso sigue siendo una responsabilidad grande.
- La generacion de formaciones de prueba sigue dentro de la ruta de carga.
- `ScenarioFactoryBootstrap` duplica parte de la logica previa de `ScenarioFactorySpawner` porque el archivo original estaba fuera de alcance.
- La validacion runtime con Godot no pudo ejecutarse porque no hay binario Godot disponible en el entorno.

## Resultado sobre DT-06 y AR-04

DT-06 queda mitigada: los escenarios ya pueden ser paquetes modulares y el archivo plano no es la unica forma de entrada.

AR-04 queda reducida pero no eliminada: `ScenarioLoader` ya no contiene resolucion de archivo, integracion de paises ni aplicacion de overrides, pero aun orquesta varios sistemas externos.
