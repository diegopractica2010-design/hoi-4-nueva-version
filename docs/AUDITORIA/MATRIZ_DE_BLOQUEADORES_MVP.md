# Matriz de bloqueadores — MVP Guerra del Pacífico (Fase 19)

Clasificación del protocolo: BLOQUEA EJECUCIÓN > BLOQUEA MVP > BLOQUEA CRECIMIENTO > BLOQUEA VERSIÓN FINAL.

## BLOQUEA EJECUCIÓN (el juego no corre limpio hoy)
| Hallazgo | Qué es | Arreglo |
|---|---|---|
| 0001 | class_name EventManager (línea 1) | borrar 1 línea + comentario patrón |
| 0002 | class_name AIManager (línea 1) | borrar 1 línea + comentario patrón |
| 0003 | cascada SaveLoadManager/NationalIncomeManager | se resuelve sola con 0001/0002 |
| 0004 | BattleResultPopup.gd:42-43 `:=` sobre Variant | anotar `: int` |
| 0005 | VictoryScreen.gd:24 `:=` sobre Variant | anotar `: String` |

## BLOQUEA MVP (corre, pero no es la Guerra del Pacífico jugable)
| Hallazgo | Qué falta |
|---|---|
| 0006+0007 | fuerzas iniciales reales en Santiago/Antofagasta/Lima/Arica/Sucre/La Paz (consumir starting_forces; retirar formaciones de prueba) |
| 0009 | guardar posición de unidades (sin esto, guardar/cargar rompe la partida) |
| 0001 (tras revivir) | eventos históricos disparándose de verdad (Iquique, Angamos, Ancón) |
| 0002 (tras revivir) | IA moviéndose contra el jugador |
| 0024 | ligar formaciones a las 9 plantillas 1879 para que el combate use stats |
| 0005 | pantalla de victoria/derrota funcional |

## BLOQUEA CRECIMIENTO
| Hallazgo | Qué limita |
|---|---|
| 0008 | mapa 87% invisible (o se completa geometría o se recorta el mapa al teatro) |
| 0010 | anexión por estado (Tratado de Ancón como bloque) |
| 0012 | economía IA real |
| 0035+0003 | guard-rail contra el patrón que ya tumbó el boot 3 veces |
| 0016+0017 | tests/validador en CI |

## BLOQUEA VERSIÓN FINAL
| Tema | Detalle |
|---|---|
| 0013 | localización completa de la UI |
| 0018+0019 | equipo y tecnología de época (Comblain, Chassepot, Krupp, monitores) |
| Arte/Audio | inexistentes (3 png, 0 audio en el repo) |
| 0014 | determinismo con semilla por partida |
| Diplomacia/naval | sistemas no existentes |
