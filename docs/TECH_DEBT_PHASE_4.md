# Fase 4 — Deuda Técnica

**Fecha:** 2026-06-09
**Alcance auditado:** todos los archivos modificados en la Fase 4 (`scripts/production/DesignManager.gd`, `project.godot`) más las incidencias observadas en ejecución.

Este documento no oculta deuda: incluye tanto lo introducido como lo observado pero fuera de alcance.

---

## 1. Deuda dentro del alcance de la Fase 4

### DT-P4-01 — Acoplamiento en cadena de compilación persiste
**Severidad:** media.
**Descripción:** se eliminó el error que tumbaba la cadena, pero la cadena de dependencias entre módulos del núcleo sigue intacta. Un futuro error en un módulo base puede volver a propagarse a todo el arranque.
**Recomendación:** introducir conexiones diferidas / desacoplar dependencias directas.

### DT-P4-02 — Sin barrera dura fábricas↔diseños
**Severidad:** baja.
**Descripción:** se verificó que los tres módulos cargan juntos, pero no se añadió una comprobación explícita que apague o suspenda las fábricas si el módulo de diseños faltara en el futuro (riesgo AR-02 original).
**Recomendación:** validación de disponibilidad de diseños dentro del módulo de fábricas.

### DT-P4-03 — Contrato de orden de arranque no documentado en código
**Severidad:** baja.
**Descripción:** la corrección de orden (calendario antes que diseños) no está comentada en `project.godot`; alguien podría reordenar la lista y reintroducir el fallo AR-03 sin darse cuenta.
**Recomendación:** comentario explicativo junto al bloque de autoloads.

---

## 2. Deuda observada en ejecución, FUERA del alcance (pertenece a otros responsables)

Estas incidencias se vieron en el registro de ejecución pero corresponden a archivos que **no** se podían modificar en esta fase. Se documentan para que no se pierdan.

### DT-P4-04 — ProvinceInsight.gd no compila (módulo de mapa)
**Severidad:** alta (para su módulo).
**Descripción:** error de compilación por asignar un valor de tipo Color a una variable de tipo texto (líneas 1469 y 1471). Arrastra otros scripts de mapa/tecnología.
**Propietario:** módulo de mapa (`scripts/map/*`). **No tocado.**

### DT-P4-05 — TradeManager.gd no compila (módulo nacional/comercio)
**Severidad:** alta (para su módulo).
**Descripción:** varias variables sin tipo inferido (líneas 412, 502, 503, 1168, 1181); el autoload de comercio no llega a instanciarse.
**Propietario:** módulo nacional (`scripts/national/*`). **No tocado.**

### DT-P4-06 — Sin archivo de tecnología inicial para 1879
**Severidad:** media.
**Descripción:** al cargar el escenario 1879 no existe archivo de tecnología de partida; el juego usa valores mínimos por defecto (aviso, no error).
**Propietario:** datos de tecnología (`data/technology/*`). **No tocado.**

### DT-P4-07 — Cobertura de geometría de provincias parcial
**Severidad:** baja/media.
**Descripción:** se cargan 100 geometrías de provincia frente a 840 provincias base. El mapa funciona pero la cobertura visual de geometría es parcial.
**Propietario:** datos de provincias/mapa. **No tocado.**

### DT-P4-08 — Formaciones de prueba al cargar escenario
**Severidad:** baja.
**Descripción:** al cargar el escenario se generan 4 formaciones de prueba por país (placeholder de desarrollo), no formaciones históricas reales.
**Propietario:** `scripts/core/ScenarioLoader.gd` / datos de escenario. **No tocado.**

### DT-P4-09 — Fugas y recursos en uso al cerrar
**Severidad:** baja.
**Descripción:** al salir, el motor reporta instancias de ObjectDB filtradas y 3 recursos todavía en uso. No afecta a la partida en ejecución.
**Propietario:** transversal. **No tocado.**

### DT-P4-10 — Autoguardado al cerrar
**Severidad:** informativa.
**Descripción:** el juego autoguarda al salir (`autosave.json`). Conviene confirmar que no sobrescribe partidas deseadas en cierres inesperados.
**Propietario:** `scripts/autoload/SaveLoadManager.gd`. **No tocado.**

---

## 3. Resumen

- **Resuelto en Fase 4:** DT-06 (diseños no compilaba), AR-03 (orden de arranque).
- **Mitigado:** AR-01, AR-02.
- **Deuda nueva registrada:** DT-P4-01, 02, 03.
- **Deuda ajena documentada:** DT-P4-04 a DT-P4-10.
