# HALLAZGOS — Auditoría Integral Total

Fecha: 2026-06-12 · Carpeta auditada: ambas (`epochs-of-ascendancy/` + `hoi-4-nueva-version/`) · N=M=5.067 archivos procesados.
Severidades: CRÍTICO / ALTO / MEDIO / BAJO según definición del protocolo.

---

## CRÍTICOS (el juego NO arranca limpio hoy — verificado ejecutando el motor)

### HALLAZGO-0001 — `class_name EventManager` oculta su propio autoload: el motor de eventos NO carga
- Sistema: Eventos · Archivo: `EventManager.gd` · Ruta: `hoi-4-nueva-version/scripts/events/EventManager.gd` · Clase: EventManager · Línea: **1**
- Fragmento: `class_name EventManager` (línea 1) + `project.godot [autoload] EventManager="*res://scripts/events/EventManager.gd"`
- Evidencia (boot real capturado en `_boot_actual.log:3,10,19`): `Parse Error: Class "EventManager" hides an autoload singleton` → `Failed to instantiate an autoload ... does not inherit from 'Node'`.
- Impacto: el motor de eventos (que implementa los 7 tipos de efecto y carga `data/events/1879/`) está escrito y completo pero **muerto**: ningún evento histórico se dispara.
- Riesgo: además contamina la cadena de compilación (ver HALLAZGO-0003). Es la 3ª recurrencia del patrón DT-02 ya documentado en TimeManager.gd:42-50 y MapManager.gd:14-20.
- QUÉ NOTA EL JUGADOR: las fechas históricas pasan (14-feb-1879, Iquique, Angamos…) y no ocurre absolutamente nada.

### HALLAZGO-0002 — `class_name AIManager` oculta su autoload: la IA NO carga
- Sistema: IA · Archivo: `AIManager.gd` · Ruta: `hoi-4-nueva-version/scripts/ai/AIManager.gd` · Línea: **1**
- Fragmento: `class_name AIManager` + autoload homónimo en `project.godot`.
- Evidencia: `_boot_actual.log:11,21` (mismos mensajes que 0001).
- Impacto: la IA (491 líneas: objetivos estratégicos, órdenes de movimiento vía UnitMovementSystem, lectura de `initial_war_state`/`country_colors`) está escrita pero **nunca se instancia**.
- QUÉ NOTA EL JUGADOR: las naciones enemigas no hacen nada; el jugador juega contra estatuas.

### HALLAZGO-0003 — Cascada: SaveLoadManager y NationalIncomeManager no compilan → sin guardado y sin economía
- Sistema: Persistencia + Economía · Archivo: `SaveLoadManager.gd` · Ruta: `hoi-4-nueva-version/scripts/autoload/SaveLoadManager.gd` · Líneas: **407, 409, 461-465**
- Fragmento (línea 407): `data["event_manager"] = EventManager.get_save_data() if typeof(EventManager) != TYPE_NIL else {}`
- Evidencia: `_boot_actual.log:13-17` — `Failed to compile depended scripts` en SaveLoadManager.gd:0 y `Failed to load script .../NationalIncomeManager.gd` (este último referencia a SaveLoadManager en su línea 188).
- Impacto: al fallar el parseo de EventManager/AIManager (0001/0002), todo script que los nombra estáticamente cae en cascada. **Hoy no se puede guardar, cargar, ni cobrar ingresos.**
- QUÉ NOTA EL JUGADOR: F5/guardar no funciona; el oro mensual no llega.

### HALLAZGO-0004 — `BattleResultPopup.gd` no parsea y está instanciado en la escena principal
- Sistema: UI de combate · Archivo: `BattleResultPopup.gd` · Ruta: `hoi-4-nueva-version/scripts/ui/BattleResultPopup.gd` · Líneas: **42-43**
- Fragmento: `var att_cas := result.get("attacker_casualties", 0)` — inferencia `:=` desde Variant = error de parseo en este proyecto.
- Evidencia: `_boot_actual.log:29-35` + `TestScenario.tscn` lo referencia (escena principal `run/main_scene`).
- Impacto: el popup de resultado de batalla nunca aparece; la escena principal arranca con un script roto.
- QUÉ NOTA EL JUGADOR: gana o pierde una batalla y no se le informa de nada.

