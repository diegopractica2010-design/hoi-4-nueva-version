# Reporte de validacion escenario 1879

## Alcance validado

- Existencia de escenario 1879.
- Existencia de definiciones nacionales.
- Existencia de roster de lideres 1879.
- Sintaxis JSON de archivos nuevos.
- Compatibilidad declarada con loaders actuales.

## Validaciones ejecutadas

1. Parseo JSON de:
   - `data/scenarios/1879.json`
   - `data/scenarios/1879/manifest.json`
   - `data/leaders/historical_leaders_1879.json`
   - todos los archivos `data/countries/*.json`
2. Validacion estatica de contrato:
   - fecha de inicio `1879-02-14`
   - nueve paises requeridos presentes
   - Chile, Peru y Bolivia marcados como jugables
   - capitales apuntan a provincias existentes en `provinces_base.json`
   - provincias sobreescritas existen en el mapa base
   - no hay provincias duplicadas en el escenario
   - lideres cubren los nueve paises requeridos
   - rasgos de lideres existen en `data/leaders/traits.json`
3. Busqueda local de ejecutable Godot:
   - `godot`, `godot4` y `godot4.6` no estan en PATH
   - no se encontro `Godot*.exe` en `Program Files` ni `Program Files (x86)`

## Resultado

- JSON valido: aprobado.
- Contrato estatico de escenario: aprobado.
- Paises detectados: 9.
- Provincias sobreescritas: 13.
- Lideres detectados: 16.
- Validacion runtime con Godot: no ejecutada porque el binario no esta disponible en el entorno local.

## Observaciones

La tecnologia inicial especifica de 1879 no existe por restriccion de alcance. `TechnologyManager` tiene fallback minimo para escenarios sin paquete propio. La falta de Godot local impide certificar arranque visual desde este entorno, pero los datos creados cumplen los contratos estaticos observados.
