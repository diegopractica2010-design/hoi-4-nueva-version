# Informe de Validación del Mapa — Fase 6

**Fecha:** 2026-06-09
**Herramienta:** `scripts/map/MapDataValidator.gd` (creada en esta fase, reutilizable)
**Ejecución:** modo headless sobre los datos reales del proyecto.

---

## 1. Qué hace la nueva infraestructura de validación (Tarea 6)

`MapDataValidator` revisa automáticamente la integridad de los datos del mapa **antes** de que lleguen al juego. Es reutilizable: cualquier escena o prueba puede llamar `MapDataValidator.validate_all()` y obtener un informe estructurado, o `format_report()` para texto legible. Solo **lee** datos; nunca los modifica.

Comprobaciones que realiza:
- IDs de provincia duplicados o inválidos.
- Geometría: referencias a provincias inexistentes, duplicados y cobertura.
- Adyacencia: referencias rotas (origen y destino) y simetría.
- Capas (terreno, ciudad, economía, recursos): referencias a provincias inexistentes.
- Estados y regiones estratégicas: IDs duplicados, referencias rotas, solapamientos y cobertura.
- Sitios de proyecto: referencias rotas.

**Objetivo cumplido:** detectar inconsistencias futuras del mapa de forma automática y reutilizable.

---

## 2. Resultado de la validación (Tarea 5)

✅ **APROBADO** — 0 errores, 1 advertencia.

| Comprobación | Resultado |
|---|---|
| Provincias base | 847 |
| IDs duplicados | 0 |
| IDs inválidos | 0 |
| Provincias con geometría | 107 |
| **Provincias sin geometría** | **740** ⚠️ |
| Adyacencias con origen roto | 0 |
| Adyacencias con destino roto | 0 |
| Adyacencias asimétricas | 0 |
| Capa terreno (entradas / rotas) | 847 / 0 |
| Capa ciudad (entradas / rotas) | 847 / 0 |
| Capa economía (entradas / rotas) | 847 / 0 |
| Capa recursos (entradas / rotas) | 847 / 0 |
| Estados (grupos / provincias sin asignar) | 75 / 0 |
| Regiones estratégicas (grupos / sin asignar) | 22 / 0 |
| Sitios de proyecto (total / rotos) | 24 / 0 |

---

## 3. Única incidencia detectada

**[ADVERTENCIA] GEO_COVERAGE:** 740 de 847 provincias no tienen geometría (polígono) y por tanto **no se dibujan en el mapa**.

- **Qué significa en el juego:** solo 107 provincias son visibles/seleccionables en el mapa; las 740 restantes existen como dato (con dueño, economía, adyacencias) pero no tienen forma dibujable.
- **Severidad:** media. No rompe el arranque ni la integridad de datos, pero limita el teatro jugable.
- **Propiedad:** `data/provinces/provinces_geometry.json` — **fuera del alcance de Track A**. Documentado como hallazgo cruzado y deuda DT-P6-02.

---

## 4. Conclusión

La integridad referencial de los datos del mapa es **sólida**: sin IDs duplicados, sin referencias rotas en adyacencia/capas/estados/regiones/sitios, y cobertura completa de estados y regiones (cada provincia pertenece exactamente a un estado y a una región). El único riesgo es la cobertura de geometría, que es un asunto de datos de otro track. El validador queda disponible para usarse en cada futura ampliación del mapa.
