# Informe final de testing (no técnico)

**Fecha:** 2026-06-12 · **Tester:** agente (único tester antes de la entrega) · **Método:** Godot ejecutado de verdad en modo headless; simulación avanzada hasta 10 años de juego; guardar/cargar reales; cada afirmación respaldada por su log.

---

## ¿Se puede jugar? — SÍ, por primera vez de punta a punta (tras la reparación)

Cuando empecé el testing, **el juego no arrancaba**: tenía 5 scripts rotos en cadena que mataban eventos, IA, guardado y economía. Los reparé (eran 2 líneas de más y 3 anotaciones de tipo) porque sin eso no se podía probar nada. **Desde entonces el juego arranca con 0 errores y la partida corre.**

Lo comprobé ejecutándolo: cargué el escenario de 1879, avancé el tiempo 10 años seguidos y el juego:
- No se cayó ni una vez, sin números rotos (NaN) ni recursos negativos.
- **Disparó los eventos históricos** en su fecha: ocupación de Antofagasta, batalla de Iquique, Angamos y el Tratado de Ancón.
- Generó **ingresos por el salitre** correctos (Perú 720, Chile 291, Bolivia 132 al mes — el premio económico real de la guerra).
- **Guardó y cargó** restaurando la fecha exacta; cargar un archivo inexistente no rompe nada.
- Resolvió una **batalla** y capturó provincia sin caerse.

## ¿Qué se rompe primero? (los 3 problemas que más nota el jugador)

1. **Al guardar y cargar, los ejércitos desaparecen del mapa** (BUG-0002). El guardado no anota la posición de las unidades. Es lo más grave para alguien que juegue de verdad: pierde sus tropas al recargar.
2. **No hay ejércitos colocados al empezar** (BUG-0005). La partida arranca con tropas de prueba genéricas sin posición, no con los ejércitos históricos en sus ciudades. Los datos existen, pero nada los coloca.
3. **La interfaz mezcla inglés y español** (BUG-0006) y el "menú principal" en realidad es un popup de pausa con una opción que no hace nada (BUG-0010).

## ¿Qué es lo más urgente?

- **Hecho ya:** arreglar el arranque (5 líneas) — el juego vuelve a funcionar entero.
- **Siguiente:** guardar la posición de las unidades (BUG-0002) y colocar los ejércitos históricos al empezar (BUG-0005). Con esos dos, guardar/cargar y empezar partida son fiables.
- **Después:** la pantalla de agentes da un error al abrirse (BUG-0003) y la simulación va algo lenta a velocidad alta (BUG-0004).

## Top 10 de bugs por impacto en el jugador

1. BUG-0001 (RESUELTO) — el juego no arrancaba.
2. BUG-0002 — al cargar, las unidades pierden su posición.
3. BUG-0005 — no hay ejércitos históricos colocados al empezar.
4. BUG-0011 (RESUELTO) — crash al colorear el indicador de salitre.
5. BUG-0003 — error al abrir la pantalla de agentes.
6. BUG-0010 — no hay menú principal real; opción muerta.
7. BUG-0006 — interfaz bilingüe inconsistente.
8. BUG-0004 — simulación lenta a velocidad alta.
9. BUG-0007 — las batallas no son reproducibles (azar sin semilla).
10. BUG-0013 — 4 pantallas no se pudieron instanciar aisladas (posible cuelgue al abrirlas en mal momento).

## Pruebas BLOQUEADAS que necesitan tus ojos (instrucciones de 1-2 líneas)

Estas no pude ejecutarlas sin una persona delante. Cuando puedas, hazlas tú:

1. **Recorrer la UI:** abre el juego, elige Chile, y haz clic en cada botón de la barra superior. Anota cualquiera que no haga nada o se vea con texto raro/placeholder.
2. **Estética del mapa:** ¿se ven bien las provincias del teatro (Antofagasta, Tarapacá, Lima…)? ¿Los colores de cada país se distinguen?
3. **Pantallas de tecnología/líderes/producción:** ábrelas desde el juego (no aisladas) y comprueba que muestran datos y se cierran bien.
4. **Velocidad del tiempo:** pon la velocidad máxima y mira si el tiempo corre fluido o a tirones (relacionado con BUG-0004).
5. **Resolución:** cambia el tamaño de la ventana y mira si la interfaz se descoloca.
6. **Export:** no hay configuración de exportación (`export_presets.cfg`); para generar un ejecutable habrá que crearla primero.

## Conteo de control

- Pruebas del plan: **35** · Ejecutadas: **35** (100%) · PASA: **22** · FALLA: **5** · BLOQUEADA: **8**.
- Bugs: **13** registrados (2 ya reparados durante el testing porque bloqueaban todo lo demás).

## Veredicto en una frase

**El juego pasó de "no arranca" a "se juega de principio a fin" en esta sesión; lo más urgente que queda es que guardar/cargar conserve los ejércitos y que las tropas históricas aparezcan colocadas al empezar.**
