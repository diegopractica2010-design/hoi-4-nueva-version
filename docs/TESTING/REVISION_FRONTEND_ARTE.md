# Revisión de frontend y arte + correcciones de depth/balance/pulido

Fecha: 2026-06-12 · Todo verificado ejecutando el motor.

---

## A. Lo CORREGIDO esta tanda (código real, verificado)

### Profundidad y balance de combate ✅
**Antes:** combate instantáneo cara-o-cruz; 1 movimiento = 1 batalla; Perú arrollaba.
**Ahora:** el poder de cada bando = **suma de TODAS sus formaciones en la provincia** (concentrar el ejército decide) + **habilidad del líder** (ataque/defensa) + ventaja defensiva de terreno/fortín; azar reducido (0,92–1,08).
**Verificado:** 3 atacantes vs 1 defensor → ganan **20/20**; 1 vs 3 → **0/20**. Las decisiones del jugador (dónde masar tropas, qué general asignar) ahora deciden la batalla.
Además: la guerra ya no termina en el mes 1 (victorias militares gateadas a 1880+; victoria de Perú = expulsar a Chile, no solo defender).

### Rendimiento ✅
**Antes:** ~31 ms por día simulado (recorría 847 provincias cada día con cálculo pesado).
**Ahora:** **10,74 ms/día (~3× más rápido)**. La reparación de infraestructura pasa a cada 14 días (mismo efecto acumulado) y salta provincias ya al tope.

### Idioma de la UI ✅ (74 textos a español en 2 tandas)
Traducidos menú, gestor de guardado, y los botones/títulos/estados vacíos de las pantallas profundas (líderes, agentes, tecnología, espíritus, formaciones, reajuste, entrenamiento). Quedan algunos textos descriptivos largos sin traducir.

### "Volver al menú principal" ✅
Antes era un TODO muerto. Ahora reinicia: vuelve a la **selección de nación** (desde el menú de pausa y desde la pantalla de victoria).

---

## B. Revisión del FRONTEND

**Qué existe:** 22 escenas UI + 28 scripts UI. Cobertura funcional amplia:
- Barra superior (TopInfoBar): fecha, velocidad/pausa, recursos, navegación, estado de guerra (salitre/oro).
- Selección de nación, mapa interactivo (hover/clic/picking), popups de evento/batalla/victoria.
- Pantallas: Producción, Tecnología (+grafo), Líderes (+detalle), Agentes, Espíritus nacionales, Caminos de entrenamiento, gestor de guardado.
- Estilo unificado "Retrowave" por código (RetrowaveTheme): bordes cian, paneles oscuros, botones tematizados.

**Estado:** el frontend está **construido casi todo por código** (los .tscn son contenedores; las listas/botones se generan en _ready). Funciona y carga sin errores.

**Carencias del frontend (no bloqueantes para MVP):**
1. **No hay menú principal de inicio** propiamente dicho (el juego arranca en selección de nación). Aceptable, pero falta una pantalla Nueva/Cargar/Salir.
2. **Sin onboarding/tutorial**: ninguna pantalla explica qué hacer.
3. **Texto largo descriptivo** aún parcialmente en inglés.
4. **Sin verificación visual humana**: en headless confirmo que cargan y responden, pero la estética, el ajuste a distintas resoluciones y el "se siente bien" requieren tus ojos (ver INFORME_FINAL.md).
5. UI casi sin usar el sistema de localización (textos fijos por código): cambiar de idioma en caliente no funcionaría.

## C. Revisión del ARTE y AUDIO

**Hallazgo: el proyecto NO tiene arte ni audio propios.**
- Imágenes en todo el repo: **2 .png + 1 .svg** (icono). Nada más.
- Audio: **0 archivos** (ni música, ni efectos).
- Fuentes/modelos: ninguno.

**Cómo se ve el juego hoy (sin assets):**
- Mapa = **polígonos de color** (color del país) con contornos; capitales y rasgos = **emojis** (⭐, etc.).
- Unidades = **cuadrados de color** dibujados por código.
- UI = paneles/botones generados por código con el tema Retrowave.

**Conclusión:** el juego es **100% "programmer art"**. Es suficiente para un MVP funcional/prototipo, pero para beta/versión final falta producción de arte (banderas, retratos de líderes, iconos de unidad/recurso, fondo de mapa) y audio (música ambiente, efectos de batalla/UI). Eso es **producción de assets**, no programación.

---

## D. Post-MVP: dimensionamiento honesto (NO implementado — son sistemas/assets nuevos)

Estos no se "arreglan" con código en una sesión; son construcciones nuevas. Tamaño estimado:

| Sistema | Qué implica | Esfuerzo |
|---|---|---|
| **Combate naval diferenciado** | reglas de mar (la guerra se decidió en el mar): flotas, bloqueo, dominio marítimo, transporte anfibio | GRANDE |
| **Diplomacia** | alianzas, mediación de potencias, neutralidad ARG/BRA, negociar paz | GRANDE |
| **Audio** | música + efectos (producción + sistema de reproducción) | GRANDE (assets) |
| **Arte** | banderas, retratos, iconos, fondo de mapa, sprites de unidad | GRANDE (assets) |
| **Tecnología/equipo de época 1879** | árbol y módulos reales (Comblain, Chassepot, Krupp, monitores) en vez de proxies de 1918 | MEDIANO-GRANDE (datos) |
| **Geometría del resto del mundo** | 740 provincias sin polígono (o recortar el mapa al teatro) | MEDIANO (datos) |

Recomendación: para el MVP, **recortar el mapa al teatro** (sur de Sudamérica) en vez de dibujar el mundo entero, y dejar naval/diplomacia/arte/audio para beta.

---

## Estado final verificado
- Arranque: **0 errores**. Combate con profundidad (verificado). Rendimiento 3× mejor. 74 textos traducidos. "Volver al menú" funcional. Guardar/cargar íntegro.
- Lo que de verdad falta para un MVP **satisfactorio**: pulir (menú de inicio, tutorial, terminar idioma) y, para beta, producir **arte + audio** y los sistemas grandes (naval, diplomacia).
