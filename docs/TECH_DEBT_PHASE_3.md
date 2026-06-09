# Auditoria de deuda tecnica Fase 3

## TD-1879-001: Contrato plano de ScenarioLoader

Impacto: `ScenarioLoader` solo carga `data/scenarios/<nombre>.json`. La propiedad de la fase menciona `data/scenarios/1879/*`, lo que no basta para un escenario cargable.

Riesgo: futuros paquetes por escenario pueden duplicar datos o requerir excepciones.

Propuesta futura: permitir que `ScenarioLoader` resuelva `data/scenarios/<nombre>/scenario.json` como alternativa al archivo plano.

## TD-1879-002: Mapa base insuficiente para el teatro del Pacifico

Impacto: no existen provincias nombradas para La Paz, Sucre, Antofagasta, Tarapaca, Iquique, Arica o Tacna.

Riesgo: el escenario representa territorio clave mediante abstracciones, reduciendo precision historica y balance.

Propuesta futura: expandir `data/provinces` con provincias especificas del teatro cuando el alcance permita tocar mapa base, geometria y capas.

## TD-1879-003: Tecnologia inicial 1879 fuera de alcance

Impacto: `TechnologyManager` espera `data/technology/starting/1879.json`, pero esa ruta no pertenece al alcance permitido.

Riesgo: se usa fallback minimo y puede aparecer advertencia de paquete faltante.

Propuesta futura: crear un paquete de tecnologias iniciales preindustriales/industriales tempranas cuando `data/technology/starting` este disponible.

## TD-1879-004: Definiciones de pais pasivas

Impacto: `data/countries/*.json` documenta paises, pero el runtime actual carga paises desde el bloque `countries` del escenario.

Riesgo: divergencia entre definicion pasiva y escenario cargable.

Propuesta futura: crear un `CountryDefinitionLoader` o extender `ScenarioLoader` para referenciar definiciones nacionales externas.

## TD-1879-005: Diplomacia aun no modelada como sistema de datos 1879

Impacto: los paises diplomaticos existen, pero no hay reglas de mediacion, deuda, comercio, compra de armas o presion regional.

Riesgo: el comportamiento diplomatico sera generico hasta crear sistemas o eventos.

Propuesta futura: definir contratos de diplomacia data-driven antes de implementar eventos.

## TD-1879-006: Lideres sin cargos politicos formales

Impacto: el roster historico usa solo `leader_type` militar. Presidentes, ministros y mandos navales/politicos quedan representados como lideres militares cuando es necesario.

Riesgo: mezcla de roles historicos y mecanicos.

Propuesta futura: separar liderazgo politico, ministerial y militar cuando exista sistema soportado.
