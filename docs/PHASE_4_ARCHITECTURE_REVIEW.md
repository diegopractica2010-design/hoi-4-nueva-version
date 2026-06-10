# Fase 4 — Revisión de Arquitectura

**Fecha:** 2026-06-09
**Alcance:** núcleo (diseños, fábricas, producción, calendario y orden de arranque).

---

## 1. Riesgos atacados en esta fase

### AR-01 — Acoplamiento en cadena de compilación
**Problema:** los módulos del núcleo dependen unos de otros en cadena, así que un único error de compilación (por ejemplo en el módulo de diseños) arrastraba a muchos otros y tumbaba el arranque completo.

**Acción en Fase 4:** se eliminó el error que disparaba la cadena (DT-06). Con eso, la cadena vuelve a compilar.

**Estado:** mitigado, no eliminado. La cadena de dependencias sigue existiendo; cualquier error nuevo en un módulo base puede volver a propagarse. Ver deuda DT-P4-01.

### AR-02 — Fábricas activas sin el módulo de diseños
**Problema:** las fábricas podían quedar activas aunque el módulo de diseños no estuviera disponible, dejando un estado incoherente.

**Acción en Fase 4:** con el módulo de diseños ya compilando y cargando, se verificó en ejecución que fábricas, producción y diseños están los tres presentes y activos a la vez.

**Estado:** resuelto para el arranque normal. No se añadió una "barrera dura" que apague fábricas si diseños faltara en el futuro (ver deuda DT-P4-02).

### AR-03 — Orden de arranque de los módulos
**Problema:** el módulo de diseños se cargaba antes que el calendario e intentaba conectarse a él; como el calendario aún no existía, la conexión se perdía en silencio.

**Acción en Fase 4:** se reordenó el arranque para que el calendario se cargue antes que el módulo de diseños.

**Estado:** resuelto. Verificado en ejecución: la conexión al avance de año queda establecida.

---

## 2. Orden de arranque actual (autoloads)

Orden relevante tras la corrección:

1. GameData
2. FactoryManager
3. ProductionManager
4. SupplyManager
5. LeaderManager
6. **TimeManager** (calendario)
7. **DesignManager** (diseños) ← ahora después del calendario
8. ... (resto de módulos)
9. Módulos de localización al final

**Principio aplicado:** un módulo que se conecta a las señales de otro debe cargarse **después** de ese otro.

---

## 3. Recomendaciones para fases futuras

1. **Reducir el acoplamiento en cadena (AR-01):** evaluar conexiones diferidas (que cada módulo se enganche cuando todo el árbol esté listo) en lugar de depender del orden exacto de la lista de arranque.
2. **Barrera de seguridad fábricas↔diseños (AR-02):** que las fábricas comprueben explícitamente la disponibilidad del módulo de diseños antes de operar.
3. **Documentar el contrato de orden de arranque:** dejar comentado en `project.godot` por qué el calendario va antes que diseños, para que nadie lo reordene por error.

---

## 4. Conclusión

Los tres riesgos de arquitectura de esta fase (AR-01, AR-02, AR-03) quedan **atendidos**: AR-03 resuelto, AR-02 resuelto para el flujo normal, AR-01 mitigado. La deuda residual se detalla en `TECH_DEBT_PHASE_4.md`.
