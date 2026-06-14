# MVP listo — checklist final

Fecha: 2026-06-12 · Todo verificado ejecutando el motor (0 errores de script en arranque).

## Añadido esta tanda (verificado)

| Entregable | Estado | Evidencia |
|---|---|---|
| **Menú de inicio** | ✅ | `StartMenu.tscn` es ahora la escena de arranque: Nueva Partida / Cargar partida / Ajustes / Salir. Construye su UI sin errores. |
| **Cargar desde el menú** | ✅ | "Cargar" toma la partida más reciente, fija la nación desde el save y deja la carga pendiente; `TestRunner` la aplica al entrar. |
| **Tutorial mínimo** | ✅ | `TutorialPopup` se muestra la primera vez (marcador en `user://`), explica objetivo/mover/batallas/tiempo/guardar. Construye sin errores. |
| **Recorte de mapa al teatro** | ✅ | La cámara se encuadra sobre la zona de guerra al cargar (verificado: pos centrada, zoom 1,79×). Ya no muestra el mundo vacío. |
| **Ajustes** | ✅ | `SettingsPopup` con selector de idioma (usa el sistema de localización) + nota de audio/gráficos pendientes. |

## Estado del MVP por área

| Área | ¿Listo para MVP? |
|---|---|
| Arranque estable | ✅ 0 errores |
| Menú de inicio + flujo nueva/cargar partida | ✅ |
| Selección de nación | ✅ |
| Mapa enfocado en el teatro | ✅ |
| Tiempo (pausa/velocidad/eventos) | ✅ |
| Mover ejércitos | ✅ |
| Combate con profundidad (concentrar tropas + líderes deciden) | ✅ |
| IA enemiga que ataca | ✅ |
| Eventos históricos | ✅ |
| Economía (ingresos por salitre) | ✅ |
| Victoria/derrota con feedback en pantalla | ✅ |
| Guardar/cargar íntegro | ✅ |
| Tutorial mínimo | ✅ |
| Ajustes (idioma) | ✅ |
| Rendimiento | ✅ (~11 ms/día, 3× mejor) |

## ¿Qué falta TODAVÍA para que el MVP esté 100% listo?

### Pulido menor (recomendado antes de enseñarlo)
1. **Terminar la traducción** de los textos descriptivos largos restantes (la mayoría de botones/títulos ya están en español; quedan párrafos).
2. **Verificación visual humana** (lo único que no puedo hacer headless): abrir el juego y comprobar estética, que cada botón hace algo, y probar a 2 resoluciones. Instrucciones en `INFORME_FINAL.md`.
3. **Balance fino del combate**: ahora las decisiones importan (concentrar tropas gana), pero los números (cuánto bonus defensivo, ritmo de capturas) querrán ajuste jugando.

### Para una BETA (no MVP) — son sistemas/assets nuevos, no correcciones
4. **Arte** (banderas, retratos de líderes, iconos de unidad/recurso, fondo de mapa) — hoy todo es "programmer art".
5. **Audio** (música + efectos) — hoy no hay ninguno.
6. **Equipo/tecnología de época 1879** (Comblain, Chassepot, Krupp, monitores) en vez de proxies de 1918.
7. **Combate naval diferenciado** y **diplomacia** — sistemas grandes.
8. **Export**: crear `export_presets.cfg` para poder generar un ejecutable distribuible.

## Veredicto
**El MVP jugable está, en lo esencial, COMPLETO**: se arranca desde un menú, se aprende con el tutorial, se juega la Guerra del Pacífico con decisiones que importan (combate con profundidad + IA real), se reciben eventos y feedback, y se guarda/carga sin pérdida.

Lo que queda para "listo del todo" es **(a) verificación visual tuya** + **(b) terminar la traducción** + **(c) balance fino jugando**. Todo lo demás (arte, audio, naval, diplomacia, export) es **camino a beta**, no requisito del MVP.
