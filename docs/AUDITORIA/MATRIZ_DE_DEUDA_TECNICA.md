# Matriz de deuda técnica (Fase 20: documentada + oculta)

## Deuda ya documentada por fases anteriores (verificada vigente)

| ID previo | Descripción | ¿Sigue vigente? | Hallazgo |
|---|---|---|---|
| DT-02 | class_name vs autoload | SÍ, y reincidió 2 veces más | 0001, 0002, 0035 |
| DT-P4-01 | Acoplamiento de cadena de compilación | SÍ — la cascada de hoy lo demuestra | 0003 |
| DT-P4-02 | Sin barrera fábricas↔diseños | SÍ | — |
| DT-P6-01 | Estados/regiones no expuestos | SÍ | 0010 |
| DT-P6-02 | Geometría 740/847 | SÍ (107 ahora) | 0008 |
| DT-P6-03 | Sin transferencia por estado | SÍ | 0010 |
| DT-P6-07 | Validador no integrado | SÍ | 0017 |
| DT-P4-08 | Formaciones de prueba | SÍ | 0007 |

## Deuda NO documentada hasta esta auditoría

| Nueva | Descripción | Origen (línea) | Hallazgo |
|---|---|---|---|
| D-N1 | starting_forces sin consumidor | scenario.json + scan 0 usos | 0006 |
| D-N2 | Posición de formaciones no persistida | LeaderManager.gd:2664 | 0009 |
| D-N3 | Economía IA cosmética (stockpile único + _ai_income sin gasto/persistencia) | ProductionManager.gd:40; NationalIncomeManager.gd:163 | 0012 |
| D-N4 | UI fuera del sistema de localización (203 textos) | scripts/ui/* | 0013 |
| D-N5 | RNG sin semilla (65 usos) | global | 0014 |
| D-N6 | ScenarioFactorySpawner paralelo huérfano | scripts/scenarios/ | 0015 |
| D-N7 | 3 tests headless sin runner | scripts/core/Headless* | 0016 |
| D-N8 | Heurística de combate por falta de plantillas | BattleManager.gd _combat_power | 0024 |
| D-N9 | Migración de saves stub | SaveLoadManager.gd:~760 | 0023 |
| D-N10 | 45 señales sin listener / 5 nunca emitidas | matriz integración | 0021, 0022 |
| D-N11 | Retirada sin origen rastreado | BattleManager.gd _retreat_formation | 0025 |
| D-N12 | TODO visible en menú principal | TopInfoBar.gd:424; MainMenu.gd:210 | 0020 |
| D-N13 | Carpeta residual duplicada | raíz del repo | 0011 |
| D-N14 | scenario_id "1936" hardcodeado inicial | SaveLoadManager.gd:317 | 0034 |
