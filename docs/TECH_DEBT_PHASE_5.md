# Deuda tecnica Fase 5

## TD5-001: ScenarioLoader aun orquesta demasiados sistemas

Impacto: aunque se movieron responsabilidades a helpers, `ScenarioLoader` todavia inicializa tiempo, lideres, tecnologia, formaciones, produccion y mapa.

Riesgo: futuras fases pueden volver a convertir `load_scenario()` en un punto de acoplamiento fuerte.

Recomendacion: crear una capa de `ScenarioRuntimePipeline` o eventos por etapa cuando el alcance permita tocar integraciones mayores.

## TD5-002: Bootstrap de fabricas duplica logica de ScenarioFactorySpawner

Impacto: `ScenarioFactoryBootstrap` replica la logica de base factories, naval power, shipyards y key provinces.

Causa: `scripts/scenarios/ScenarioFactorySpawner.gd` estaba fuera de alcance y lee archivos planos directamente.

Riesgo: si se cambia una regla de fabricas en un camino, puede divergir del otro.

Recomendacion: en una fase futura, mover la logica comun a un servicio compartido o actualizar `ScenarioFactorySpawner` para aceptar datos normalizados.

## TD5-003: Escenarios legacy siguen con paises inline

Impacto: `1918`, `1936` y `2026` todavia tienen `countries` como fuente autoritativa interna.

Riesgo: la arquitectura permite dos modelos: paises externos para 1879 y paises inline para legacy.

Recomendacion: migrar escenarios legacy gradualmente a `country_refs` cuando existan definiciones externas completas.

## TD5-004: Validacion runtime pendiente

Impacto: la fase tiene validacion estatica pero no certificacion de arranque real con Godot.

Causa: no hay binario Godot disponible en el entorno.

Riesgo: errores de GDScript solo detectables por el motor pueden aparecer al abrir el proyecto.

Recomendacion: ejecutar validacion headless en CI o entorno local del arquitecto antes de planificar gameplay.

## TD5-005: Fuente de pais por archivo no tiene schema formal

Impacto: `data/countries/*.json` ahora conduce runtime 1879, pero no hay schema documental formal que enumere campos requeridos y opcionales.

Riesgo: futuros agentes pueden omitir `key_provinces`, `capital_province_id` o `color`.

Recomendacion: crear `data/countries/SCHEMA.md` o documentar schema en `docs` antes de migrar mas escenarios.

## TD5-006: Formaciones de prueba siguen en carga de escenario

Impacto: la arquitectura de escenario todavia genera formaciones de prueba para cada pais cargado.

Riesgo: puede confundirse con contenido militar real y afectar validaciones historicas.

Recomendacion: separar formaciones de prueba de la carga normal o condicionar su generacion a modo desarrollo.

## TD5-007: Redireccion legacy 1879 depende del nuevo resolver

Impacto: `data/scenarios/1879.json` ya no contiene el payload completo; contiene `loader_entry`.

Riesgo: herramientas externas que lean directamente JSON plano sin `ScenarioDataResolver` no veran provincias ni paises.

Recomendacion: documentar que el contrato oficial es `ScenarioLoader` y actualizar herramientas externas si aparecen.
