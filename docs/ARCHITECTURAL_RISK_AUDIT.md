# Auditoría de Riesgos Arquitectónicos

Riesgos detectados a partir del runtime real (Godot 4.6), no documentados antes.

---

### AR-01 — Acoplamiento fuerte por cascada de compilación
Un único error de sintaxis en `DesignManager.gd` propaga `Failed to compile
depended scripts` a ~12 scripts (`FactoryManager`, `TechnologyManager`,
`SupplyManager`, `LeaderManager`, `TimeManager`, `ProductionManager`, `GameData`,
etc.). La malla de dependencias vía `class_name` es tan densa que un fallo local se
vuelve casi global.
- **Impacto:** alto. Fragilidad sistémica: cualquier error pequeño puede tumbar
  medio proyecto en la fase de recarga.

### AR-02 — `FactoryManager` presente con `DesignManager` ausente
`FactoryManager` queda activo, pero `DesignManager` (su dependencia) no. Cualquier
llamada en runtime a `DesignManager` provocará referencia nula.
- **Impacto:** alto. Integración rota entre producción y diseños.

### AR-03 — Orden de autoloads no alineado con dependencias
`FactoryManager` (#2) se inicializa antes que `DesignManager` (#4). El orden actual
no refleja la jerarquía real de dependencias.
- **Impacto:** medio. Riesgo de inicialización prematura.

### AR-04 — `ScenarioLoader` como objeto-dios
`load_scenario()` orquesta geometría, capas, provincias, países, fábricas, líderes,
tecnología, formaciones, fecha y mapa, y llama directamente a múltiples autoloads
(`TimeManager`, `ProductionManager`, `MapManager`).
- **Impacto:** alto. Punto único de acoplamiento y de fallo difícil de mantener.

### AR-05 — Geometría como fuente de verdad parcial
840 provincias lógicas vs 100 con geometría. Existen dos "verdades" desalineadas:
la lógica del escenario y la geometría del mapa.
- **Impacto:** alto. Mapa visualmente incompleto; riesgo de inconsistencias.

### AR-06 — Años y fechas hardcodeadas
`TimeManager` arranca con `1936-01-01` por defecto; los managers de líderes cargan
`historical_leaders_1936.json` al inicio antes de conocer el escenario.
- **Impacto:** medio. Supuestos de "1936" embebidos que un escenario distinto debe
  sobrescribir; riesgo si algún sistema lee antes de cargar escenario.

### AR-07 — Colores como String en lugar de `Color`
En `ProvinceInsight` las constantes `COLOR_*` son cadenas hex, mezcladas con usos de
`Color`. Fuente de verdad inconsistente para colores.
- **Impacto:** medio. Errores de tipo y estilo visual frágil.

### AR-08 — Autosave automático al salir
`SaveLoadManager: Autosaved on exit/quit -> autosave.json` se dispara en cada cierre,
incluso en ejecuciones de prueba/headless.
- **Impacto:** medio. Riesgo de sobrescribir partidas/autosaves durante pruebas o
  cierres inesperados; round-trip de guardado/carga no validado.

### AR-09 — Código de prueba en ruta de producción
`Spawned 4 test formations for <país>` se ejecuta dentro de `load_scenario()`. Hay
lógica de prueba en el camino real del juego.
- **Impacto:** medio. Contenido no histórico/placeholder mezclado con producción.

### AR-10 — Inicialización dependiente del escenario
`TimeManager` y `MapManager` solo quedan en estado correcto tras `load_scenario()`.
Sistemas que los consulten antes verán estado por defecto.
- **Impacto:** medio. Suposiciones de orden temporal no garantizadas.

### AR-11 — Fallback silencioso de tecnología por escenario
Si falta el archivo de tech del escenario, se aplican "defaults mínimos" sin
contenido histórico. El juego no falla, pero el escenario queda vacío de tecnología.
- **Impacto:** medio. Calidad de contenido degradada de forma silenciosa.

### AR-12 — UID rotos en escenas
`WorldMap.tscn` referencia un UID inválido que se resuelve por ruta de texto. Si la
ruta cambiara, la referencia se rompería.
- **Impacto:** bajo-medio. Fragilidad de referencias entre escenas y scripts.

---

## Síntesis

El proyecto tiene **acoplamiento fuerte** (AR-01, AR-02, AR-04), **fuentes de verdad
duplicadas/parciales** (AR-05, AR-07), **supuestos hardcodeados** (AR-06) y
**código de prueba en producción** (AR-09). Ninguno impidió cargar el escenario,
pero en conjunto elevan el riesgo de fallos en cadena conforme crezca el proyecto.
