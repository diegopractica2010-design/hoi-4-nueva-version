# Lista de errores — MVP Guerra del Pacífico 1879

> Lista viva. Se va sumando lo que aparezca en la prueba en vivo.
> Estado de cada error: ⬜ pendiente · 🔧 arreglado · ✅ verificado en vivo

## ✔️ Lo que SÍ funciona (verificado en ejecución con Godot 4.6)
- El proyecto **compila sin un solo error** (148 scripts).
- Los tests de **producción y combate pasan**.
- El **menú principal carga perfecto** (título, botones Nueva partida / Cargar / Configuración / Salir).

---

## 🔴 CRÍTICOS

- **E1 — El arranque de partida se cuelga.** 🔧 ARREGLADO Y VERIFICADO. Causa: `TestRunner` corría toda la batería de tests al entrar a la partida, y una de esas pruebas dispara una simulación pesada de carreras de líderes (Patton, Guderian/1939) que no termina → la ventana quedaba "(No responde)" con las 3 naciones. Arreglo: los tests ahora solo corren en modo QA/CI, no en la partida del jugador. Verificado headless: el arranque carga 847 provincias y monta el mapa en segundos, sin simulación de líderes y sin colgarse.
- **E2 — Los líderes de 1879 eran los de 1918.** 🔧 ARREGLADO Y VERIFICADO. El archivo correcto `historical_leaders_1879.json` (16 generales: Prat, Grau, Baquedano, Condell, Prado, Cáceres, Daza, Campero…) ya existía; `LeaderManager` apuntaba por error al de 1918. Corregido el mapeo. Verificado: "Loaded 16 leaders from historical_leaders_1879.json for year 1879".
- **E3 — Iquique y Angamos no tienen efecto real.** 🔧 ARREGLADO. Los eventos ahora buscan la flota peruana por país y categoría (`TYPE_FLEET`) cuando no encuentran el ID exacto, y las formaciones iniciales se crean con su `formation_id` = nombre de plantilla (ej. `per_naval_1879`). Las batallas navales dañan/destruyen la flota correcta.
- **E4 — Las unidades no usan sus estadísticas históricas.** 🔧 ARREGLADO. `_deploy_starting_forces` ahora crea formaciones desde las plantillas JSON (`data/unit_templates/1879/*.json`) con su nombre histórico, tipo (Flota/División) y stats base. Adiós a "División 1 / Flota 1".
- **E5 — Código de pruebas corre dentro de la partida real.** 🔧 ARREGLADO. `TestRunner` ya no ejecuta las baterías de prueba (producción, validación de autoloads, integrales) al entrar a jugar — solo bajo el flag QA/CI. (Pendiente menor: renombrar la escena `TestScenario`/`TestRunner` a algo de producción, pero ya no corre tests en partida.)

## 🟠 IMPORTANTES

- **E6 — Parte de la QA está rota.** 🔧 ARREGLADO. Los tres archivos ahora cargan desde `res://tests/` y HeadlessSupplyTest usa escenario 1879 (no 2026).
- **E7 — 56 marcadores de código incompleto.** 🔧 PARCIALMENTE ARREGLADO.
  · `TradeManager`: recursos actualizados a salitre/guano/plata/cobre/carbón (1879). Generator de mercado público ahora ofrece bienes históricos (salitre por carbón, cobre por plata, guano por oro). `RESOURCE_BASE_RATES` actualizado.
  · `AgentManager`: DEFAULT_TARGET_COUNTRY_TAGS cambiado a CHL/PER/BOL/ARG/BRA/ENG/FRA/USA. Se agregaron espías históricos (Lynch, Vergara, Candamo, Montero, etc.) con `generate_named_agent()`. Sabotaje de suministro ahora conecta con SupplyManager.
  · `SaveLoadManager`: migración de guardados ya no es stub vacío — tiene casos reales para v0→v1 y v1→v2 (renombrado de recursos antiguos).
- **E8 — Provincias de relleno de la 2ª Guerra Mundial en el escenario 1879** 🔧 ARREGLADO. Se eliminaron las provincias 2/4/5/6 (GER/FRA/ENG/USA). Los países se mantienen como actores diplomáticos sin territorio.
- **E9 — Etiqueta del Reino Unido consistente.** ✅ YA ERA CONSISTENTE. `united_kingdom.json` tag=`ENG`, escenario usa `ENG` en provincias/stockpiles/colores. El cargador busca por tag interno.
- **E10 — El reloj avanza correctamente.** ✅ YA FUNCIONABA. `TopInfoBar._on_tick()` llama a `TimeManager.advance_real_time(1.0)` cada segundo.

## 🟡 MENORES / LIMPIEZA