### HALLAZGO-0005 — `VictoryScreen.gd` no parsea: no hay pantalla de victoria
- Sistema: UI de victoria · Archivo: `VictoryScreen.gd` · Ruta: `hoi-4-nueva-version/scripts/ui/VictoryScreen.gd` · Línea: **24**
- Fragmento: `var winner_name := nation_names.get(winner_tag, winner_tag)` (misma inferencia inválida).
- Evidencia: `_boot_actual.log:40-43`. El script sí conecta `VictoryConditions.victory_achieved` (línea 12) — diseño correcto, ejecución muerta.
- QUÉ NOTA EL JUGADOR: cumple la condición de victoria y el juego no lo celebra ni termina.

---

## ALTOS

### HALLAZGO-0006 — `starting_forces` del escenario no tiene consumidor: no hay ejércitos colocados
- Sistema: Escenario/Despliegue · Archivo: `data/scenarios/1879/scenario.json` (sección `starting_forces`, 11 entradas válidas) · Consumidor: **ninguno**.
- Evidencia: barrido mecánico de los 251 .gd — la cadena `"starting_forces"` no aparece en ningún script. `Formation.province_id` nace en `-1` (Formation.gd:35).
- QUÉ NOTA EL JUGADOR: empieza la Guerra del Pacífico sin ninguna unidad en el mapa que pueda seleccionar.

### HALLAZGO-0007 — Las fuerzas reales son "formaciones de prueba" generadas por código
- Sistema: Escenario · Archivo: `ScenarioLoader.gd` · Ruta: `hoi-4-nueva-version/scripts/core/ScenarioLoader.gd` · Líneas: **306-318** (`_spawn_scenario_formations` → `spawn_test_formations_for_country`)
- Evidencia: log de arranque "Spawned 4 test formations for ARG/BOL/...".
- Impacto: placeholder estructural (violación de la regla NO PLACEHOLDER del protocolo de gobernanza) que sustituye a los ejércitos históricos.
- QUÉ NOTA EL JUGADOR: todas las naciones tienen ejércitos genéricos idénticos sin posición.

### HALLAZGO-0008 — 740 de 847 provincias no tienen geometría: el 87% del mapa es invisible
- Sistema: Mapa/datos · Archivo: `data/provinces/provinces_geometry.json` (107 polígonos) vs `provinces_base.json` (847).
- Evidencia: `MapDataValidator` (GEO_COVERAGE) + render real "Rendering map with 847... 107 nodos".
- QUÉ NOTA EL JUGADOR: la mayor parte del mundo no se puede ver ni clicar.

### HALLAZGO-0009 — La posición de las unidades NO se guarda
- Sistema: Persistencia · Archivo: `LeaderManager.gd` (`get_save_data` línea 2664) · Evidencia: la cadena `province_id` **no aparece** en LeaderManager.gd (grep = 0 resultados); el campo se añadió a `Formation.gd:35` pero la serialización de líderes/formaciones no lo incluye.
- QUÉ NOTA EL JUGADOR: guarda la partida con sus tropas en Tarapacá; al cargar, las tropas han desaparecido del mapa.

### HALLAZGO-0010 — Estados y regiones cargan pero no existen en runtime
- Sistema: Mapa · Archivo: `ScenarioLoader.gd:133-158` llena `province_state_by_id`/`province_region_by_id`; `Province.gd` y `MapManager.gd` no tienen `state_id`/`region_id` (grep = 0).
- Impacto: imposible preguntar "¿qué provincias forman Tarapacá?" → bloquea anexiones por estado (Tratado de Ancón).
- QUÉ NOTA EL JUGADOR: las cesiones territoriales históricas no pueden representarse como bloques.

### HALLAZGO-0011 — Carpeta duplicada `epochs-of-ascendancy/` (2.492 archivos residuales)
- Evidencia: matriz de duplicidad — 0 archivos únicos en epochs, 0 divergentes más nuevos en epochs; 2.433 idénticos + 26 divergentes (todos más nuevos en hoi-4). Subconjunto estricto, sin git.
- Riesgo: agentes/herramientas editando la copia muerta; confusión de rutas.
- QUÉ NOTA EL JUGADOR: nada directamente, pero el equipo pierde trabajo si edita la carpeta equivocada.

