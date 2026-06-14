# MASTER AUDIT REPORT — Auditoría Integral Total del Producto

**Fecha de la auditoría:** 2026-06-12
**CONTEO DE CONTROL: Archivos en el repositorio (N): 5.067 · Archivos procesados y registrados (M): 5.067 · M = N ✔**

**Ámbito:** las dos carpetas del proyecto (`epochs-of-ascendancy/` 2.492 archivos + `hoi-4-nueva-version/` 2.575 archivos fuera de .git).
**Método:** (1) analizador mecánico que abrió y procesó íntegramente cada archivo — líneas, símbolos con línea de inicio, dependencias, validez JSON, IDs duplicados, referencias de escenas, patrones de riesgo Godot; (2) lectura manual profunda de los ~20 archivos críticos (managers, save/load, simulación, escenario), repetida como segunda pasada (Fase 30) durante esta sesión; (3) **ejecución real del motor** (Godot 4.6 headless) para capturar el estado de arranque de HOY (`_boot_actual.log`) y validaciones de runtime previas de movimiento/batalla/ingresos. Ningún reporte interno se aceptó como evidencia (regla forense): todo lo afirmado se verificó en código o en ejecución.

---

## 1. Veredicto en una línea

**El proyecto tiene un núcleo de strategy game sano, verificado y bien conectado (mapa, tiempo, movimiento, combate, captura, victoria, economía del jugador), pero HOY no arranca limpio: los dos sistemas más nuevos (eventos e IA) están muertos por un error de 1 línea cada uno, que además tumba en cascada el guardado y la economía; y el MVP aún no es "la Guerra del Pacífico" porque las fuerzas iniciales reales nunca se colocan en el mapa.**

## 2. Estado de arranque REAL (capturado hoy)

14 errores en boot. Causa raíz: 2 líneas + 3 anotaciones:

| Error | Archivo:línea | Efecto |
|---|---|---|
| `class_name EventManager` oculta autoload | EventManager.gd:1 | motor de eventos muerto (HALLAZGO-0001) |
| `class_name AIManager` oculta autoload | AIManager.gd:1 | IA muerta (0002) |
| Cascada de compilación | SaveLoadManager.gd:407,409 → NationalIncomeManager.gd | sin guardar/cargar, sin ingresos (0003) |
| `:=` sobre Variant | BattleResultPopup.gd:42-43 | popup de batalla muerto, escena principal sucia (0004) |
| `:=` sobre Variant | VictoryScreen.gd:24 | pantalla de victoria muerta (0005) |

Es la **tercera recurrencia** del mismo patrón (DT-02) — el proyecto necesita un guard-rail automático (0035), no otro parche puntual.

## 3. Lo que SÍ está demostrado funcionando (evidencia de ejecución)

- Escenario 1879: 847 provincias / 9 países / fecha 1879-02-14 — carga repetidamente verificada.
- Integridad de datos: 4.322 JSON válidos, 0 IDs duplicados, 0 referencias rotas (adyacencia simétrica, estados 847/847, regiones 847/847, escenas sin recursos rotos, 0 preloads rotos, 0 .uid huérfanos).
- Cadena jugable: clic → selección → movimiento adyacente → choque → batalla → captura de provincia → señal de victoria. Verificada paso a paso en headless durante la sesión.
- Economía del jugador: +291 oro/mes Chile, +720,5 Perú (el salitre peruano manda — históricamente correcto).
- Selección de nación y propagación del player_tag a guardado/movimiento.

## 4. La brecha del MVP

Aun arreglando el arranque, **no hay partida real** porque: las fuerzas iniciales del escenario (`starting_forces`, 11 unidades históricamente ubicadas) **no tienen consumidor** (0006) y lo que existe son "formaciones de prueba" sin posición (0007); la posición de las unidades **no se guarda** (0009); y el combate usa una **heurística** porque las formaciones no llevan plantilla de equipo (0024). Eventos e IA — los dos sistemas que convierten el sandbox en la Guerra del Pacífico — están escritos y completos (7 efectos; objetivos+órdenes) pero muertos (0001/0002).

## 5. Duplicidad de carpetas — resuelta con evidencia

`epochs-of-ascendancy/` es un **subconjunto estricto** de la carpeta viva: 0 archivos únicos, 0 archivos donde sea más nueva, 2.433 idénticos por hash, 26 divergentes todos más nuevos en `hoi-4-nueva-version/` (que además es el repositorio git). **Consolidar es seguro: no se pierde nada.** Detalle y procedimiento en `MATRIZ_DE_DUPLICIDAD_DE_CARPETAS.md`.

## 6. Hallazgos

35 hallazgos numerados con archivo/línea/fragmento en `HALLAZGOS.md`: 5 CRÍTICOS, 8 ALTOS, 14 MEDIOS, 8 BAJOS. Cada matriz los referencia por ID.

## 7. Fase 30 — verificación cruzada

- Recuento final: N = 5.067 / M = 5.067 (checklist `_progreso.md` al 100%).
- Segunda pasada sobre los 20 archivos críticos: TimeManager, ScenarioLoader (+4 auxiliares), MapManager, MapRenderer, Province, Formation, LeaderManager (secciones), CombatResolver, BattleManager, UnitMovementSystem, VictoryConditions, NationalIncomeManager, SaveLoadManager (secciones), EventManager, AIManager, TopInfoBar, ProvinceInsight (sección), TradeManager (secciones), project.godot, scenario.json — todas las citas de línea de los hallazgos CRÍTICO/ALTO provienen de lectura directa.
- Hallazgos sin línea citable: solo 0027 (semántica de duration_months=-1), marcado PENDIENTE DE CONTEXTO.

## 8. Entregables

`_progreso.md`, `INDICE_EXHAUSTIVO_DE_CODIGO.md`, `HALLAZGOS.md`, matrices de SISTEMAS / INTEGRACION / CAPACIDADES / RIESGOS / DEUDA_TECNICA / BLOQUEADORES_MVP / CONTENIDO / COBERTURA_HISTORICA / SIMULACION / PERSISTENCIA / DUPLICIDAD_DE_CARPETAS, `RESUMEN_EJECUTIVO_NO_TECNICO.md`, `PLAN_DE_ACCION_PRIORIZADO.md`, y la evidencia bruta (`_boot_actual.log`, `_scan.json`, `_integration.json`, `_godot_checks.json`, `_inventario.json`).