- **E11 — Nombre del proyecto obsoleto:** 🔧 ARREGLADO. `project.godot` ahora dice "Guerra del Pacifico 1879", y el log de `TestRunner.gd` también.
- **E12 — Menús duplicados:** `StartMenu` (el que se usa) y `MainMenu` (solo en la pantalla de victoria). ⏳ Pendiente de decisión de diseño.
- **E13 — Archivo redundante:** 🔧 ARREGLADO. `data/scenarios/1879.json` eliminado.
- **E14 — Peso muerto.** 🔧 ARREGLADO. Se movieron 2315 archivos del proyecto viejo (escenarios 1918/1936/2026, generales mundiales y todo el legado HOI2) a la carpeta `expansion_wwii/`, desconectada del juego y ordenada para una futura expansión. Verificado: el MVP 1879 sigue arrancando sin errores.
- **E15 — Ruido documental:** 40+ informes .md de auditoría contradictorios. ⏳ Pendiente de decisión de diseño.
- **E16 — Plantilla sin usar:** 🔧 ARREGLADO. `chl_cavalry_1879` agregada a `starting_forces` de Chile en Santiago.
- **E17 — Antofagasta (prov. 841) doble:** 🔧 ARREGLADO. Ahora nace con owner=BOL/controller=BOL y el evento `guerra_inicio` hace la transferencia histórica a CHL.

---

## 🆕 Hallazgos de la prueba EN VIVO

- **✅ E1 reparado confirmado EN VIVO:** el juego entra a la partida. Se dispara el evento inicial "Chile ocupa Antofagasta", declara guerras (CHL vs BOL/PER), transfiere prov. 841, y muestra mapa + barra superior + panel de suministro.
- **E21 (contenido) — Recursos anacrónicos en la barra superior.** 🔧 ARREGLADO. Ahora muestra Salitre, Guano, Plata, Cobre, Carbón. Stockpiles de países actualizados con recursos de 1879.
- **E22 (UX) — Panel de provincia demasiado técnico (parece debug).** Muestra "supply ×0.58", "reinf ×0.48", "interdiction resist ×1.04", "Depot 65% strained"… abruma al jugador; falta lenguaje sencillo.
- **E23 (diseño) — El mapa se ve oscuro y plano.** 🔧 PARCIAL. Color de océano cambiado a azul marino profundo, colores de país más saturados (×1.15). ⏳ Pendiente real: que se vea Sudamérica con provincias-de-verdad (no hexágonos) — es la Fase 1 del plan v2 (mapa pintado en PNG).
- **E24 (control) — La cámara se movía sola al mover el mouse.** 🔧 ARREGLADO (Fase 0.1 plan v2). Causa real: el "edge-scroll" de `MapRenderer` (no CameraController, que se autodesactiva al existir MapCamera). Desactivado por defecto (`enable_edge_scroll=false`); también `CameraController.enable_edge_pan=false`. Mover la cámara ahora es WASD + arrastrar con botón central. Verificado headless: exit 0, 0 errores.
- **E24b (cámara) — Límites de cámara.** 🔧 ARREGLADO (Fase 0.2). `MapRenderer` ahora limita la cámara al rectángulo del mapa (`MapManager.get_world_bounds()` + margen) para no salir al vacío gris.
- **E25 (UI) — Paneles de la barra superior no se veían.** ⏳ PROBABLEMENTE resuelto por E24 (el edge-scroll movía el mapa al subir el mouse). Los paneles se agregan en espacio de pantalla. Pendiente de confirmación visual; si alguno sigue fuera de vista, arreglo puntual.

- **Configuración: ✅ funciona.** Idioma (English/Español), Dificultad de la IA (Fácil/Normal/Difícil), botón Cerrar. Nota: muestra "Audio y gráficos: pendientes (no hay assets aún)" → el juego no tiene imágenes/sonido todavía.
- **Pantalla "Elige tu país": ✅ funciona.** Salen Chile/Perú/Bolivia con dificultad, objetivo y descripción, bordes de color por país y botón "Volver al menú".
- **E19 (diseño) — Pantalla de selección con fondo plano y tarjetas vacías.** 🔧 ARREGLADO. Tarjetas rediseñadas con: bandera tricolor horizontal, nombre del país con su color, estrellas de dificultad (★), barras de stats (Ejército/Marina/Economía), descripción histórica y botón "▶ JUGAR".
- **E20 (texto) — Faltan tildes en toda la interfaz.** 🔧 ARREGLADO. Corregidas tildes en StartMenu.gd, NationSelectScreen.gd, TopInfoBar.gd.

- **E18 (diseño) — Fondo del menú pobre.** 🔧 arreglado (pendiente de revisión visual). Se reemplazaron los rectángulos planos por una portada ilustrada `assets/ui/menu_background.svg` (escena bélica al atardecer: Huáscar, infantería, caballería, cañón, Andes, cóndor y los colores de las 3 banderas). Conectado en `StartMenu.gd` con respaldo automático al fondo viejo si la imagen no carga.
