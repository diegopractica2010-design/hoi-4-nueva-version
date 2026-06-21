# Auditoría de datos — Fase 0

## Inventario

- Total bajo `data/`: 3.679 archivos.
- JSON: 2.177 válidos, 0 inválidos.
- CSV: 551 en el repositorio.
- Escenario runtime certificado: 1879.
- Escenarios 1918, 1936 y 2026: alcance estático únicamente.

## Distribución principal

| Directorio | Archivos |
|---|---:|
| unit_templates | 1.032 |
| modules | 1.083 |
| scenarios | 814 |
| leaders | 363 |
| technology | 201 |
| events | 124 |
| provinces | 20 |
| reference | 17 |
| countries | 9 |

## Integridad observada

- Los nueve países referenciados por 1879 tienen definición.
- Las 549 configuraciones AI legacy eliminadas no conservan referencias vivas.
- Las 28 escenas no contienen rutas `ext_resource` ausentes según inspección estática.
- `data/technology/starting/1879.json` está presente.

## Riesgos pendientes

- Las relaciones semánticas entre tags, provincias, leaders, templates y módulos requieren validadores dedicados; parsear JSON no basta.
- El escenario contiene datos heredados y scaffolding de potencias externas que deben permanecer fuera de las decisiones históricas de 1879.
- Guardado/carga necesita hash canónico para demostrar que el estado no se pierde ni se duplica.
