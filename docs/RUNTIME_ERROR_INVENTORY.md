# Inventario de Errores Runtime

Todos los problemas detectados al ejecutar el proyecto con **Godot 4.6 (headless)**.

Severidad: CRÍTICA · ALTA · MEDIA · BAJA.

---

### E-01 — Error de sintaxis en DesignManager
- **Descripción:** `return _format_foreign_badge(tag, design_id, compact := true)`;
  no se permite declarar variable con `:=` como argumento de llamada. Godot reporta
  "Expected closing ')' after call arguments".
- **Severidad:** CRÍTICA
- **Sistema afectado:** Producción (diseños)
- **Pasos de reproducción:** abrir el proyecto / arrancar → el autoload
  `DesignManager` no se instancia (`Failed to instantiate an autoload`).
- **Fase futura recomendada:** Fase de estabilización (pre-Fase 3).

### E-02 — Errores de inferencia de tipos en TradeManager
- **Descripción:** líneas 412, 502, 503, 559, 1168, 1181 usan `:=` sobre valores
  Variant (acceso a Dictionary), impidiendo inferir el tipo.
- **Severidad:** CRÍTICA
- **Sistema afectado:** Comercio / Nacional
- **Pasos de reproducción:** arrancar → autoload `TradeManager` no se instancia.
- **Fase futura recomendada:** Fase de estabilización (pre-Fase 3).

### E-03 — Color asignado a String en ProvinceInsight
- **Descripción:** líneas 1469/1471 asignan `Color("#...")` a una variable
  inferida como `String` (las constantes `COLOR_*` son cadenas hex, no `Color`).
- **Severidad:** ALTA
- **Sistema afectado:** Mapa / UI (insight de provincia)
- **Pasos de reproducción:** arrancar → el script no compila; la información de
  provincia/sabotaje-reparación no funcionará.
- **Fase futura recomendada:** Fase de estabilización (pre-Fase 3).

### E-04 — Sin archivo de tecnología para escenario 1879
- **Descripción:** `No starting tech file for scenario '1879', using minimal
  defaults`. No es un fallo, es un fallback.
- **Severidad:** MEDIA
- **Sistema afectado:** Tecnología
- **Pasos de reproducción:** `load_scenario("1879")` → aviso y defaults mínimos.
- **Fase futura recomendada:** Fase de contenido histórico (Fase 3+).

### E-05 — Cobertura de geometría parcial (100/840)
- **Descripción:** se cargan 840 provincias base pero solo 100 tienen geometría.
- **Severidad:** ALTA
- **Sistema afectado:** Mapa
- **Pasos de reproducción:** arrancar y cargar escenario → `Province geometry
  loaded: 100` vs `Base provinces loaded: 840`.
- **Fase futura recomendada:** Fase de contenido/mapa (Fase 3+).

### E-06 — Formaciones de prueba en la carga de escenario
- **Descripción:** `Spawned 4 test formations for <país>` para los 9 países: código
  de prueba/relleno en una ruta de producción.
- **Severidad:** MEDIA
- **Sistema afectado:** Formaciones / Producción
- **Pasos de reproducción:** `load_scenario("1879")` → 4 formaciones de prueba por país.
- **Fase futura recomendada:** Fase de contenido militar (Fase 3+).

### E-07 — UID inválido en WorldMap.tscn
- **Descripción:** `invalid UID: uid://c6uhgynax25qv` (se resuelve por ruta de texto).
- **Severidad:** MEDIA
- **Sistema afectado:** Escena principal / Mapa
- **Pasos de reproducción:** importar/abrir → aviso de UID inválido.
- **Fase futura recomendada:** Fase de estabilización.

### E-08 — Fugas de ObjectDB al salir
- **Descripción:** `ObjectDB instances leaked at exit`.
- **Severidad:** BAJA
- **Sistema afectado:** Global / gestión de memoria
- **Pasos de reproducción:** ejecutar y cerrar → aviso al salir.
- **Fase futura recomendada:** Fase de pulido técnico.

### E-09 — Recursos en uso al salir
- **Descripción:** `3 resources still in use at exit`.
- **Severidad:** BAJA
- **Sistema afectado:** Global / gestión de recursos
- **Pasos de reproducción:** ejecutar y cerrar → error al salir.
- **Fase futura recomendada:** Fase de pulido técnico.

### E-10 — Cascada de compilación por dependencia
- **Descripción:** el error de `DesignManager` propaga `Failed to compile depended
  scripts` a ~12 scripts durante la recarga (acoplamiento fuerte vía `class_name`).
- **Severidad:** MEDIA
- **Sistema afectado:** Global / arquitectura
- **Pasos de reproducción:** arrancar con `DesignManager` roto → errores en cascada.
- **Fase futura recomendada:** Fase de estabilización / refactor de acoplamiento.

---

## Resumen por severidad

- CRÍTICA: E-01, E-02
- ALTA: E-03, E-05
- MEDIA: E-04, E-06, E-07, E-10
- BAJA: E-08, E-09
