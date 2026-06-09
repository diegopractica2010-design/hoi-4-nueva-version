# Inventario de assets Fase 3

## Scenarios

### `data/scenarios/1879.json`

Proposito: escenario runtime principal de la Guerra del Pacifico.

Uso runtime: cargado por `ScenarioLoader.load_scenario("1879")`.

Dependencias: `data/provinces/provinces_base.json`, capas de provincias, `ScenarioFactorySpawner`, `LeaderManager`, `TechnologyManager`, `MapManager`.

### `data/scenarios/1879/manifest.json`

Proposito: manifiesto documental del paquete 1879.

Uso runtime: ninguno confirmado; sirve como inventario y raiz de paquete.

Dependencias: referencia `res://data/scenarios/1879.json`.

## Countries

### `data/countries/chile.json`

Proposito: definicion historica pasiva de Chile.

Uso runtime: ninguno confirmado por loaders actuales.

Dependencias: tag `CHL`, provincia capital `90`, escenario `1879`.

### `data/countries/peru.json`

Proposito: definicion historica pasiva de Peru.

Uso runtime: ninguno confirmado por loaders actuales.

Dependencias: tag `PER`, provincia capital `71`, escenario `1879`.

### `data/countries/bolivia.json`

Proposito: definicion historica pasiva de Bolivia.

Uso runtime: ninguno confirmado por loaders actuales.

Dependencias: tag `BOL`, provincia capital `83`, escenario `1879`.

### `data/countries/argentina.json`

Proposito: definicion historica pasiva de Argentina como IA diplomatica.

Uso runtime: ninguno confirmado por loaders actuales.

Dependencias: tag `ARG`, provincia capital `28`, escenario `1879`.

### `data/countries/brazil.json`

Proposito: definicion historica pasiva de Brasil como IA diplomatica.

Uso runtime: ninguno confirmado por loaders actuales.

Dependencias: tag `BRA`, provincia capital `29`, escenario `1879`.

### `data/countries/united_states.json`

Proposito: definicion historica pasiva de Estados Unidos como IA diplomatica.

Uso runtime: ninguno confirmado por loaders actuales.

Dependencias: tag `USA`, provincia capital `6`, escenario `1879`.

### `data/countries/united_kingdom.json`

Proposito: definicion historica pasiva de Reino Unido como IA diplomatica.

Uso runtime: ninguno confirmado por loaders actuales.

Dependencias: tag `ENG`, provincia capital `5`, escenario `1879`.

### `data/countries/france.json`

Proposito: definicion historica pasiva de Francia como IA diplomatica.

Uso runtime: ninguno confirmado por loaders actuales.

Dependencias: tag `FRA`, provincia capital `4`, escenario `1879`.

### `data/countries/germany.json`

Proposito: definicion historica pasiva de Alemania como IA diplomatica.

Uso runtime: ninguno confirmado por loaders actuales.

Dependencias: tag `GER`, provincia capital `2`, escenario `1879`.

## Leaders

### `data/leaders/historical_leaders_1879.json`

Proposito: roster historico inicial de lideres para los paises de Fase 3.

Uso runtime: cargado por `LeaderManager` cuando el escenario solicitado es `1879`.

Dependencias: `LeaderGenerator`, `data/leaders/traits.json`, tags de pais presentes en el escenario.

## Documentation

### `docs/SCENARIO_1879_IMPLEMENTATION_PLAN.md`

Proposito: explicar arquitectura y plan de implementacion 1879.

Uso runtime: ninguno.

Dependencias: lectura de `ScenarioLoader`, `MapManager`, `LeaderManager`, `TechnologyManager`, `FactoryManager`, `ProductionManager`, `SupplyManager`.

### `docs/SCENARIO_1879_VALIDATION_REPORT.md`

Proposito: registrar validaciones estaticas y limitacion de runtime.

Uso runtime: ninguno.

Dependencias: resultados de validacion local.

### `docs/PACIFIC_WAR_MASTER_PLAN.md`

Proposito: plan maestro de conversion historica.

Uso runtime: ninguno.

Dependencias: alcance historico y roadmap del proyecto.

### `docs/TECH_DEBT_PHASE_3.md`

Proposito: registrar deuda tecnica detectada durante Fase 3.

Uso runtime: ninguno.

Dependencias: observaciones de arquitectura y restricciones de alcance.

### `docs/PHASE_3_COMPLETION_REPORT.md`

Proposito: cierre de entrega de Fase 3.

Uso runtime: ninguno.

Dependencias: archivos creados y resultado de validacion.

### `docs/PHASE_3_SELF_REVIEW.md`

Proposito: auto revision de cumplimiento y riesgos.

Uso runtime: ninguno.

Dependencias: entrega de Fase 3.

### `docs/GIT_PHASE_3_REPORT.md`

Proposito: registrar commit, rama, push y alcance versionado.

Uso runtime: ninguno.

Dependencias: Git local y remoto `origin main`.

### `README.md`

Proposito: documento oficial del proyecto en espanol.

Uso runtime: ninguno.

Dependencias: vision de conversion y estado de Fase 3.

## Other

No se crearon assets binarios, escenas, scripts, localizacion, tecnologia, produccion, suministro ni gameplay adicional.
