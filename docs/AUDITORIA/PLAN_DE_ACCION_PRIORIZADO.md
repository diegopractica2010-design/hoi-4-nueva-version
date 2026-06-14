# Plan de acción priorizado

Orden estricto: primero todo lo CRÍTICO, luego ALTO, MEDIO, BAJO.
Esfuerzo: P = pequeño (minutos/1 archivo) · M = mediano (1 sistema/varios archivos) · G = grande (sistema nuevo o transversal).
Cada acción cita su(s) hallazgo(s) para trazabilidad.

---

## BLOQUE 0 — CRÍTICO: devolver el arranque limpio (hacer HOY, en este orden)

| # | Acción | Archivo:línea | Esfuerzo | Hallazgo |
|---|---|---|---|---|
| 0.1 | Borrar `class_name EventManager` (dejar solo `extends Node` + comentario del patrón) | EventManager.gd:1 | P | 0001 |
| 0.2 | Borrar `class_name AIManager` (igual) | AIManager.gd:1 | P | 0002 |
| 0.3 | Anotar tipos: `var att_cas: int = ...` y `var def_cas: int = ...` | BattleResultPopup.gd:42-43 | P | 0004 |
| 0.4 | Anotar tipo: `var winner_name: String = ...` | VictoryScreen.gd:24 | P | 0005 |
| 0.5 | Re-importar proyecto y verificar boot headless = 0 errores (la cascada 0003 se cae sola) | — | P | 0003 |

**Resultado del bloque 0:** reviven eventos, IA, guardado, ingresos, popup de batalla y pantalla de victoria. Es el mayor retorno por esfuerzo de toda la lista.

---

## BLOQUE 1 — ALTO: evitar la recaída y proteger la partida

| # | Acción | Esfuerzo | Hallazgo |
|---|---|---|---|
| 1.1 | Script guard-rail (Python/pre-commit o validador de arranque) que compare `[autoload]` de project.godot contra los `class_name` de cada script y falle si coinciden | P | 0035, 0003 |
| 1.2 | Gate de integración: boot headless `--quit-after` obligatorio que devuelva error si hay `SCRIPT ERROR`, antes de cada push | P | 0033 |
| 1.3 | Serializar `province_id` e `is_moving` de las formaciones en `LeaderManager.get_save_data`/restauración | M | 0009 |
| 1.4 | Archivar `epochs-of-ascendancy/` a un zip externo y eliminar la carpeta del disco (probado: subconjunto estricto, sin pérdida) | P | 0011 |

---

## BLOQUE 2 — ALTO: convertir el sandbox en la Guerra del Pacífico jugable

| # | Acción | Esfuerzo | Hallazgo |
|---|---|---|---|
| 2.1 | Consumir `starting_forces` del escenario: al cargar, crear las 11 formaciones históricas con su `province_id` (Santiago, Antofagasta, Lima, Arica, Sucre, La Paz) y retirar el spawn de "formaciones de prueba" | M | 0006, 0007 |
| 2.2 | Ligar cada formación a una de las 9 plantillas de unidad 1879 para que `get_effective_combat_power` use stats reales en vez de la heurística | M | 0024 |
| 2.3 | Verificar en runtime el ciclo completo con eventos+IA vivos: 14-feb dispara guerra, IA mueve, Iquique/Angamos/Ancón ocurren | M | 0001, 0002 |
| 2.4 | Mapa: decidir y ejecutar — completar geometría faltante O recortar el mapa al teatro (sur de Sudamérica + capitales) | G | 0008 |
| 2.5 | Economía de la IA: stockpile por nación (o que la IA gaste `_ai_income`) y persistirlo | M | 0012 |
| 2.6 | UI de la barra superior: mostrar oro/mes (`get_nation_monthly_income`) y eliminar el TODO de "Return to Main Menu" | P | 0020 |

---

## BLOQUE 3 — MEDIO: solidez y crecimiento

| # | Acción | Esfuerzo | Hallazgo |
|---|---|---|---|
| 3.1 | Semilla RNG por partida (guardar/cargar la semilla) para reproducibilidad | M | 0014 |
| 3.2 | Implementar `_migrate_save_data` con versionado real de saves | M | 0023 |
| 3.3 | Exponer estado/región en runtime (`Province.state_id`) + transferencia por estado para el Tratado de Ancón | M | 0010 |
| 3.4 | Integrar `MapDataValidator` en el arranque/CI; conectar o eliminar los 3 tests headless huérfanos | P | 0016, 0017 |
| 3.5 | Eliminar el `ScenarioFactorySpawner` paralelo (o documentarlo como deprecado) | P | 0015 |
| 3.6 | UI: migrar los 203 textos `.text="..."` al sistema de localización; unificar idioma | M | 0013 |
| 3.7 | Retirada de batalla: rastrear provincia de origen del atacante para retroceder correctamente | P | 0025 |
| 3.8 | Conectar las señales de mayor valor sin listener (producción: progreso/escasez; agentes) a UI mínima | M | 0021 |
| 3.9 | Rotación de autosaves (3 slots) en vez de uno único | P | 0026 |

---

## BLOQUE 4 — BAJO / versión final

| # | Acción | Esfuerzo | Hallazgo |
|---|---|---|---|
| 4.1 | Datos de época: árbol tecnológico 1879 + equipo (Comblain, Chassepot, Krupp, monitores) — coordinar con consultor histórico | G | 0018, 0019 |
| 4.2 | Simulación naval diferenciada (la guerra se decidió en el mar) | G | cobertura histórica |
| 4.3 | Diplomacia (mediación de potencias, neutralidad ARG/BRA) | G | cobertura histórica |
| 4.4 | Arte y audio propios (hoy: 3 png, 0 audio) | G | — |
| 4.5 | Higiene: UID de WorldMap.tscn, fugas al salir, filtro almirante/división, 16 TODO | P | 0028-0032 |
| 4.6 | Onboarding/tutorial | M | UX |

---

## Camino crítico recomendado (resumen)
**Bloque 0 (hoy, ~1 hora) → Bloque 1 (esta semana) → Bloque 2 (sprint del MVP).**
Con el Bloque 0 el juego vuelve a estar entero; con el Bloque 2 es, por primera vez, la Guerra del Pacífico jugable de punta a punta con decisiones que importan.
