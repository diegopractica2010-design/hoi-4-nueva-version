# Deuda Técnica — Fase 2 (Ampliada con hallazgos de runtime)

Combina la deuda previa de localización con la deuda descubierta al ejecutar el
proyecto real en Godot 4.6. Estado de todos los ítems: **PENDING**.

Bloqueo: BLOCKING · NON_BLOCKING.

---

## Deuda previa (localización)

### DT-03 — Textos del juego sin externalizar
- **Descripción:** menús, HUD, tooltips y eventos siguen con texto fijo, sin claves.
- **Severidad:** MEDIA
- **Impacto arquitectónico:** la localización existe pero no está conectada a la UI real.
- **Bloqueo:** NON_BLOCKING
- **Fase objetivo:** Fase 3+ (migración de textos)
- **Estado:** PENDING

### DT-05 — Cobertura limitada de claves
- **Descripción:** `en.json`/`es.json` contienen un set base, no todos los textos.
- **Severidad:** BAJA
- **Impacto arquitectónico:** bajo; ampliable solo con datos.
- **Bloqueo:** NON_BLOCKING
- **Fase objetivo:** Fase 3+
- **Estado:** PENDING

---

## Deuda nueva descubierta en runtime

### DT-06 — `DesignManager` no compila (autoload caído)
- **Descripción:** error de sintaxis (`compact := true` como argumento) en
  `DesignManager.gd:417`; el autoload no se instancia.
- **Severidad:** CRÍTICA
- **Impacto arquitectónico:** rompe el sistema de diseños y arrastra dependientes.
- **Bloqueo:** BLOCKING
- **Fase objetivo:** Estabilización (pre-Fase 3)
- **Estado:** PENDING

### DT-07 — `TradeManager` no compila (autoload caído)
- **Descripción:** 6 errores de inferencia de tipos (`:=` sobre Variant) en
  `TradeManager.gd`; el autoload no se instancia.
- **Severidad:** CRÍTICA
- **Impacto arquitectónico:** sistema de comercio/diplomacia inactivo.
- **Bloqueo:** BLOCKING
- **Fase objetivo:** Estabilización (pre-Fase 3)
- **Estado:** PENDING

### DT-08 — `ProvinceInsight` no compila (Color vs String)
- **Descripción:** asignación de `Color` a variable inferida como `String`
  (`ProvinceInsight.gd:1469/1471`); constantes `COLOR_*` definidas como cadenas.
- **Severidad:** ALTA
- **Impacto arquitectónico:** información de provincia/sabotaje-reparación rota.
- **Bloqueo:** NON_BLOCKING (no es autoload, pero degrada la UI del mapa)
- **Fase objetivo:** Estabilización
- **Estado:** PENDING

### DT-09 — Acoplamiento por cascada de compilación
- **Descripción:** un error local propaga fallos a ~12 scripts dependientes.
- **Severidad:** ALTA
- **Impacto arquitectónico:** fragilidad sistémica.
- **Bloqueo:** NON_BLOCKING
- **Fase objetivo:** Refactor de acoplamiento (Fase 3+)
- **Estado:** PENDING

### DT-10 — Geometría parcial del mapa (100/840)
- **Descripción:** 740 provincias sin geometría.
- **Severidad:** ALTA
- **Impacto arquitectónico:** mapa visualmente incompleto; verdad parcial.
- **Bloqueo:** NON_BLOCKING
- **Fase objetivo:** Contenido de mapa (Fase 3+)
- **Estado:** PENDING

### DT-11 — Formaciones de prueba en producción
- **Descripción:** `Spawned 4 test formations` dentro de `load_scenario()`.
- **Severidad:** MEDIA
- **Impacto arquitectónico:** placeholder en ruta real.
- **Bloqueo:** NON_BLOCKING
- **Fase objetivo:** Contenido militar (Fase 3+)
- **Estado:** PENDING

### DT-12 — Sin archivo de tecnología para 1879
- **Descripción:** fallback a defaults mínimos; escenario sin tech histórica.
- **Severidad:** MEDIA
- **Impacto arquitectónico:** contenido degradado de forma silenciosa.
- **Bloqueo:** NON_BLOCKING
- **Fase objetivo:** Contenido histórico (Fase 3+)
- **Estado:** PENDING

### DT-13 — Autosave automático al salir
- **Descripción:** SaveLoadManager autoguarda en cada cierre, incluso en pruebas.
- **Severidad:** MEDIA
- **Impacto arquitectónico:** riesgo de sobrescritura; round-trip no validado.
- **Bloqueo:** NON_BLOCKING
- **Fase objetivo:** Estabilización de guardado
- **Estado:** PENDING

### DT-14 — Fechas/años hardcodeados (1936)
- **Descripción:** default `1936-01-01` y carga de líderes 1936 antes del escenario.
- **Severidad:** BAJA
- **Impacto arquitectónico:** supuestos embebidos.
- **Bloqueo:** NON_BLOCKING
- **Fase objetivo:** Refactor de configuración
- **Estado:** PENDING

### DT-15 — UID inválido en WorldMap.tscn
- **Descripción:** `invalid UID: uid://c6uhgynax25qv`.
- **Severidad:** MEDIA
- **Impacto arquitectónico:** fragilidad de referencias.
- **Bloqueo:** NON_BLOCKING
- **Fase objetivo:** Estabilización
- **Estado:** PENDING

### DT-16 — Fugas de ObjectDB y recursos al salir
- **Descripción:** `ObjectDB instances leaked` y `3 resources still in use at exit`.
- **Severidad:** BAJA
- **Impacto arquitectónico:** gestión de ciclo de vida imperfecta.
- **Bloqueo:** NON_BLOCKING
- **Fase objetivo:** Pulido técnico
- **Estado:** PENDING

---

## Resumen de bloqueo

- **BLOCKING:** DT-06, DT-07 (autoloads caídos: producción y comercio).
- **NON_BLOCKING:** el resto.

> Nota de alcance: la corrección de DT-06, DT-07 y DT-08 cae en scripts de otros
> sistemas/agentes (`production`, `national`, `map`). Esta auditoría solo los
> documenta; no los corrige.
