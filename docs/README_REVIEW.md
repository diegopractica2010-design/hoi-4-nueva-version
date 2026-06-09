# Revision de README

## Alineacion con implementacion actual

El README esta alineado con la intencion de Fase 3 y con la conversion Guerra del Pacifico como documento oficial. Describe correctamente que el eje actual es 1879 y que Chile, Peru y Bolivia son jugables.

La alineacion no es total en runtime porque algunas secciones describen sistemas planificados que aun no existen como gameplay especifico de 1879.

## Secciones completas

- Vision general de la conversion.
- Marco historico de inicio.
- Lista de paises jugables.
- Lista de paises diplomaticos de IA.
- Estructura general del repositorio.
- Flujo de trabajo con IA.
- Politica de deuda tecnica.
- Estrategia de localizacion a nivel documental.
- Estado de Fase 3 como fundacion.

## Secciones que describen trabajo futuro

- Sistemas planificados.
- Diplomacia historica.
- Eventos historicos.
- Roadmap Fase 4.
- Roadmap Fase 5.
- Expansion de provincias especificas.
- Conectar diplomacia con compras, mediacion y presion de potencias.
- Migracion futura a localizacion runtime.

## Inconsistencias encontradas

- El README dice que el escenario 1879 es cargable desde `ScenarioLoader`; esto es correcto por archivo plano, pero no se pudo validar en runtime por falta de Godot local.
- Menciona investigacion inicial compatible con `TechnologyManager`; la compatibilidad existe por fallback, no por paquete historico 1879 propio.
- Menciona base de industrias y astilleros mediante `ScenarioFactorySpawner`; los datos son compatibles, pero la carga efectiva de fabricas no fue validada en runtime.
- La estructura enumera `data/countries/` como definiciones nacionales, pero la arquitectura actual no las consume automaticamente.

## Recomendacion

Mantener README como documento oficial, pero antes de Fase 4 conviene agregar una nota corta diferenciando "implementado", "compatible por fallback" y "planificado" para reducir ambiguedad ante nuevos agentes.
