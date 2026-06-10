# Validacion runtime Fase 7

## Alcance

Validacion de integridad e integracion de datos historicos del teatro 1879.

## Resultado ejecutivo

La validacion estatica paso. La validacion runtime con Godot no pudo ejecutarse porque el entorno no tiene binario `godot`, `godot4`, `godot4.6` ni `godot_console` disponible en PATH.

## Startup

Estado: no ejecutado.

Causa: Godot no esta disponible en PATH.

Impacto: no se puede certificar arranque real del proyecto desde esta terminal.

## Scenario loading

Estado: validacion estatica exitosa.

Comprobaciones:

- `data/scenarios/1879/scenario.json` parsea como JSON valido.
- El escenario referencia provincias existentes.
- El escenario incluye provincias historicas 841-847.
- El escenario no contiene IDs duplicados.

## Province loading

Estado: validacion estatica exitosa.

Comprobaciones:

- `data/provinces/provinces_base.json` contiene 847 provincias.
- No hay IDs duplicados en provincias base.
- Las provincias 841-847 existen en base, geometria, adyacencia, ciudades, economia, recursos y terreno.
- No hay claves de capas que apunten a provincias inexistentes.

## State loading

Estado: validacion estatica exitosa.

Comprobaciones:

- Estados 71-75 existen en `data/provinces/province_states.json`.
- No hay IDs de estados duplicados.
- Todas las provincias de estados nuevos existen.
- Todos los supply hubs estatales pertenecen a su estado.

## Region loading

Estado: validacion estatica exitosa.

Comprobaciones:

- Regiones 21-22 existen en `data/provinces/strategic_regions.json`.
- No hay IDs de regiones duplicados.
- Todas las provincias de regiones nuevas existen.

## Ownership loading

Estado: validacion estatica exitosa.

Comprobaciones:

- Owners y controllers del escenario 1879 existen en `data/countries`.
- Antofagasta: owner `BOL`, controller `CHL`.
- Tarapaca, Iquique, Arica y Tacna: owner/controller `PER`.
- La Paz y Sucre: owner/controller `BOL`.
- Santiago conserva `CHL`.
- Lima conserva `PER`.

## Integracion con paises

Estado: validacion estatica exitosa.

Cambios validados:

- Bolivia usa capital runtime `847` Sucre.
- Bolivia incluye `847`, `846` y `841` como provincias clave.
- Peru incluye `71`, `842`, `843`, `844` y `845`.
- Chile incluye `90` y `841`.

## Errores encontrados

No se encontraron errores en validacion estatica.

## Advertencias encontradas

- Validacion runtime real no ejecutada por falta de Godot en PATH.
- Los reportes especificos de Fase 6 aparecieron como archivos no trackeados durante la revision y fueron considerados como contexto de restricciones.
- Existen cambios y artefactos fuera de ownership en `scripts/map` y logs de Fase 6/7. No se modificaron desde Fase 7.

## Limitaciones conocidas

- La geometria historica es aproximada.
- No existen zonas maritimas del Pacifico sur como provincias navales dedicadas.
- Campos historicos agregados en estados/regiones son metadata hasta que sistemas futuros los consuman.
