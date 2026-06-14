# BUGS — Testing total

Severidad: CRÍTICO (crashea/corrompe) · ALTO (el jugador lo sufre) · MEDIO (molesto/incorrecto) · BAJO (cosmético).

---

## YA REPARADOS durante esta sesión (bloqueaban el testing — se arreglaron porque impedían ejecutar las demás pruebas)

### BUG-0001 / CRÍTICO / RESUELTO — El juego no arrancaba (5 scripts rotos en cadena)
- Reproducción: ejecutar el proyecto → 14 errores en boot.
- Causa: `class_name EventManager`/`AIManager` (línea 1) ocultaban su autoload; `:=` sobre Variant en `BattleResultPopup.gd:42-43` y `VictoryScreen.gd:24`; cascada a SaveLoadManager/NationalIncomeManager.
- Arreglo aplicado: quitar `class_name` (2) + tipos explícitos (3). Evidencia tras arreglo: `_boot_postfix2.log` = 0 errores.
- QUÉ NOTABA EL JUGADOR: eventos, IA, guardar y economía muertos; ahora vivos.

### BUG-0011 / ALTO / RESUELTO — Error de runtime en TopInfoBar al mostrar estado de guerra
- Reproducción: cargar partida → `TopInfoBar._update_war_status` (línea 274) accedía `theme_override_colors["font_color"]` (inválido en Godot 4).
- Arreglo: `add_theme_color_override("font_color", color)`. Evidencia: error desaparece en `_boot_postfix2.log`.
- QUÉ NOTABA EL JUGADOR: la barra superior crasheaba al colorear el indicador de salitre.

---

## ABIERTOS (registrados, NO arreglados — el testing no arregla salvo bloqueo)

### BUG-0002 / ALTO / **RESUELTO** (ver REPARACIONES.md) — La posición de las unidades NO se guarda
- Reproducción: mover una formación a una provincia, guardar, cargar.
- Esperado: la unidad sigue donde estaba. Obtenido: el save (`leaders`) NO contiene `province_id` (inspección de `test_harness.json`: `leaders incluye province_id? False`).
- Evidencia: `LeaderManager.get_save_data()` no serializa el campo nuevo `Formation.province_id`.
- QUÉ NOTA EL JUGADOR: guarda con sus tropas en Tarapacá; al cargar, han desaparecido del mapa.

### BUG-0003 / MEDIO / **RESUELTO** — AgentManager devuelve un Array sin tipar como `Array[Agent]`
- Reproducción: instanciar/abrir AgentAssignmentScreen.
- Evidencia (`_scenes.log:21,30`): `Trying to return an array of type "Array" where expected return type is "Array[Agent]"`.
- Causa probable: `return algo.duplicate()` o `return []` sin tipo en una función `-> Array[Agent]` (mismo patrón Godot 4 que ya causó el bug de idiomas vacío en localización).
- QUÉ NOTA EL JUGADOR: la pantalla de agentes puede mostrarse vacía o fallar al listar agentes.

### BUG-0004 / MEDIO — Simulación lenta: ~31 ms por día de juego
- Reproducción: soak headless. Evidencia: `ms_por_dia` = 32.8 / 31.6 / 30.8 / 31.1; 1 año ≈ 10,6 s de CPU.
- Impacto: a velocidad rápida la simulación va a tirones; escalará peor con más sistemas/provincias activas.
- Sospecha: trabajo diario sobre las 847 provincias (reparación de infra) + evaluación diaria de IA + eventos cada día.
- QUÉ NOTA EL JUGADOR: al poner velocidad máxima, el tiempo no corre fluido.

### BUG-0005 / ALTO / **RESUELTO** — No hay fuerzas iniciales reales; se generan formaciones de prueba
- Reproducción: cargar 1879 → 52 formaciones genéricas, ninguna con posición (`province_id=-1`); `starting_forces` del escenario no se consume.
- Evidencia: barrido de código (clave `starting_forces` no leída por ningún .gd); log "Spawned 4 test formations for...".
- QUÉ NOTA EL JUGADOR: empieza la guerra sin ejércitos colocados en sus ciudades históricas.

### BUG-0006 / MEDIO — UI bilingüe inconsistente, fuera del sistema de traducción
- Evidencia: 203 asignaciones `.text="..."` hardcodeadas en `scripts/ui/*` vs 5 usos de traducción; mezcla EN ("Save Game") / ES ("Selecciona tu Nación").
- QUÉ NOTA EL JUGADOR: menús mezclando inglés y español; cambiar idioma casi no cambia nada.

### BUG-0007 / MEDIO / **RESUELTO (parcial)** — RNG sin semilla: partidas no reproducibles
- Evidencia: 65 usos de `randf/randi`, 0 `seed()`. El combate (`BattleManager._combat_power`) usa `randf_range(0.85,1.15)` sin semilla. (La economía/eventos sí salieron deterministas: run1==run2.)
- QUÉ NOTA EL JUGADOR: repetir la misma batalla da resultados distintos; imposible reproducir una situación.

### BUG-0008 / BAJO — Avisos de cierre y UID inválido
- Evidencia (cada arranque): `ObjectDB instances leaked at exit`, `39 resources still in use at exit`, `WorldMap.tscn:3 invalid UID uid://c6uhgynax25qv`.
- QUÉ NOTA EL JUGADOR: nada visible; ensucia diagnósticos y puede crecer.

### BUG-0009 / BAJO — `scenario_id` vacío en metadatos del guardado
- Evidencia: `metadata.scenario_id = ''` en `test_harness.json` (SaveLoadManager no resolvió el nombre de escenario en este flujo).
- QUÉ NOTA EL JUGADOR: la lista de guardados puede no mostrar a qué escenario pertenece la partida.

### BUG-0010 / MEDIO — Opción de menú con TODO y sin pantalla de inicio real
- Evidencia: `TopInfoBar.gd:424` y `MainMenu.gd:210` imprimen "TODO/implement scene change"; el "MainMenu" es un popup de pausa, no una pantalla de inicio.
- QUÉ NOTA EL JUGADOR: "Volver al menú principal" no hace nada; no hay un menú principal de verdad al abrir el juego.

### BUG-0012 / MEDIO — Popups que se auto-cierran al abrirse sin datos (instanciación aislada)
- Reproducción: instanciar LeaderDetailScreen / LeaderReplacementPickerPopup / MissionPickerPopup / RetirementOfferPopup sin contexto → su `_ready` las libera.
- Veredicto: probablemente POR DISEÑO (necesitan un objetivo), pero implica que no se pueden probar de forma aislada → requieren prueba de integración o humana.
- QUÉ NOTA EL JUGADOR: nada si se abren correctamente desde el juego; pendiente de verificación con datos reales.

### BUG-0013 / MEDIO — Instanciación aislada de 4 escenas de tecnología/UI se cuelga (timeout)
- Reproducción: el test de escenas se colgó tras TechnologyGraphView; no se alcanzaron TechnologyMissionTargetPopup, TechnologyScreen, TopInfoBar, TrainingPathScreen en 90 s.
- Veredicto: BLOQUEADA — posible `await` a una señal que no llega al instanciar sin contexto, o carga muy pesada. Requiere revisión.
- QUÉ NOTA EL JUGADOR: pendiente; podría indicar un cuelgue real al abrir alguna de esas pantallas en mal momento.
