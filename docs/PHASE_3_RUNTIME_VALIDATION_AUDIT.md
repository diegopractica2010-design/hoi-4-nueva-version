# Auditoria de validacion runtime Fase 3

## Resumen

La Fase 3 tuvo validacion estatica completa de datos, pero no validacion runtime en Godot desde este entorno porque no se encontro ejecutable `godot`, `godot4` o `godot4.6` en PATH ni en rutas comunes de instalacion. Por lo tanto, los resultados runtime se clasifican como no certificados cuando dependen de ejecutar el motor.

## Resultados por componente

| Componente | Resultado |
| --- | --- |
| Escenario carga exitosamente | No certificado en runtime; contrato estatico aprobado |
| Chile carga | Contrato estatico aprobado |
| Peru carga | Contrato estatico aprobado |
| Bolivia carga | Contrato estatico aprobado |
| Paises IA cargan | Contrato estatico aprobado |
| Lideres cargan | Contrato estatico aprobado |
| Fabricas cargan | No certificado en runtime; datos compatibles con spawner |
| Tecnologias cargan | Fallback esperado |
| Suministro carga | No certificado en runtime; no se crearon datos que rompan contrato |
| Warnings de startup | No certificados en runtime |
| Errores de startup | No certificados en runtime |
| Warnings runtime | No certificados en runtime |
| Fallbacks runtime | Fallback de tecnologia esperado |

## Validaciones estaticas aprobadas

- `data/scenarios/1879.json` parsea como JSON valido.
- `data/scenarios/1879/manifest.json` parsea como JSON valido.
- `data/leaders/historical_leaders_1879.json` parsea como JSON valido.
- Todos los archivos `data/countries/*.json` parsean como JSON valido.
- El escenario contiene los nueve paises requeridos.
- Chile, Peru y Bolivia estan marcados como jugables.
- Las capitales apuntan a provincias existentes.
- Las provincias sobreescritas existen en `data/provinces/provinces_base.json`.
- No hay provincias duplicadas dentro del escenario.
- El roster contiene lideres para los nueve paises.
- Los rasgos usados por lideres existen en `data/leaders/traits.json`.

## Warnings o fallbacks esperados

### Tecnologia inicial 1879 ausente

Causa: `TechnologyManager` busca `data/technology/starting/1879.json`, pero ese archivo no se creo porque la ruta estaba fuera del alcance permitido.

Impacto: el sistema debe usar fallback minimo de tecnologia. El escenario puede arrancar con tecnologia generica, pero no con balance historico 1879.

Fase futura recomendada: Fase 4, antes de balancear unidades, produccion o investigacion.

### Paises definidos dos veces conceptualmente

Causa: el runtime lee paises desde `data/scenarios/1879.json`; los archivos `data/countries/*.json` son inventario historico pasivo.

Impacto: riesgo de divergencia entre escenario y definiciones nacionales si se edita uno sin el otro.

Fase futura recomendada: Fase 4 o Fase 5, mediante loader de definiciones nacionales o referencias desde escenario.

### Provincias historicas abstractas

Causa: el mapa base no incluye provincias especificas del teatro.

Impacto: la carga puede funcionar, pero el gameplay historico sera aproximado y balance dificil.

Fase futura recomendada: Fase 4, si el siguiente objetivo incluye eventos territoriales o campanas.

### Validacion Godot no ejecutada

Causa: no hay binario Godot disponible en el entorno local.

Impacto: no se puede certificar ausencia de warnings o errores de startup reales desde esta auditoria.

Fase futura recomendada: inmediata, como paso de integracion del arquitecto o CI local con Godot instalado.

## Conclusion

La validacion de datos es positiva. La validacion runtime real queda pendiente por entorno, no por fallo observado. El mayor fallback concreto es tecnologia inicial 1879.