### HALLAZGO-0012 — La economía de la IA es cosmética
- Sistema: Economía · Archivos: `NationalIncomeManager.gd` (acumula `_ai_income`) y `ProductionManager.gd:40` (`var national_stockpile: Dictionary = {}` — **un único almacén**, el del jugador).
- Evidencia: grep "ai_income" en AIManager.gd = 0 resultados (la IA nunca gasta); `_ai_income` tampoco se persiste (get_save_data solo guarda `last_month_processed`, NationalIncomeManager.gd:163-165).
- QUÉ NOTA EL JUGADOR: la IA nunca compra, produce ni mejora nada con su dinero.

### HALLAZGO-0013 — La UI ignora el sistema de localización
- Sistema: UI/Localización · Evidencia mecánica: 203 asignaciones `.text = "..."` hardcodeadas en `scripts/ui/*` vs 5 usos de traducción. Textos mezclan inglés ("Save Game", TopInfoBar.gd:82-87) y español ("Selecciona tu Nación").
- QUÉ NOTA EL JUGADOR: interfaz bilingüe inconsistente; cambiar idioma no cambia casi nada.

---

## MEDIOS

### HALLAZGO-0014 — RNG sin semilla: partidas no reproducibles
- Evidencia: 65 usos de `randf/randi` (p. ej. `BattleManager.gd` ~líneas 93-94 `randf_range(0.85, 1.15)`); `seed(`/`set_seed` = 0 resultados en todo el proyecto.
- Impacto: dos partidas con las mismas decisiones divergen; imposible reproducir bugs de simulación.

### HALLAZGO-0015 — Sistema paralelo de fábricas: `ScenarioFactorySpawner` huérfano junto a `ScenarioFactoryBootstrap`
- Evidencia: `ScenarioFactorySpawner.gd` (class_name) con **0 referencias** en todo el código vivo; `ScenarioFactoryBootstrap.spawn_factories` (ScenarioFactoryBootstrap.gd:10) es quien ejecuta. Duplicación reconocida en CROSS_PHASE_FINDINGS.
- Impacto: violación de NO PARALLEL SYSTEM; doble fuente de lógica de spawn.

### HALLAZGO-0016 — Tres tests headless huérfanos
- `scripts/core/HeadlessProductionTest.gd`, `HeadlessSupplyTest.gd`, `HeadlessTradeTest.gd`: sin referencias desde escena, preload ni autoload (scan de huérfanos). Sin runner ni CI que los ejecute.

### HALLAZGO-0017 — `MapDataValidator` no está integrado en ningún flujo automático
- `scripts/map/MapDataValidator.gd` (validador completo, 354 líneas) con 0 usos en código vivo. Una regresión de datos no se detectaría sola. (DT-P6-07.)

### HALLAZGO-0018 — Anacronismos de equipo 1879 (HISTORICAL_REVIEW_REQUIRED)
- `data/unit_templates/1879/per_naval_1879.json` monta `uk_12inch_mk10` (cañón de 1918) como proxy del Huáscar; infantería usa `m1903_springfield_rifle`/`ottoman_mauser_rifle`. Sin módulos Comblain/Chassepot/Krupp de época.
- QUÉ NOTA EL JUGADOR: nombres y números de equipo fuera de época si inspecciona unidades.

### HALLAZGO-0019 — No existe árbol tecnológico de época 1879
- `data/technology/starting/1879.json` usa proxies industriales (`tank_plant_i`, `medium_tank_ii`); los árboles (`data/technology/trees/*`) van de 1918 a 2026.
- QUÉ NOTA EL JUGADOR: investiga "planta de tanques" en 1879.

### HALLAZGO-0020 — Opción de menú "Return to Main Menu" es un TODO impreso
- `TopInfoBar.gd:424`: `print("TODO: Return to Main Menu (emit signal for scene change)")` y `MainMenu.gd:210` `print("Return to Main Menu requested (implement scene change)")`. Violación NO PLACEHOLDER visible al jugador.

