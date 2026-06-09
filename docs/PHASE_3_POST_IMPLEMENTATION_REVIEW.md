# Revision post implementacion Fase 3

## 1. Parte mas fragil

La parte mas fragil es la representacion territorial. El escenario carga sobre provincias existentes, pero el teatro historico real no esta modelado con la granularidad necesaria.

## 2. Mayor riesgo arquitectonico

El mayor riesgo es continuar agregando contenido historico sobre abstracciones del mapa base. Eso puede forzar eventos, logistica, objetivos y balance a apoyarse en provincias que no representan el conflicto.

## 3. Que deberia corregirse antes de Fase 4

- Definir si Fase 4 expandira mapa o aceptara abstraccion.
- Crear paquete de tecnologia inicial 1879 si se va a balancear produccion o unidades.
- Ejecutar validacion runtime real con Godot instalado.
- Decidir si `data/countries/*.json` sera fuente real o documentacion pasiva.

## 4. Que puede esperar

- Separacion formal de lideres politicos y militares.
- Soporte de escenarios empaquetados por carpeta.
- Diplomacia profunda con IA completa.
- Economia salitrera avanzada.
- Localizacion completa de eventos futuros.

## 5. Deuda tecnica mas peligrosa

TD-1879-002, mapa base insuficiente. Bloquea el diseno historico detallado y puede contaminar todas las decisiones posteriores.

## 6. Deuda tecnica menos importante

TD-1879-006, lideres sin cargos politicos formales. Es imperfecto historicamente, pero no bloquea carga, mapa, paises ni validacion inicial.

## 7. Supuestos realizados

- El archivo plano `data/scenarios/1879.json` era necesario para carga real.
- Los paises debian repetirse dentro del escenario aunque existieran archivos `data/countries`.
- El fallback tecnologico era aceptable para una fundacion.
- Los lideres podian representarse con `leader_type` militar existente.
- Las provincias abstractas eran aceptables solo para Fase 3.
- No habia permiso para tocar scripts ni sistemas prohibidos.

## 8. Que haria distinto si empezara Fase 3 otra vez

Primero pediria una decision arquitectonica sobre el mapa: si el objetivo era fidelidad historica, habria que habilitar trabajo en `data/provinces` antes de crear el escenario. Tambien separaria explicitamente archivos runtime y archivos documentales para evitar que `data/countries` parezca cargado por el motor cuando aun no lo esta.
