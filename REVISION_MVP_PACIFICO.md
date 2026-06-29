# Revisión del MVP — Guerra del Pacífico 1879

> Análisis desde cero (sin confiar en los informes .md previos). Solo diagnóstico, no se modificó el juego.
> Cobertura: lectura profunda del camino crítico (arranque → carga de escenario → partida) + barridos automáticos sobre TODO el proyecto (referencias rotas, código incompleto, integridad de datos del escenario 1879) + **verificación en vivo con Godot 4.6 headless**.

## ✅ Verificado EN EJECUCIÓN (Godot 4.6, modo headless)

- **El proyecto compila sin ningún error de script** (los 148 archivos). El juego no está roto a nivel de código.
- **Producción y combate pasan sus pruebas** ([PASS] en stats de equipo, refinamiento, ancho de combate, etc.).
- **⚠️ El arranque del juego se CUELGA (>5 min sin terminar).** Al iniciar, `TestRunner` lanza una simulación de líderes pesada que recorre año por año con personajes de las **Guerras Mundiales** (George Patton, Heinz Guderian/1939) y carga los archivos de líderes de **1918, 1936 y 2026**. No hay `SCRIPT ERROR`, pero la simulación nunca termina en tiempo razonable. Esto **bloquea el arranque** y confirma en vivo los hallazgos #3 y #4.

---

## 🔴 CRÍTICO — afecta que el MVP se sienta jugable e histórico

1. **Las batallas navales icónicas no tienen efecto real (Iquique y Angamos).**
   Los eventos (`data/events/1879/batalla_iquique.json`, `batalla_angamos.json`) dañan/destruyen la unidad `per_naval_1879`. Pero las flotas reales se crean con IDs genéricos (`PER_formation_0`, `PER_formation_1`…) en `FormationSpawner.gd`. Como `per_naval_1879` no existe en el juego, el daño/hundimiento **nunca ocurre**: la muerte de Prat y la captura del Huáscar son solo texto.

2. **Las unidades históricas no usan sus estadísticas.**
   Existen plantillas detalladas (`data/unit_templates/1879/chl_naval_1879.json`, `per_infantry_1879.json`…), pero al iniciar, el juego despliega formaciones genéricas ("Division 1", "Fleet 1") y solo les asigna una provincia. Las stats históricas (ataque, defensa, organización) **no llegan al campo de batalla**.

3. **El código de pruebas corre dentro de la partida real.**
   La escena de juego es `TestScenario.tscn` y su script raíz es `TestRunner.gd`. Cada vez que el jugador inicia una partida se ejecutan baterías completas de tests (producción, autoloads, save/load, mapa, combate). Esto enlentece el arranque, puede lanzar errores en pantalla del jugador y es arquitectura frágil. El juego incluso imprime "Epochs of Ascendancy Test Starting".

4. **Los líderes de 1879 son los de la Primera Guerra Mundial.**
   `LeaderManager.gd` mapea el escenario `"1879"` al archivo de líderes de **1918**. No aparecen los personajes de la Guerra del Pacífico (Prat, Grau, Baquedano, Cáceres, Daza…).

---

## 🟠 IMPORTANTE — funciona a medias o no se puede confiar

5. **Parte de las pruebas de calidad están rotas.**
   `HeadlessSupplyTest.gd` y dos validadores QA cargan `res://scripts/core/ProductionLineTest.gd` y `SupplyLineTest.gd`, pero esos archivos están en `tests/`. La ruta equivocada devuelve `null` y crashea. Conclusión: los informes que dicen "todo pasa" **no son fiables**.

6. **56 marcadores de código incompleto** (TODO / stub / "NOT IMPLEMENTED") en sistemas del MVP:
   - `TradeManager.gd`: comercio prácticamente sin implementar ("WHAT IS NOT IMPLEMENTED YET").
   - `AgentManager.gd`: el sabotaje de agentes no aplica efectos reales (solo TODOs).
   - `SaveLoadManager.gd`: migración de partidas es un stub.
   (Esto va contra tu regla de "nada de placeholders/por implementar".)

7. **Provincias de relleno de la Segunda Guerra Mundial en el escenario.**
   `scenario.json` incluye capitales de Alemania, Francia, Inglaterra y EE.UU. (ids 2, 4, 5, 6) con fábricas — restos del andamiaje genérico. El propio archivo lo admite en `_audit_note`.

8. **Inconsistencia en la etiqueta del Reino Unido.**
   El escenario usa `ENG`, pero el archivo de país es `united_kingdom.json`. Verificar que el mapeo funcione (riesgo de que ese país no cargue bien).

9. **El reloj depende de la barra superior.**
   El tiempo solo avanza si `TopInfoBar` llama a `advance_real_time`. Si esa pieza falla, el juego se congela en la fecha inicial. Conviene verificarlo en ejecución.

---

## 🟡 MENOR — limpieza y claridad

10. **Nombre del proyecto obsoleto:** `project.godot` se llama "Epochs-of-Ascendancy" (debería ser Guerra del Pacífico).
11. **Menús duplicados:** `StartMenu` (el que se usa) y `MainMenu` (usado solo por la pantalla de victoria) — dos menús principales distintos.
12. **Archivo redundante:** `data/scenarios/1879.json` es un redirect que nunca se usa (el juego lee directo `1879/scenario.json`).
13. **Peso muerto:** todo el `data/` de la raíz (legado HOI2, miles de archivos) y los escenarios extra (1918, 1936, 2026) **no los usa el juego**. Confunden el MVP.
14. **Ruido documental:** 40+ informes .md de auditoría contradictorios en la carpeta del juego.
15. **Plantilla sin usar:** `chl_cavalry_1879` existe pero no aparece en las fuerzas iniciales.
16. **Antofagasta (prov. 841) doble:** nace ya controlada por Chile y además el evento de inicio la transfiere — redundante.

---

## Sugerencia de orden para el MVP
Primero 1–4 (que la guerra se vea y se sienta histórica), luego 5–6 (poder confiar en las pruebas y cerrar lo incompleto del comercio/guardado), después 7–9 (limpiar el escenario y confirmar que el tiempo corre), y al final la limpieza 10–16.
