# Resultados de testing — evidencia por prueba

Fecha: 2026-06-12 · Motor: Godot 4.6 headless · Proyecto: hoi-4-nueva-version/
Comando base del arnés: `Godot...console.exe --headless "res://scripts/core/_test_harness.tscn"`

> NOTA: antes de testear se aplicó la reparación crítica solicitada ("repara y arregla todo").
> Sin ella el juego NO arrancaba. Detalle de lo reparado al final de este archivo.

---

## INFRAESTRUCTURA

| ID | Prueba | Veredicto | Evidencia |
|---|---|---|---|
| I-1 | Localizar Godot | **PASA** | `...\godot\Godot_v4.6-stable_win64_console.exe` operativo |
| I-2 | Boot headless sin errores | **PASA** (tras reparación) | `_boot_postfix2.log`: 0 SCRIPT/Parse/Compile/Failed |
| I-3 | Suite de tests existente (GUT) | **BLOQUEADA** | no hay `addons/` ni framework de tests en el proyecto |
| I-4 | Test runner headless | **PASA** | construido: `_test_harness.gd`, `_scene_loader_test.gd` |
| I-5 | Documentar comandos | **PASA** | ver `_plan.md` |

## SALUD BÁSICA Y DATOS

| ID | Prueba | Veredicto | Evidencia |
|---|---|---|---|
| B1 | Salud del log | **PASA con avisos** | 0 errores; persisten warnings benignos (ObjectDB leak / 39 resources / UID WorldMap) → BUG-0008 |
| B2 | Carga individual de escenas (23, excl. TestScenario) | ver sección escenas | `_scenes_final.log` |
| B3 | Validación masiva de datos | **PASA** | 4.322 JSON válidos, 0 IDs duplicados, 0 refs rotas (auditoría); `validate_province_layers.py` → "VALIDATION PASSED, provinces=847 states=75 regions=22" |

## PARTE A — flujo de jugador (vía arnés)

| ID | Prueba | Veredicto | Evidencia (TEST\|) |
|---|---|---|---|
| A1 | Arranque y menú | **PASA parcial** | boot llega a NationSelect; menú principal real es popup in-game (no pantalla de inicio) → BUG-0010 |
| A2 | Selección de nación | **PASA** | income computa para CHL/PER/BOL; redirección verificada |
| A3 | Mapa carga provincias | **PASA** | `provincias=847`, geometría 107 |
| A4 | Paso del tiempo | **PASA** | soak avanza fecha 1879→1889 sin fechas imposibles |
| A5 | Producción/economía | **PASA parcial** | oro entra (+291/mes CHL); pantallas no testeadas por entrada (BLOQUEADA visual) |
| A6 | Tecnología | **PASA carga** | TechnologyManager: 23 nodos; investigación activa no forzada (BLOQUEADA interacción) |
| A7 | Líderes y agentes | **FALLA parcial** | AgentManager error de tipo (BUG-0003) al abrir AgentAssignmentScreen |
| A8 | Formaciones | **PASA carga** | 52 formaciones; mover verificado en sesiones previas |
| A9 | Combate | **PASA** | `combate ... disparo=true`; batalla resuelta sin crash |
| A10 | Eventos y espíritus | **PASA** | `eventos_disparados=4` (guerra_inicio, Iquique, Angamos, Ancón) |
| A11 | Suministro | **PASA carga** | SupplyManager activo; efectos no aislados (BLOQUEADA medición fina) |
| A12 | Victoria/derrota | **PASA lógica** | `victoria_status` computa; VictoryScreen carga |
| A13 | Guardar y cargar | **PASA (con fallo de alcance)** | save/load restaura fecha exacta; PERO no guarda posición de unidades → BUG-0002 |
| A14 | Onboarding | **FALLA** | textos EN/ES mezclados; 203 textos hardcodeados (BUG-0006); menú con TODO (BUG-0010) |
| A15 | UI general | ver escenas | `_scenes_final.log` |

## PARTE B — pruebas de agente

| ID | Prueba | Veredicto | Evidencia |
|---|---|---|---|
| B4 | Soak 1mes/1año/5años/10años | **PASA** | sin NaN, sin negativos; oro 291→3492→17460→34920; sin crash a 10 años |
| B5 | Determinismo | **PASA parcial** | run1==run2 en oro/eventos/ingresos; RNG de combate sin semilla (BUG-0007) |
| B6 | Casos límite | **PASA parcial** | load inexistente → false sin crash; resto BLOQUEADA (requiere entrada UI) |
| B7 | Persistencia profunda | **PASA con hallazgo** | save tiene 16 secciones; falta province_id de formaciones (BUG-0002); scenario_id vacío (BUG-0009) |
| B8 | Rendimiento | **FALLA (lento)** | ~31 ms por día de juego simulado → BUG-0004; 1 año ≈ 10,6 s de CPU |
| B9 | Localización y textos | **FALLA** | mezcla EN/ES; 5 usos de traducción vs 203 textos fijos (BUG-0006) |
| B10 | Robustez de archivos | **PASA parcial** | save inexistente manejado; corrupción no forzada (BLOQUEADA) |
| B11 | Exportabilidad | **BLOQUEADA** | no existe `export_presets.cfg` |

---

## Detalle del soak (evidencia bruta)
```
estado[inicio] fecha=1879-02-14 oro=0.00     provincias=847 formaciones=52 sin_nan=true sin_negativo=true
estado[1mes]   fecha=1879-03-16 oro=291.00   ...
estado[1ano]   fecha=1880-02-14 oro=3492.00  ...
estado[5anos]  fecha=1884-02-14 oro=17460.00 ...
estado[10anos] fecha=1889-02-14 oro=34920.00 sin_nan=true sin_negativo=true
soak ms_por_dia: 32.8 / 31.6 / 30.8 / 31.1
eventos_disparados=4 ["guerra_pacifico_inicio","batalla_iquique","batalla_angamos","tratado_de_ancon"]
save_ok=true; load_ok=true; restaurada=true; load_inexistente=false (sin crash)
```

## Reparación aplicada antes del testing (bloqueaba todo)
1. `EventManager.gd:1` y `AIManager.gd:1`: quitado `class_name` (patrón DT-02) → reviven eventos, IA, guardado, ingresos.
2. `BattleResultPopup.gd:42-43` y `VictoryScreen.gd:24`: tipos explícitos (`:=` sobre Variant fallaba).
3. `TopInfoBar.gd:271-275`: `theme_override_colors[...]` → `add_theme_color_override` (error de runtime al revivir la UI).
Boot tras reparación: **0 errores** (`_boot_postfix2.log`).
