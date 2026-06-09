# Guerra del Pacifico: conversion 1879

Este repositorio contiene una conversion historica de gran estrategia construida sobre Godot 4.6. El eje oficial del proyecto es la Guerra del Pacifico, iniciada en 1879, con Chile, Peru y Bolivia como paises jugables y un entorno diplomatico internacional que reacciona al conflicto.

## Vision

Crear una experiencia de estrategia historica donde el jugador pueda dirigir gobiernos, fuerzas armadas, industria, logistica y diplomacia durante la Guerra del Pacifico. El objetivo no es reemplazar la arquitectura base de Epochs of Ascendancy, sino usarla como plataforma para una conversion enfocada, data-driven y verificable.

La prioridad de diseno es que cada sistema jugable tenga una razon historica: control del salitre, acceso al litoral, superioridad naval, movilizacion andina, presion diplomatica, financiamiento externo y desgaste logistico.

## Marco historico

El escenario 1879 comienza el 14 de febrero de 1879, cuando Chile ocupa Antofagasta y abre una crisis regional entre Chile, Bolivia y Peru. El mapa base actual aun es abstracto, por lo que la primera fundacion representa los centros politicos y economicos con provincias existentes:

- Chile: Santiago y capacidad expedicionaria sobre el Pacifico sur.
- Peru: Lima y enclaves salitreros del sur.
- Bolivia: capital andina y litoral disputado representado mediante provincia costera asignada.
- Argentina y Brasil: observadores regionales.
- Estados Unidos, Reino Unido, Francia y Alemania: potencias diplomaticas, comerciales y proveedoras de tecnologia o armas.

## Paises jugables

- Chile
- Peru
- Bolivia

## Paises de IA diplomatica

- Argentina
- Brasil
- Estados Unidos de America
- Reino Unido
- Francia
- Alemania

## Sistemas planificados

- Escenario 1879 cargable desde `ScenarioLoader`.
- Paises y colores cargables por el bloque `countries` del escenario.
- Lideres historicos cargables por `LeaderManager`.
- Base de industrias y astilleros mediante `ScenarioFactorySpawner`.
- Investigacion inicial compatible con `TechnologyManager`.
- Produccion nacional compatible con `FactoryManager` y `ProductionManager`.
- Suministro y presencia militar compatible con `SupplyManager`.
- Diplomacia historica para mediacion, neutralidad, compras externas y presion regional.
- Localizacion data-driven sin hardcodear cadenas nuevas en scripts.
- Futuros eventos historicos para campanas terrestres, guerra naval, bloqueo y negociaciones.

## Roadmap

### Fase 3: Fundacion Guerra del Pacifico

- Crear escenario 1879.
- Crear definiciones nacionales de Chile, Peru, Bolivia y paises diplomaticos.
- Crear roster historico inicial.
- Documentar arquitectura, validacion, deuda tecnica y plan maestro.
- Mantener compatibilidad con loaders existentes sin modificar scripts fuera de alcance.

### Fase 4: Contenido jugable inicial

- Expandir provincias especificas del teatro si el mapa base lo permite.
- Crear eventos de inicio de guerra, alianza Peru-Bolivia y decisiones de movilizacion.
- Introducir objetivos nacionales por pais.
- Conectar diplomacia con compras, mediacion y presion de potencias.

### Fase 5: Sistemas historicos profundos

- Campanas terrestres del desierto y sierra.
- Guerra naval con impacto logistico y control de puertos.
- Economia salitrera, deuda, comercio externo y financiamiento.
- Paz, tratados, ocupacion y consecuencias de posguerra.

## Estructura del repositorio

- `data/scenarios/`: escenarios cargables por `ScenarioLoader`.
- `data/scenarios/1879/`: manifiesto y documentacion auxiliar del paquete 1879.
- `data/countries/`: definiciones historicas nacionales de la conversion.
- `data/leaders/`: rosters historicos por escenario.
- `data/provinces/`: mapa base, geometria, recursos, economia y capas.
- `data/technology/`: arboles y paquetes de tecnologia existentes.
- `data/production/`: reglas de fabricas, costes y modificadores.
- `data/supply/`: reglas de suministro.
- `scripts/`: sistemas Godot que cargan y ejecutan la simulacion.
- `docs/`: planes, auditorias e informes oficiales.

## Flujo de trabajo con IA

El proyecto puede ser trabajado por multiples agentes en paralelo. Cada agente debe:

- Respetar estrictamente el alcance de archivos asignado.
- Leer arquitectura antes de editar datos.
- Preferir extensiones data-driven a cambios de scripts.
- Validar JSON y arranque despues de cada fase.
- Registrar deuda tecnica en documentos, sin corregirla cuando este fuera de alcance.
- Evitar cambios cosmeticos o refactors no solicitados.
- Comitear cambios con mensajes claros y pequenos.

## Politica de deuda tecnica

La deuda tecnica se registra, se prioriza y se trata como backlog explicito. No se corrige deuda fuera de fase si:

- Requiere tocar archivos no asignados.
- Cambia contratos publicos de loaders.
- Mezcla refactor con contenido historico.
- Puede bloquear trabajo paralelo.

La deuda debe incluir impacto, ubicacion, riesgo y propuesta futura. La existencia de deuda no invalida una fase si el escenario carga y los sistemas actuales siguen funcionando.

## Estrategia de localizacion

La localizacion debe mantenerse data-driven. En esta fase no se modifican `scripts/localization` ni `data/localization`, por lo que los nombres historicos viven en JSON de escenario, paises y lideres. La estrategia futura es:

- Crear claves estables para paises, lideres, eventos y sistemas.
- Migrar textos visibles a archivos de localizacion cuando el alcance lo permita.
- Mantener espanol como idioma documental oficial de la conversion.
- Evitar cadenas duplicadas entre escenario, UI y eventos.

## Ejecucion en desarrollo

1. Abrir el proyecto con Godot 4.6.2 o superior.
2. Ejecutar la escena principal configurada en `project.godot`.
3. Cargar el escenario `1879` desde las herramientas o escenas que invoquen `ScenarioLoader.load_scenario("1879")`.

## Estado de la fase

La Fase 3 establece la base historica y tecnica del escenario 1879. Los informes oficiales estan en `docs/`.
