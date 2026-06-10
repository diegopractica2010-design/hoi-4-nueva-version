# Informe de Preparación del Teatro Histórico — Fase 6

**Fecha:** 2026-06-09
**Teatro:** Guerra del Pacífico, 1879
**Pregunta que responde:** ¿qué falta exactamente antes de poder añadir con seguridad las provincias históricas Antofagasta, Tarapacá, Iquique, Arica, Tacna, La Paz y Sucre?

---

## 1. Situación actual del escenario 1879

El escenario 1879 **carga correctamente** (847 provincias, 9 países), pero hoy **no usa provincias históricas reales** de la Guerra del Pacífico. Las naciones del conflicto (Chile, Perú, Bolivia, Argentina, Brasil) están colocadas sobre **provincias genéricas reutilizadas** del mapa mundial:

| País | Provincia usada hoy | Nota |
|---|---|---|
| Perú (PER) | id 71 (reutiliza "Lima") y 91 | capital + nitratos/guano genéricos |
| Chile (CHL) | id 90 (reutiliza "Santiago") | capital + cobre/carbón |
| Bolivia (BOL) | id 83 y 92 | capital + plata/estaño/nitratos |
| Argentina (ARG) | id 28, 89 | capital + puerto |
| Brasil (BRA) | id 29, 70 | capital + puerto |

**Las provincias históricas Antofagasta, Tarapacá, Iquique, Arica, Tacna, La Paz y Sucre NO existen** como provincias con nombre en `provinces_base.json` (verificado por búsqueda directa).

---

## 2. Qué falta antes de añadir cada provincia histórica

Para añadir con seguridad cada una de las 7 provincias, hace falta crear su dato completo. Por provincia:

| Pieza de dato | Archivo | ¿Bloqueante? |
|---|---|---|
| Identidad (id, nombre, terreno, dueño) | `data/provinces/provinces_base.json` | Sí |
| **Geometría (polígono + ancla de etiqueta)** | `data/provinces/provinces_geometry.json` | **Sí — el mayor bloqueo** |
| Adyacencias simétricas | `data/provinces/province_adjacency.json` | Sí |
| Asignación a estado | `data/provinces/province_states.json` | Recomendado |
| Asignación a región estratégica | `data/provinces/strategic_regions.json` | Recomendado |
| Capas (terreno/ciudad/economía/recursos) | `data/provinces/province_*_layer.json` | Opcional |
| Override 1879 (dueño/controlador/VP/recursos) | `data/scenarios/1879/scenario.json` | Sí |

**Todos estos archivos son de `data/provinces/*` y `data/scenarios/*`, que NO pertenecen a Track A.** Crearlos es trabajo de los tracks de datos/historia (Codex/Gemini). La validación de que estén correctos la garantiza el validador creado en esta fase (`MapDataValidator`).

---

## 3. Qué falta en la ARQUITECTURA (responsabilidad de Track A)

Aunque se añadan los datos, dos capacidades de arquitectura deben existir para un teatro histórico pleno:

1. **Exponer estados y regiones en runtime (DT-P6-01).**
   Hoy `ScenarioLoader` carga los 75 estados y 22 regiones (cobertura completa: 847/847), pero esos datos **no se entregan** a `MapManager` ni se guardan en `Province` (no hay campo `state_id`/`region_id`). Sin esto no se puede preguntar "¿qué provincias forman Tarapacá?" en el juego.

2. **Transferencia a nivel de estado (DT-P6-03).**
   Las anexiones históricas (Chile se queda Tarapacá y Antofagasta) requieren mover un estado completo. Hoy solo existe transferencia de **una** provincia (`update_province_owner`). Falta una operación de estado que dependa del punto 1.

Ambas son tareas de Track A (`scripts/core` / `scripts/map`) en una fase futura, documentadas como deuda.

---

## 4. Checklist de preparación

| Requisito | Estado |
|---|---|
| El cargador acepta N provincias por datos (sin código codificado) | ✅ Listo |
| Validación automática de integridad del mapa | ✅ Listo (esta fase) |
| Soporte de owner/controller/cores por escenario | ✅ Listo |
| Capitales por datos | ✅ Listo |
| Geometría para provincias históricas | ❌ Falta (datos, otro track) |
| Provincias históricas con nombre en el mapa base | ❌ Falta (datos, otro track) |
| Estados/regiones consultables en runtime | ❌ Falta (arquitectura, Track A futuro) |
| Transferencia de provincias por estado | ❌ Falta (arquitectura, Track A futuro) |

**Conclusión:** la arquitectura está **lista para recibir** las provincias históricas sin generar deuda nueva. Los bloqueos restantes son **(a)** crear los datos históricos (otro track) y **(b)** exponer estados/regiones y transferencia por estado en runtime (Track A, fase futura). No hay nada en la arquitectura actual que impida o corrompa la incorporación de Antofagasta, Tarapacá, Iquique, Arica, Tacna, La Paz y Sucre.
