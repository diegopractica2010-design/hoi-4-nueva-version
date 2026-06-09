# Reporte de integracion runtime de paises

## Problema original

Los archivos `data/countries/*.json` existian como definiciones pasivas. El runtime real usaba el bloque `countries` dentro del escenario, creando duplicacion y riesgo de divergencia.

## Cambio implementado

Se implemento `ScenarioCountryRuntime`, un resolver de paises que convierte referencias de escenario en entradas runtime.

El escenario modular 1879 ya no contiene definiciones completas de paises. En su lugar declara:

```json
"country_refs": [
  "chile",
  "peru",
  "bolivia",
  "argentina",
  "brazil",
  "united_states",
  "united_kingdom",
  "france",
  "germany"
]
```

Las definiciones autoritativas viven en `data/countries/*.json`.

## Fuente autoritativa

Para 1879, la fuente autoritativa de datos nacionales es `data/countries`.

El escenario solo decide que paises participan. Los campos runtime como capital, color, jugabilidad, IA diplomatica, peso industrial, poder naval, provincias clave, estabilidad y soporte de guerra se definen en el archivo de pais.

## Compatibilidad legacy

Los escenarios existentes `1918`, `1936` y `2026` siguen funcionando con el bloque inline `countries`. En esos casos, el bloque inline sigue siendo la fuente autoritativa porque no existen definiciones externas completas para todos esos paises.

## Datos movidos a paises

Para los nueve paises de 1879 se integraron campos runtime:

- `playable`
- `ai_diplomatic`
- `capital_province_id`
- `color`
- `ideology`
- `current_tech_level`
- `stability`
- `war_support`
- `major_power` cuando corresponde
- `naval_power` cuando corresponde
- `industrial_weight`
- `key_provinces`
- `strategic_role`

## Uso runtime

`ScenarioLoader` llama a `ScenarioCountryRuntime.resolve_countries(data)` y guarda el resultado en `countries`.

`ScenarioFactoryBootstrap` consume la lista ya resuelta para crear fabricas iniciales sin volver a leer el archivo de escenario.

`MapManager`, `MapRenderer`, `SupplyNetworkBuilder` y otros consumidores conservan compatibilidad porque `countries` sigue siendo un diccionario por tag con datos de color y capital.

## Resultado sobre DT-09

DT-09 queda resuelta para 1879: los paises externos ya conducen runtime.

Para escenarios legacy queda una deuda controlada: siguen usando paises inline hasta que tengan definiciones externas propias.

## Riesgo residual

Si se editan escenarios legacy, la duplicacion historica sigue existiendo alli. La integracion completa de todos los escenarios requeriria migrar cada pais existente a `data/countries`, lo que no era objetivo de esta fase.