### HALLAZGO-0021 — 45 señales emitidas sin ningún listener
- Lista completa en `MATRIZ_DE_INTEGRACION.md`. Destacan: todas las de `AgentManager` (misiones de espionaje sin UI) y 9 de `ProductionManager` (progreso/escasez sin UI).
- QUÉ NOTA EL JUGADOR: sistemas enteros trabajan en silencio sin feedback.

### HALLAZGO-0022 — 5 señales declaradas que jamás se emiten
- `MapManager.province_selected:25` y `province_hovered:24` (la selección real va por otra vía — quien se suscriba a ellas espera para siempre); `LeaderManager.trait_leveled:13`, `training_path_invested:14`, `training_path_switched:15`.

### HALLAZGO-0023 — Migración de partidas guardadas es un stub
- `SaveLoadManager.gd` `_migrate_save_data` (~línea 760): existe el gancho pero sin ninguna migración. Cambios de esquema romperán partidas viejas silenciosamente.

### HALLAZGO-0024 — El poder de combate real proviene de una heurística, no de stats
- `BattleManager.gd` `_combat_power`: como las formaciones de prueba no tienen plantilla con stats, `get_effective_combat_power` devuelve vacío y opera el respaldo `power = 10 + infra + dev` (verificado en runtime: poderes 16.9 vs 22.8).
- QUÉ NOTA EL JUGADOR: el equipo, los diseños y la producción casi no influyen en quién gana.

### HALLAZGO-0025 — El perdedor de una batalla no vuelve a su provincia de origen
- `BattleManager.gd` `_retreat_formation`: se retira a cualquier adyacente propia o desaparece (`province_id = -1`). El origen del movimiento no se rastrea.

### HALLAZGO-0026 — Autosave al salir sobrescribe siempre el mismo slot
- `SaveLoadManager` autosave en `NOTIFICATION_WM_CLOSE`/salida → `autosave.json` único. Un cierre accidental pisa el autosave bueno anterior.

### HALLAZGO-0027 — Eventos: `duration_months: -1` con semántica no definida en el aplicador
- `data/events/1879/batalla_tacna.json` usa `-1` (permanente); el flujo de expiración de NationalModifierManager descuenta meses — comportamiento ante -1 PENDIENTE DE CONTEXTO (revisar al revivir EventManager).

---

## BAJOS

### HALLAZGO-0028 — UID inválido en WorldMap.tscn
- `scenes/WorldMap.tscn:3` — `invalid UID: uid://c6uhgynax25qv` para MapRenderer.gd; Godot resuelve por ruta (warning en cada arranque).

### HALLAZGO-0029 — Fugas al cerrar
- Boot real: `ObjectDB instances leaked at exit` + `38-39 resources still in use`. No afecta a la partida; ensucia diagnósticos.

### HALLAZGO-0030 — Almirante al mando de una división
- Warning real en boot: `LeaderManager: leader type mismatch — admiral cannot lead Division 0`. Asignación automática no filtra por tipo.

### HALLAZGO-0031 — Sin años bisiestos
- `TimeManager.gd:248-255` `_get_days_in_month` → febrero siempre 28. Deriva de fechas históricas a largo plazo (aceptable para MVP).

### HALLAZGO-0032 — 16 marcas TODO/FIXME en código vivo
- Detalle por archivo/línea en `INDICE_EXHAUSTIVO_DE_CODIGO.md` (anomalías TODO_FIXME).

### HALLAZGO-0033 — La documentación de fases caduca al instante (consistencia)
- `docs/PHASE_*` declaran "arranque limpio verificado" (cierto en su fecha) pero el estado real de HOY es arranque roto (hallazgos 0001-0005). Los reports no son evidencia del presente: regla forense confirmada.

### HALLAZGO-0034 — `metadata.scenario_id` se inicializa "1936" antes de corregirse
- `SaveLoadManager.gd:317` hardcodea `"scenario_id": "1936"` que la línea ~372 sobrescribe con el escenario real. Funcional pero confuso; si la 372 falla, los saves mienten.

### HALLAZGO-0035 — Patrón DT-02 sin guard-rail (causa raíz de 0001/0002)
- 3 incidencias del mismo error (`VictoryConditions` —corregido en sesión—, `EventManager`, `AIManager`). No existe chequeo automático que impida registrar un autoload cuyo script declare `class_name` homónimo.
