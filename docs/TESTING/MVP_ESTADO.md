# Estado del MVP tras la sesión de reparación + simulación de partida

Fecha: 2026-06-12 · Todo verificado ejecutando el motor (Godot 4.6 headless).

## Lo que pediste (1)(2)(3) — RESUELTO y verificado

| Punto | Estado | Evidencia |
|---|---|---|
| (1) La IA juega | ✅ | Con jugador CHL, tropas enemigas se movieron (BOL 841→847, PER 844→843, 71→844) y provocaron batallas. (La causa de que antes no jugara era que las unidades no tenían posición; al desplegar `starting_forces` la IA ya puede actuar.) |
| (2) Feedback de batalla y victoria | ✅ | Tras una batalla el popup se hace visible; al cumplir victoria la pantalla aparece. Corregidos `BattleResultPopup` (theme_override_colors) y `VictoryScreen` (rutas de nodo mal: `$WinnerTitle`→`$CenterContainer/Panel/VBoxContainer/WinnerTitle`, etc.). |
| (3) Idioma UI | ✅ (alto tráfico) | 31 textos traducidos a español en 7 pantallas (menú, gestor de guardado, estados vacíos). Quedan textos en pantallas profundas. |

## Bugs descubiertos al SIMULAR LA PARTIDA — RESUELTOS

| Bug | Qué pasaba | Arreglo |
|---|---|---|
| Victoria instantánea | La guerra terminaba el **mes 1**: la victoria militar de Perú se cumplía al inicio (Perú nace con Lima+Arica+Iquique) | Victoria militar de Perú redefinida: debe **expulsar a Chile** (controlar las 3 del salitre, incl. Antofagasta) + conservar Lima |
| Guerra demasiado rápida | El combate instantáneo decidía la guerra en semanas | Las victorias militares solo cuentan a partir de **1880** (una campaña), no en las primeras semanas |
| Carga corrompía agentes | `Agent.traits` (Array[String]) se restauraba como Array sin tipo → error al cargar con agentes | rebuild tipado |

Tras los arreglos: **partida completa simulada de ~1 año con 0 errores** — eventos disparan, IA mueve, batallas se resuelven, victoria se alcanza, save/load a mitad funciona.

## Bugs latentes de guardado/carga corregidos en total esta sesión
`Leader.traits`, `Factory.assigned_lines`, `pending_retirements`, `pending_leader_replacements`, `Agent.traits` — todos eran asignaciones de `Array` a variables tipadas que **corrompían la carga en silencio**. Ahora la carga es limpia.

---

## ¿Qué falta para un MVP JUGABLE y satisfactorio?

El **bucle ya está completo y jugable de principio a fin**. Lo que separa "se puede jugar" de "es un buen MVP":

### 🔴 Lo más importante: profundidad y balance de combate
- Hoy el combate es **instantáneo y casi un cara o cruz** (heurística terreno+azar). Un movimiento = una batalla = captura. El territorio cambia de manos trivialmente y **Perú tiende a arrollar a Chile** (en la simulación Chile acababa con 1 provincia).
- Para que las **decisiones importen** hace falta: batallas con duración/frentes, que el equipo y la producción influyan (ligar formaciones a plantillas con stats reales), y que la ventaja defensiva/suministro pesen.
- **Sin esto, el juego funciona pero las decisiones del jugador apenas cambian el resultado.** Es la tarea nº1 de diseño para el MVP.

### 🟠 Pulido necesario
- **Rendimiento** a velocidad alta (~31 ms/día simulado): va a tirones a tope de velocidad.
- **Menú principal de inicio** real (Nueva/Cargar/Salir); hoy arranca en selección de nación y "volver al menú" es flojo.
- **Terminar la traducción** de las pantallas profundas (tecnología, líderes, agentes).
- **Onboarding/tutorial** mínimo (qué hago, cómo gano).

### 🟡 Post-MVP
- Geometría del resto del mapa (hoy solo el teatro es visible — suficiente para MVP).
- Equipo/tecnología de época real (hoy proxies de 1918).
- Simulación naval diferenciada, diplomacia, audio y arte.

## Veredicto
**Es jugable de extremo a extremo** (eliges Chile → ves eventos históricos → mueves y combates → ganas/pierdes → guardas/cargas). Para que sea un **MVP satisfactorio**, lo que más mueve la aguja es **dar profundidad al combate** (que el resultado dependa de tus decisiones, no del azar) y **pulir** (menú, rendimiento, idioma, tutorial).
