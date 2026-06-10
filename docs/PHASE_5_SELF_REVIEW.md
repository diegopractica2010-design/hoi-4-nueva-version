# Auto-revision Fase 5

## Que supuestos se hicieron

- Que `ScenarioLoader.load_scenario(scenario_name)` debe seguir siendo la entrada publica principal.
- Que `data/countries/*.json` puede ser fuente autoritativa para 1879 sin migrar de inmediato escenarios legacy.
- Que los escenarios legacy deben conservar soporte inline para no romper compatibilidad.
- Que no se podia tocar `scripts/scenarios/ScenarioFactorySpawner.gd`, por estar fuera del ownership de Fase 5.
- Que `country_refs` es el formato mas simple para eliminar duplicacion de paises en 1879.

## Que sigue siendo riesgoso

- `ScenarioLoader` aun coordina demasiados sistemas externos.
- `ScenarioFactoryBootstrap` replica logica de fabricas ya existente fuera del ownership.
- La validacion runtime real no fue ejecutada por falta de Godot en PATH.
- Los escenarios legacy siguen usando paises inline.
- El paquete 1879 usa tres archivos con el mismo ID funcional: redireccion legacy, manifiesto y payload.

## Que podria romperse luego

- Herramientas externas que lean directamente `data/scenarios/1879.json` sin usar `ScenarioDataResolver`.
- Cambios futuros en reglas de fabricas si se actualiza `ScenarioFactorySpawner` y no se sincroniza `ScenarioFactoryBootstrap`.
- Carga de managers si algun autoload espera que `countries` provenga literalmente del bloque inline del escenario.
- Validaciones de duplicidad que no distingan entre manifest, redirect y payload modular.

## Que no fue validado

- Arranque real del proyecto en Godot.
- Carga real de 1879 desde UI o secuencia de startup.
- Generacion real de fabricas en runtime.
- Carga real de lideres.
- Aplicacion real de tecnologia inicial.
- Render o inicializacion real de `MapManager`.

## Que haria diferente si empezara de nuevo

- Separaria primero una interfaz compartida para fabricas si el ownership incluyera `scripts/scenarios`.
- Definiria un schema formal para `data/countries` antes de migrar datos.
- Agregaria una prueba headless de carga de escenario como contrato permanente.
- Separaria manifiesto de payload con campos mas explicitos para que las validaciones de duplicidad distingan metadata de escenario y escenario autoritativo.

## Riesgo principal

El mayor riesgo es que la validacion runtime no pudo ejecutarse. La arquitectura quedo mas limpia por contrato, pero aun falta confirmacion real del motor.

## Recomendacion antes de futuras fases

Ejecutar Godot en modo headless o abrir el proyecto localmente y validar carga de 1879 antes de construir sistemas de gameplay encima de esta base.

