# Informe de riesgos de rendimiento — Fase 0

## Monolitos

| Archivo | Líneas aproximadas | Riesgo |
|---|---:|---|
| scripts/map/ProvinceInsight.gd | 3.480 | Crítico |
| scripts/leaders/LeaderManager.gd | 2.944 | Crítico |
| scripts/map/MapRenderer.gd | 2.110 | Crítico |
| scripts/core/ProductionLineTest.gd | 1.325 | Alto, solo pruebas |
| scripts/autoload/ProductionManager.gd | 1.313 | Alto |
| scripts/technology/TechnologyManager.gd | 1.299 | Alto |
| scripts/agents/AgentManager.gd | 1.236 | Alto |
| scripts/national/TradeManager.gd | 1.158 | Alto |

## Hot paths

- `MapRenderer._process`: cámara, hover, pulsos y overlays por frame.
- `AgentNetworkLayer._process` y `BattleResultPopup._process`: actualización visual continua.
- Tick diario: suministro, producción, agentes, victoria y comercio.
- Pathfinder de suministro sobre hasta 847 provincias.
- Serialización completa del estado en el hilo principal.

## Presupuestos bloqueantes

- Startup Windows ≤10 s; Android ≤20 s.
- Save y load ≤3 s por operación.
- Tick diario, IA y suministro p95 ≤50 ms.
- Resolución de combate p95 ≤100 ms.
- Crecimiento neto de memoria entre turnos 10 y 1000 ≤10% tras calentamiento.

No se estimarán resultados: cada cifra deberá proceder del runner instrumentado y repetirse tres veces.
