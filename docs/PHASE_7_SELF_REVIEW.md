# Auto-revision Fase 7

## Supuestos realizados

- El start date `1879-02-14` justifica representar Antofagasta con owner boliviano y controller chileno.
- Sucre se usa como capital runtime boliviana por su rol constitucional.
- La Paz queda como centro politico y logistico, no como capital nacional runtime.
- Las capas existentes de `data/provinces` son la fuente runtime autoritativa para estados y regiones.
- No se crean fuentes paralelas en `data/states` ni `data/strategic_regions` para evitar duplicacion.

## Riesgos restantes

- La geometria aproximada puede requerir ajuste cuando Phase 6 entregue arquitectura o tooling definitivo.
- Sin runtime Godot, la validacion no certifica render ni secuencia real de carga.
- Las regiones navales son costeras, no zonas maritimas reales.
- Los datos historicos de poblacion y recursos estan calibrados para gameplay inicial y requieren revision historica fina.

## Riesgos historicos

- Los recursos como salitre, guano, plata, estano y cobre estan representados en escala de juego, no en produccion historica exacta.
- La delimitacion provincial simplifica espacios historicos complejos.
- Antofagasta se modela como ocupada por Chile el dia de inicio; si el diseno decide iniciar antes del desembarco, debe cambiarse controller.

## Riesgos futuros de mapa

- Al agregar zonas maritimas, habra que revisar adyacencias de puertos.
- Si Phase 6 introduce un validador estricto de geometria, los poligonos simples pueden requerir refinamiento.
- Si estados pasan a ser fuente de victoria o diplomacia, los campos metadata deberan formalizarse en schema.

## Que haria diferente con mas alcance

- Agregaria zonas maritimas del Pacifico sur.
- Usaria datos GIS o una herramienta de autor para poligonos mas precisos.
- Separaria capas historicas por escenario si la arquitectura futura lo permite sin duplicar fuente runtime.
- Ejecutaria Godot headless como validacion obligatoria.

