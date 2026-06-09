# Revision de deuda tecnica Fase 3

## TD-1879-001: Contrato plano de ScenarioLoader

Severidad: Media.

Impacto arquitectonico: limita empaquetado modular de escenarios y obliga a mantener un archivo plano por escenario.

Fase recomendada: Fase 4 si se van a crear mas archivos por escenario; Fase 5 si 1879 sigue siendo el unico paquete especial.

Bloqueo: NON_BLOCKING.

## TD-1879-002: Mapa base insuficiente para el teatro del Pacifico

Severidad: Alta.

Impacto arquitectonico: afecta precision historica, eventos, balance, logistica, control territorial y objetivos de guerra.

Fase recomendada: Fase 4.

Bloqueo: BLOCKING para campanas historicas y eventos territoriales detallados; NON_BLOCKING para mantener solo fundacion abstracta.

## TD-1879-003: Tecnologia inicial 1879 fuera de alcance

Severidad: Media.

Impacto arquitectonico: deja al escenario usando fallback generico, con balance tecnologico no historico.

Fase recomendada: Fase 4.

Bloqueo: BLOCKING para balance de produccion, unidades e investigacion; NON_BLOCKING para carga basica del escenario.

## TD-1879-004: Definiciones de pais pasivas

Severidad: Media.

Impacto arquitectonico: crea duplicacion entre `data/countries/*.json` y el bloque `countries` del escenario.

Fase recomendada: Fase 4 o Fase 5.

Bloqueo: NON_BLOCKING.

## TD-1879-005: Diplomacia aun no modelada como sistema de datos 1879

Severidad: Alta.

Impacto arquitectonico: impide que los paises IA diplomaticos tengan comportamiento historico significativo.

Fase recomendada: Fase 4 para eventos diplomaticos minimos; Fase 5 para sistema profundo.

Bloqueo: BLOCKING para una fase centrada en diplomacia; NON_BLOCKING para contenido militar inicial.

## TD-1879-006: Lideres sin cargos politicos formales

Severidad: Baja.

Impacto arquitectonico: mezcla roles politicos y militares, pero no rompe carga ni uso de lideres.

Fase recomendada: Fase 5 o posterior.

Bloqueo: NON_BLOCKING.

## Priorizacion general

1. TD-1879-002: mapa base insuficiente.
2. TD-1879-003: tecnologia inicial 1879.
3. TD-1879-005: diplomacia sin modelo.
4. TD-1879-004: definiciones de pais pasivas.
5. TD-1879-001: contrato plano de escenarios.
6. TD-1879-006: cargos politicos no separados.
