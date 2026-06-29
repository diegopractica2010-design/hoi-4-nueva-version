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
- **E3 — Iquique y Angamos no tienen efecto real.** Los eventos buscan la unidad `per_naval_1879`, que no existe como ID en el juego (las flotas se llaman `PER_formation_N`). Las batallas navales son solo texto.
- **E4 — Las unidades no usan sus estadísticas históricas.** El juego despliega formaciones genéricas ("División 1", "Flota 1") y solo les asigna provincia; las plantillas (`chl_naval_1879`, etc.) no llegan al campo.
- **E5 — Código de pruebas corre dentro de la partida real.** 🔧 ARREGLADO. `TestRunner` ya no ejecuta las baterías de prueba (producción, validación de autoloads, integrales) al entrar a jugar — solo bajo el flag QA/CI. (Pendiente menor: renombrar la escena `TestScenario`/`TestRunner` a algo de producción, pero ya no corre tests en partida.)

## 🟠 IMPORTANTES

- **E6 — Parte de la QA está rota.** Tres archivos cargan `ProductionLineTest`/`SupplyLineTest` desde `scripts/core/` (ruta inexistente; están en `tests/`) → devuelve null y crashea. Los informes "todo pasa" no son fiables.
- **E7 — 56 marcadores de código incompleto** (TODO/stub/"NOT IMPLEMENTED"): comercio (`TradeManager` casi sin implementar), sabotaje de agentes sin efecto real, migración de guardados como stub.
- **E8 — Provincias de relleno de la 2ª Guerra Mundial en el escenario 1879** (capitales de Alemania/Francia/Inglaterra/EE.UU., ids 2, 4, 5, 6, con fábricas).
- **E9 — Etiqueta del Reino Unido inconsistente:** el escenario usa `ENG` pero el archivo es `united_kingdom.json`. Verificar que ese país cargue bien.
- **E10 — El reloj depende de la barra superior.** El tiempo solo avanza si `TopInfoBar` llama a `advance_real_time`. Verificar que la fecha corre en partida.

## 🟡 MENORES / LIMPIEZA

- **E11 — Nombre del proyecto obsoleto:** "Epochs-of-Ascendancy" (se ve en el título de la ventana y en los logs) en vez de Guerra del Pacífico.
- **E12 — Menús duplicados:** `StartMenu` (el que se usa) y `MainMenu` (solo en la pantalla de victoria).
- **E13 — Archivo redundante:** `data/scenarios/1879.json` es un redirect que nunca se usa.
- **E14 — Peso muerto.** 🔧 ARREGLADO. Se movieron 2315 archivos del proyecto viejo (escenarios 1918/1936/2026, generales mundiales y todo el legado HOI2) a la carpeta `expansion_wwii/`, desconectada del juego y ordenada para una futura expansión. Verificado: el MVP 1879 sigue arrancando sin errores.
- **E15 — Ruido documental:** 40+ informes .md de auditoría contradictorios.
- **E16 — Plantilla sin usar:** `chl_cavalry_1879` existe pero no aparece en las fuerzas iniciales.
- **E17 — Antofagasta (prov. 841) doble:** nace ya controlada por Chile y además el evento de inicio la transfiere.

---

## 🆕 Hallazgos de la prueba EN VIVO

- **✅ E1 reparado confirmado EN VIVO:** el juego entra a la partida. Se dispara el evento inicial "Chile ocupa Antofagasta", declara guerras (CHL vs BOL/PER), transfiere prov. 841, y muestra mapa + barra superior + panel de suministro.
- **E21 (contenido) — Recursos anacrónicos en la barra superior.** Aparecen Steel / Aluminum / Oil / Rubber (todos en 0). Petróleo, caucho y aluminio no eran recursos de 1879. Deberían ser salitre, guano, plata, cobre, carbón.
- **E22 (UX) — Panel de provincia demasiado técnico (parece debug).** Muestra "supply ×0.58", "reinf ×0.48", "interdiction resist ×1.04", "Depot 65% strained"… abruma al jugador; falta lenguaje sencillo.
- **E23 (diseño) — El mapa se ve oscuro y plano.** Polígonos planos sin relieve ni textura; poco legible y poco atractivo.

- **Configuración: ✅ funciona.** Idioma (English/Español), Dificultad de la IA (Fácil/Normal/Difícil), botón Cerrar. Nota: muestra "Audio y gráficos: pendientes (no hay assets aún)" → el juego no tiene imágenes/sonido todavía.
- **Pantalla "Elige tu país": ✅ funciona.** Salen Chile/Perú/Bolivia con dificultad, objetivo y descripción, bordes de color por país y botón "Volver al menú".
- **E19 (diseño) — Pantalla de selección con fondo plano y tarjetas vacías.** Mismo fondo aburrido que el menú; las tres tarjetas son enormes con mucho espacio negro y solo texto centrado, sin banderas ni ilustraciones.
- **E20 (texto) — Faltan tildes en toda la interfaz.** "Elige tu pais", "PERU", "situacion historica", "Tarapaca", "presion politica", "dificiles", etc. Texto sin acentos.

- **E18 (diseño) — Fondo del menú pobre.** 🔧 arreglado (pendiente de revisión visual). Se reemplazaron los rectángulos planos por una portada ilustrada `assets/ui/menu_background.svg` (escena bélica al atardecer: Huáscar, infantería, caballería, cañón, Andes, cóndor y los colores de las 3 banderas). Conectado en `StartMenu.gd` con respaldo automático al fondo viejo si la imagen no carga.
