# Resumen ejecutivo (no técnico)

**Para:** dirección de producto/diseño · **Fecha:** 2026-06-12 · **Auditados:** 5.067 archivos (las dos carpetas), con el juego ejecutado de verdad para comprobar cada afirmación.

---

## La foto en tres frases

1. **El esqueleto del juego está vivo y funciona:** el mapa carga, el tiempo corre, mueves ejércitos, hay batallas, se conquistan provincias, entra oro cada mes y existen condiciones de victoria de la Guerra del Pacífico. Todo eso lo hemos visto funcionar de verdad, no en papel.
2. **Pero hoy, ahora mismo, el juego arranca roto:** los dos sistemas más nuevos (los eventos históricos y la inteligencia artificial enemiga) tienen un error de UNA línea cada uno que no solo los mata a ellos, sino que arrastra al sistema de guardar partida y al de ingresos. Es el mismo tipo de error que ya nos pasó dos veces antes.
3. **Y aunque arranque, todavía no es "la Guerra del Pacífico":** los ejércitos históricos están definidos en datos (quién empieza dónde: Santiago, Antofagasta, Lima, Arica…) pero **nadie los coloca en el mapa**; lo que se mueve son tropas de prueba genéricas.

## Qué nota el jugador hoy

- Abre el juego → funciona el mapa y el reloj, elige nación. ✔
- Llega el 14 de febrero de 1879 → **no pasa nada** (eventos muertos).
- El enemigo → **no hace nada** (IA muerta).
- Pulsa guardar → **no guarda**.
- Gana una batalla → **nadie se lo dice** (ventana de resultados rota).
- Cumple su condición de victoria → **el juego no lo celebra** (pantalla de victoria rota).

## La buena noticia

Casi todo lo roto se arregla con **cambios mínimos** (borrar 2 líneas, anotar 3 tipos): los sistemas muertos están **completos por dentro** — el motor de eventos implementa los 7 efectos históricos y la IA sabe elegir objetivos y mover tropas. Es como un coche nuevo con el cable de la batería suelto.

## Qué arreglar primero (en orden)

1. **Hoy mismo:** las 5 líneas que rompen el arranque (con eso reviven eventos, IA, guardado, ingresos y las dos pantallas). Esfuerzo: pequeño.
2. **Esta semana:** poner un "detector automático" para que ese error de una línea no vuelva a colarse una cuarta vez, y un chequeo de arranque obligatorio antes de subir cambios. Esfuerzo: pequeño.
3. **El salto a "juego de verdad":** colocar los ejércitos históricos al empezar (los datos ya existen), guardar la posición de las tropas (hoy se pierden al cargar), y conectar las tropas con su equipo real para que las batallas dependan de algo más que un dado. Esfuerzo: mediano.
4. **Limpieza segura:** la carpeta vieja duplicada (`epochs-of-ascendancy`) se puede archivar y borrar — está demostrado archivo por archivo que no contiene nada único.

## Qué es más a futuro (no urgente)

- El 87% del mapa mundial no se dibuja (solo el teatro de guerra y capitales tienen forma) — decisión de diseño pendiente: ¿completar el mundo o recortar el mapa al teatro?
- El armamento usa nombres de 1918 como sustitutos (no existen aún el fusil Comblain ni los monitores de época).
- La interfaz mezcla inglés y español y no usa el sistema de traducción que ya construimos.
- No hay sonido ni arte propio todavía.

## En una línea

**Un buen motor con el contacto desconectado: 5 líneas lo encienden; un sprint corto lo convierte en la Guerra del Pacífico jugable.**
